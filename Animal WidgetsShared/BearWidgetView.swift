//
//  BearWidgetView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct BearWidgetView: View {
    let bodyColor: BearBodyColor
    let shirt: BearShirt
    let pants: BearPants

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)

            VStack(spacing: 10) {
                BearHead(bodyColor: bodyColor.color)
                BearOutfit(bodyColor: bodyColor.color, shirt: shirt, pants: pants)
            }
            .padding(18)
        }
        .aspectRatio(1.6, contentMode: .fit)
    }
}

private struct BearHead: View {
    let bodyColor: Color

    var body: some View {
        ZStack {
            HStack(spacing: 30) {
                Circle()
                    .fill(bodyColor.opacity(0.9))
                    .frame(width: 28, height: 28)
                Circle()
                    .fill(bodyColor.opacity(0.9))
                    .frame(width: 28, height: 28)
            }
            .offset(y: -10)

            Circle()
                .fill(bodyColor)
                .frame(width: 80, height: 80)

            HStack(spacing: 14) {
                Circle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 8, height: 8)
                Circle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 8, height: 8)
            }
            .offset(y: -4)

            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.black.opacity(0.75))
                .frame(width: 20, height: 14)
                .offset(y: 12)
        }
        .padding(.bottom, 6)
    }
}

private struct BearOutfit: View {
    let bodyColor: Color
    let shirt: BearShirt
    let pants: BearPants

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(bodyColor)
                .frame(width: 120, height: 110)

            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(shirt.color)
                    .frame(width: 110, height: 56)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(pants.color)
                    .frame(width: 100, height: 48)
            }
        }
    }
}

#Preview {
    BearWidgetView(bodyColor: .caramel, shirt: .hoodie, pants: .jeans)
        .frame(width: 320)
        .padding()
}
