//
//  ContentView.swift
//  Animal Widgets
//
//  Created by 이효록 on 12/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isEditing = false
    @AppStorage(BearSettings.bodyKey, store: BearSettings.defaults())
    private var bodyColorRaw = BearBodyColor.caramel.rawValue
    @AppStorage(BearSettings.shirtKey, store: BearSettings.defaults())
    private var shirtRaw = BearShirt.hoodie.rawValue
    @AppStorage(BearSettings.pantsKey, store: BearSettings.defaults())
    private var pantsRaw = BearPants.jeans.rawValue

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
        VStack {
            VStack(spacing: 12) {
                Text("Bear Widget")
                    .font(.title2.weight(.semibold))

                BearWidgetView(bodyColor: bodyColor, shirt: shirt, pants: pants)
                    .frame(maxWidth: 320)
                    .onTapGesture {
                        isEditing = true
                    }

                Text("Tap the widget to edit")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .sheet(isPresented: $isEditing) {
            BearEditorView(bodyColorRaw: $bodyColorRaw, shirtRaw: $shirtRaw, pantsRaw: $pantsRaw)
        }
        .onOpenURL { url in
            if url.scheme == "animalwidgets" {
                isEditing = true
            }
        }
    }
}

#Preview {
    ContentView()
}
