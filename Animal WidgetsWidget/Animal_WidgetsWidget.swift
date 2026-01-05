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
    let characterId: UUID
    let head: AnimalHead
    let kind: AnimalKind
}

struct BearProvider: TimelineProvider {
    func placeholder(in context: Context) -> BearEntry {
        BearEntry(
            date: .now,
            bodyColor: .caramel,
            shirt: .hoodie,
            pants: .jeans,
            name: "Pooh",
            characterId: UUID(),
            head: .bear,
            kind: .bear
        )
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
        let loaded = BearCharacterStore.load()
        let characters = loaded.0
        let activeId = loaded.1
        let active = characters.first { $0.id == activeId } ?? characters.first ?? BearCharacter.default()

        return BearEntry(
            date: .now,
            bodyColor: active.bodyColor,
            shirt: active.shirt,
            pants: active.pants,
            name: active.name.isEmpty ? "Pooh" : active.name,
            characterId: active.id,
            head: active.head,
            kind: active.kind
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
                BearLockScreenMiniView(
                    bodyColor: entry.bodyColor,
                    shirt: entry.shirt,
                    pants: entry.pants,
                    name: entry.name,
                    head: entry.head,
                    kind: entry.kind
                )
            default:
                AnimalCharacterView(
                    kind: entry.kind,
                    bodyColor: entry.bodyColor,
                    shirt: entry.shirt,
                    pants: entry.pants,
                    head: entry.head,
                    showsCard: false
                )
            }
        }
        .widgetURL(URL(string: "animalwidgets://edit?id=\(entry.characterId.uuidString)"))
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

private struct BearLockScreenMiniView: View {
    let bodyColor: BearBodyColor
    let shirt: BearShirt
    let pants: BearPants
    let name: String
    let head: AnimalHead
    let kind: AnimalKind

    var body: some View {
        HStack(spacing: 10) {
            AnimalCharacterView(
                kind: kind,
                bodyColor: bodyColor,
                shirt: shirt,
                pants: pants,
                head: head,
                showsCard: false
            )
            .frame(width: 70, height: 70)

            Text(name.isEmpty ? "Pooh" : name)
                .font(.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
    }
}

#Preview(as: .systemMedium) {
    Animal_WidgetsWidget()
} timeline: {
    BearEntry(
        date: .now,
        bodyColor: .caramel,
        shirt: .hoodie,
            pants: .jeans,
            name: "Pooh",
            characterId: UUID(),
            head: .bear,
            kind: .bear
        )
}
