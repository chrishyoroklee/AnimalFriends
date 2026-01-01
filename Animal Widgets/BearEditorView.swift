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
                    Section("Name") {
                        TextField("Name", text: $character.name)
                            .textInputAutocapitalization(.words)
                    }

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
            .navigationTitle("Edit Bear")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    BearEditorView(
        character: .constant(BearCharacter.default(name: "Pooh"))
    )
}
