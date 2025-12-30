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
}

struct BearProvider: TimelineProvider {
    func placeholder(in context: Context) -> BearEntry {
        BearEntry(date: .now, bodyColor: .caramel, shirt: .hoodie, pants: .jeans)
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
            pants: BearPants(rawValue: pantsRaw) ?? .jeans
        )
    }
}

struct Animal_WidgetsWidgetEntryView: View {
    let entry: BearProvider.Entry

    var body: some View {
        BearWidgetView(bodyColor: entry.bodyColor, shirt: entry.shirt, pants: entry.pants)
            .widgetURL(URL(string: "animalwidgets://edit"))
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
        .supportedFamilies([.systemMedium])
    }
}

#Preview(as: .systemMedium) {
    Animal_WidgetsWidget()
} timeline: {
    BearEntry(date: .now, bodyColor: .caramel, shirt: .hoodie, pants: .jeans)
}
