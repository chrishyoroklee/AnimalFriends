//
//  AudioManager.swift
//  Animal Widgets
//
//  Created by Codex.
//

import AVFoundation
import Foundation

final class AudioManager {
    static let shared = AudioManager()

    private var player: AVAudioPlayer?
    private var fadeTimer: Timer?
    private var currentTrack: String?

    private init() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true, options: [])
    }

    func playLooping(track name: String, fileExtension: String = "mp3", fadeDuration: TimeInterval = 0.6) {
        guard currentTrack != name else { return }
        currentTrack = name

        let fadeOutDuration = min(0.3, fadeDuration / 2)
        fadeOut(duration: fadeOutDuration) { [weak self] in
            self?.startNewTrack(name: name, fileExtension: fileExtension, fadeDuration: fadeDuration)
        }
    }

    private func startNewTrack(name: String, fileExtension: String, fadeDuration: TimeInterval) {
        guard let url = Bundle.main.url(forResource: name, withExtension: fileExtension) else { return }
        player = try? AVAudioPlayer(contentsOf: url)
        player?.numberOfLoops = -1
        player?.volume = 0
        player?.prepareToPlay()
        player?.play()
        fadeIn(duration: fadeDuration)
    }

    private func fadeOut(duration: TimeInterval, completion: @escaping () -> Void) {
        guard let player else {
            completion()
            return
        }
        fadeTimer?.invalidate()
        let steps = max(Int(duration / 0.05), 1)
        let step = player.volume / Float(steps)
        var remaining = steps

        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] timer in
            guard let self else {
                timer.invalidate()
                return
            }
            if remaining <= 0 {
                player.stop()
                timer.invalidate()
                completion()
                return
            }
            player.volume = max(player.volume - step, 0)
            remaining -= 1
        }
    }

    private func fadeIn(duration: TimeInterval) {
        guard let player else { return }
        fadeTimer?.invalidate()
        let steps = max(Int(duration / 0.05), 1)
        let step = 1.0 / Float(steps)
        var remaining = steps

        fadeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if remaining <= 0 {
                player.volume = 1.0
                timer.invalidate()
                return
            }
            player.volume = min(player.volume + step, 1.0)
            remaining -= 1
        }
    }

    func currentTrackName() -> String? {
        currentTrack
    }
}
