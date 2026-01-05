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

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Focus Session")
                    .font(.title2.weight(.semibold))

                Text(timeString)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .monospacedDigit()

                Stepper("Minutes: \(minutes)", value: $minutes, in: 1...120)
                    .disabled(isRunning)
                    .padding(.horizontal)

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
                            stopSession(reward: false)
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

#Preview {
    FocusTimerView { _ in }
}
