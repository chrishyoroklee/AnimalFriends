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

    @Binding var bodyColorRaw: String
    @Binding var shirtRaw: String
    @Binding var pantsRaw: String

    private var bodyColor: BearBodyColor {
        BearBodyColor(rawValue: bodyColorRaw) ?? .caramel
    }

    private var shirt: BearShirt {
        BearShirt(rawValue: shirtRaw) ?? .hoodie
    }

    private var pants: BearPants {
        BearPants(rawValue: pantsRaw) ?? .jeans
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                BearWidgetView(bodyColor: bodyColor, shirt: shirt, pants: pants)
                    .frame(maxWidth: 280)

                Form {
                    Picker("Body Color", selection: $bodyColorRaw) {
                        ForEach(BearBodyColor.allCases) { color in
                            Text(color.label).tag(color.rawValue)
                        }
                    }

                    Picker("Shirt", selection: $shirtRaw) {
                        ForEach(BearShirt.allCases) { item in
                            Text(item.label).tag(item.rawValue)
                        }
                    }

                    Picker("Pants", selection: $pantsRaw) {
                        ForEach(BearPants.allCases) { item in
                            Text(item.label).tag(item.rawValue)
                        }
                    }
                }
                .onChange(of: bodyColorRaw) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onChange(of: shirtRaw) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .onChange(of: pantsRaw) { _ in
                    WidgetCenter.shared.reloadAllTimelines()
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
        bodyColorRaw: .constant(BearBodyColor.caramel.rawValue),
        shirtRaw: .constant(BearShirt.hoodie.rawValue),
        pantsRaw: .constant(BearPants.jeans.rawValue)
    )
}
