//
//  Animal_WidgetsWidget.swift
//  Animal WidgetsWidget
//
//  Created by Codex.
//

import SwiftUI
import WidgetKit

struct BearEntry: TimelineEntry {
    let date: Date
    let bodyColor: BearBodyColor
    let shirt: BearShirt
    let pants: BearPants
    let name: String
}

struct BearProvider: TimelineProvider {
    func placeholder(in context: Context) -> BearEntry {
        BearEntry(date: .now, bodyColor: .caramel, shirt: .hoodie, pants: .jeans, name: "Pooh")
    }

    func getSnapshot(in context: Context, completion: @escaping (BearEntry) -> Void) {
        completion(loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BearEntry>) -> Void) {
        let entry = loadEntry()
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    private func loadEntry() -> BearEntry {
        let defaults = BearSettings.defaults()
        let bodyRaw = defaults.string(forKey: BearSettings.bodyKey) ?? BearBodyColor.caramel.rawValue
        let shirtRaw = defaults.string(forKey: BearSettings.shirtKey) ?? BearShirt.hoodie.rawValue
        let pantsRaw = defaults.string(forKey: BearSettings.pantsKey) ?? BearPants.jeans.rawValue

        return BearEntry(
            date: .now,
            bodyColor: BearBodyColor(rawValue: bodyRaw) ?? .caramel,
            shirt: BearShirt(rawValue: shirtRaw) ?? .hoodie,
            pants: BearPants(rawValue: pantsRaw) ?? .jeans,
            name: defaults.string(forKey: BearSettings.nameKey) ?? "Pooh"
        )
    }
}

struct Animal_WidgetsWidgetEntryView: View {
    let entry: BearProvider.Entry
    @Environment(\.widgetFamily) private var family

    var body: some View {
        Group {
            switch family {
            case .accessoryRectangular:
                BearLockScreenView(
                    bodyColor: entry.bodyColor,
                    shirt: entry.shirt,
                    pants: entry.pants,
                    name: entry.name
                )
            default:
                BearWidgetView(bodyColor: entry.bodyColor, shirt: entry.shirt, pants: entry.pants, showsCard: false)
            }
        }
        .widgetURL(URL(string: "animalwidgets://edit"))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct Animal_WidgetsWidget: Widget {
    let kind = "Animal_WidgetsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BearProvider()) { entry in
            Animal_WidgetsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bear Widget")
        .description("Pick a bear outfit and show it on your home screen.")
        .supportedFamilies([.systemMedium, .accessoryRectangular])
    }
}

private struct BearLockScreenView: View {
    let bodyColor: BearBodyColor
    let shirt: BearShirt
    let pants: BearPants
    let name: String

    var body: some View {
        HStack(spacing: 10) {
            Circle()
                .fill(bodyColor.color)
                .frame(width: 36, height: 36)
                .overlay(
                    HStack(spacing: 6) {
                        Circle().fill(Color.black.opacity(0.75)).frame(width: 4, height: 4)
                        Circle().fill(Color.black.opacity(0.75)).frame(width: 4, height: 4)
                    }
                    .offset(y: -2)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(name.isEmpty ? "Pooh" : name)
                    .font(.caption.weight(.semibold))
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(shirt.color)
                        .frame(width: 18, height: 10)
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(pants.color)
                        .frame(width: 18, height: 10)
                }
            }
        }
        .padding(.horizontal, 6)
    }
}

#Preview(as: .systemMedium) {
    Animal_WidgetsWidget()
} timeline: {
    BearEntry(date: .now, bodyColor: .caramel, shirt: .hoodie, pants: .jeans, name: "Pooh")
}
