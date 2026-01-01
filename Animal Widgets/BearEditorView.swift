//
//  BearEditorView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI
import WidgetKit

struct BearEditorView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var character: BearCharacter
    @State private var showingRename = false
    @State private var renameText = ""

    private var bodyColor: BearBodyColor {
        BearBodyColor(rawValue: character.bodyColorRaw) ?? .caramel
    }

    private var shirt: BearShirt {
        BearShirt(rawValue: character.shirtRaw) ?? .hoodie
    }

    private var pants: BearPants {
        BearPants(rawValue: character.pantsRaw) ?? .jeans
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                BearWidgetView(bodyColor: bodyColor, shirt: shirt, pants: pants)
                    .frame(maxWidth: 280)

                Form {
                    Picker("Body Color", selection: $character.bodyColorRaw) {
                        ForEach(BearBodyColor.allCases) { color in
                            Text(color.label).tag(color.rawValue)
                        }
                    }

                    Picker("Shirt", selection: $character.shirtRaw) {
                        ForEach(BearShirt.allCases) { item in
                            Text(item.label).tag(item.rawValue)
                        }
                    }

                    Picker("Pants", selection: $character.pantsRaw) {
                        ForEach(BearPants.allCases) { item in
                            Text(item.label).tag(item.rawValue)
                        }
                    }
                }
                .onChange(of: character.bodyColorRaw) {
                    WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
                }
                .onChange(of: character.shirtRaw) {
                    WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
                }
                .onChange(of: character.pantsRaw) {
                    WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
                }
                .onChange(of: character.name) {
                    WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
                }
            }
            .padding()
            .navigationTitle(character.name.isEmpty ? "Pooh" : character.name)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(character.name.isEmpty ? "Pooh" : character.name)
                        .font(.headline)
                        .onLongPressGesture {
                            renameText = character.name.isEmpty ? "Pooh" : character.name
                            showingRename = true
                        }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Rename Character", isPresented: $showingRename) {
                TextField("Name", text: $renameText)
                    .textInputAutocapitalization(.words)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
                    character.name = trimmed.isEmpty ? "Pooh" : trimmed
                }
            } message: {
                Text("Hold the title to rename.")
            }
        }
    }
}

#Preview {
    BearEditorView(
        character: .constant(BearCharacter.default(name: "Pooh"))
    )
}
