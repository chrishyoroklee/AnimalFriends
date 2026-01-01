//
//  WidgetPreview.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct WidgetPreview: View {
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
        BearWidgetView(bodyColor: bodyColor, shirt: shirt, pants: pants)
            .frame(maxWidth: 320)
    }
}

#Preview {
    WidgetPreview()
        .padding()
}
