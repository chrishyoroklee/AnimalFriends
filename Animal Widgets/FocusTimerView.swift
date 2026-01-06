//
//  FocusTimerView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct FocusTimerView: View {
    @Environment(\.dismiss) private var dismiss
    let onReward: (Int) -> Void

    @State private var minutes = 10
    @State private var remainingSeconds = 0
    @State private var isRunning = false
    @State private var rewardMinutes = 0
    @State private var didComplete = false
    @State private var showingStopConfirm = false

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Focus Session")
                    .font(.title2.weight(.semibold))

                Text(timeString)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()

                VStack(spacing: 10) {
                    Text("Minutes: \(minutes)")
                        .font(.headline)

                    FocusSlider(
                        value: $minutes,
                        range: 1...120,
                        isEnabled: !isRunning
                    )
                    .frame(height: 44)
                    .padding(.horizontal)
                }

                if didComplete {
                    Text("You earned \(rewardMinutes) cash!")
                        .font(.headline)
                        .foregroundStyle(.green)
                } else {
                    Text("Earn 1 cash per minute when you finish.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 12) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)

                    if isRunning {
                        Button("Stop") {
                            showingStopConfirm = true
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("Start") {
                            startSession()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding(.top, 6)

                Spacer()
            }
            .padding()
            .background(AppTheme.secondary.ignoresSafeArea())
            .onReceive(timer) { _ in
                guard isRunning else { return }
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    stopSession(reward: true)
                }
            }
            .navigationTitle("FOCUS")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            remainingSeconds = minutes * 60
            AudioManager.shared.playLooping(track: "waltz3")
        }
        .onChange(of: minutes) {
            guard !isRunning else { return }
            remainingSeconds = minutes * 60
        }
        .onDisappear {
            AudioManager.shared.playLooping(track: "waltz1")
        }
        .alert("Stop Focus Session?", isPresented: $showingStopConfirm) {
            Button("Keep Going", role: .cancel) { }
            Button("Stop", role: .destructive) {
                stopSession(reward: false)
            }
        } message: {
            Text("You won't earn cash unless you finish the full timer.")
        }
    }

    private var timeString: String {
        let total = isRunning ? remainingSeconds : minutes * 60
        let min = total / 60
        let sec = total % 60
        return String(format: "%02d:%02d", min, sec)
    }

    private func startSession() {
        didComplete = false
        rewardMinutes = minutes
        remainingSeconds = minutes * 60
        isRunning = true
    }

    private func stopSession(reward: Bool) {
        isRunning = false
        if reward {
            didComplete = true
            onReward(rewardMinutes)
        }
    }
}

private struct FocusSlider: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let isEnabled: Bool

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let knobSize: CGFloat = 30
            let trackHeight: CGFloat = 8
            let clamped = min(max(value, range.lowerBound), range.upperBound)
            let progress = CGFloat(clamped - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound)
            let x = progress * (width - knobSize) + knobSize / 2

            ZStack(alignment: .leading) {
                Capsule(style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: trackHeight)

                Capsule(style: .continuous)
                    .fill(isEnabled ? Color.black : Color(.systemGray3))
                    .frame(width: x, height: trackHeight)

                Circle()
                    .fill(isEnabled ? Color.black : Color(.systemGray3))
                    .frame(width: knobSize, height: knobSize)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.6), lineWidth: 2)
                    )
                    .position(x: x, y: trackHeight / 2)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { gesture in
                        guard isEnabled else { return }
                        let clampedX = min(max(gesture.location.x, 0), width)
                        let percent = clampedX / width
                        let rawValue = Int(round(percent * CGFloat(range.upperBound - range.lowerBound))) + range.lowerBound
                        value = min(max(rawValue, range.lowerBound), range.upperBound)
                    }
            )
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    FocusTimerView { _ in }
}
