//
//  SettingsView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(BearSettings.musicKey, store: BearSettings.defaults())
    private var musicSelection = "waltz1"

    var body: some View {
        List {
            Section("Settings") {
                HStack {
                    Text("Music")
                    Spacer()
                    Picker("Music", selection: $musicSelection) {
                        Text("Waltz 1").tag("waltz1")
                        Text("Waltz 2").tag("waltz2")
                        Text("Waltz 3").tag("waltz3")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }
                Button("Reset Account") { }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(AppTheme.background)
        .navigationTitle("Settings")
        .onChange(of: musicSelection) {
            AudioManager.shared.playLooping(track: musicSelection)
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
