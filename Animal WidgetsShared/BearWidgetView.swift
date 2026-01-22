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
    let head: AnimalHead
    var showsCard: Bool = true

    var body: some View {
        GeometryReader { proxy in
            let designSize = CGSize(width: 320, height: 200)
            let scale = min(proxy.size.width / designSize.width, proxy.size.height / designSize.height)

            ZStack {
                if showsCard {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                }

                VStack(spacing: 10) {
                    AnimalHeadView(head: head, bodyColor: bodyColor.color)
                    BearOutfit(bodyColor: bodyColor.color, shirt: shirt, pants: pants)
                }
                .padding(18)
            }
            .frame(width: designSize.width, height: designSize.height)
            .scaleEffect(scale)
            .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
        }
    }
}

struct AnimalCharacterView: View {
    let kind: AnimalKind
    let bodyColor: BearBodyColor
    let shirt: BearShirt
    let pants: BearPants
    let head: AnimalHead
    var showsCard: Bool = true

    var body: some View {
        switch kind {
        case .bear:
            BearWidgetView(
                bodyColor: bodyColor,
                shirt: shirt,
                pants: pants,
                head: head,
                showsCard: showsCard
            )
        }
    }
}

private struct AnimalHeadView: View {
    let head: AnimalHead
    let bodyColor: Color

    var body: some View {
        switch head {
        case .bear:
            BearHead(bodyColor: bodyColor)
        case .cat:
            CatHead(bodyColor: bodyColor)
        case .dog:
            DogHead(bodyColor: bodyColor)
        }
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

private struct CatHead: View {
    let bodyColor: Color

    var body: some View {
        ZStack {
            HStack(spacing: 28) {
                Triangle()
                    .fill(bodyColor.opacity(0.95))
                    .frame(width: 24, height: 22)
                Triangle()
                    .fill(bodyColor.opacity(0.95))
                    .frame(width: 24, height: 22)
            }
            .offset(y: -18)

            Circle()
                .fill(bodyColor)
                .frame(width: 80, height: 80)

            HStack(spacing: 14) {
                Circle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 7, height: 7)
                Circle()
                    .fill(Color.black.opacity(0.75))
                    .frame(width: 7, height: 7)
            }
            .offset(y: -4)

            Circle()
                .fill(Color.black.opacity(0.75))
                .frame(width: 14, height: 14)
                .offset(y: 10)
        }
        .padding(.bottom, 6)
    }
}

private struct DogHead: View {
    let bodyColor: Color

    var body: some View {
        ZStack {
            HStack(spacing: 36) {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(bodyColor.opacity(0.9))
                    .frame(width: 22, height: 36)
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(bodyColor.opacity(0.9))
                    .frame(width: 22, height: 36)
            }
            .offset(y: -4)

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
                .frame(width: 18, height: 12)
                .offset(y: 12)
        }
        .padding(.bottom, 6)
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
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
    BearWidgetView(bodyColor: .caramel, shirt: .hoodie, pants: .jeans, head: .bear)
        .frame(width: 320)
        .padding()
}
