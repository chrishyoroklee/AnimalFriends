//
//  BearCharacter.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct BearCharacter: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var bodyColorRaw: String
    var shirtRaw: String
    var pantsRaw: String

    var bodyColor: BearBodyColor {
        BearBodyColor(rawValue: bodyColorRaw) ?? .caramel
    }

    var shirt: BearShirt {
        BearShirt(rawValue: shirtRaw) ?? .hoodie
    }

    var pants: BearPants {
        BearPants(rawValue: pantsRaw) ?? .jeans
    }

    static func `default`(name: String = "Pooh") -> BearCharacter {
        BearCharacter(
            id: UUID(),
            name: name,
            bodyColorRaw: BearBodyColor.caramel.rawValue,
            shirtRaw: BearShirt.hoodie.rawValue,
            pantsRaw: BearPants.jeans.rawValue
        )
    }
}

enum BearCharacterStore {
    static let charactersKey = "bear.characters"
    static let activeKey = "bear.activeId"

    static func load() -> ([BearCharacter], UUID?) {
        let defaults = BearSettings.defaults()

        if let data = defaults.data(forKey: charactersKey),
           let characters = try? JSONDecoder().decode([BearCharacter].self, from: data),
           !characters.isEmpty {
            let activeId = defaults.string(forKey: activeKey).flatMap(UUID.init)
            return (characters, activeId)
        }

        let legacyBody = defaults.string(forKey: BearSettings.bodyKey) ?? BearBodyColor.caramel.rawValue
        let legacyShirt = defaults.string(forKey: BearSettings.shirtKey) ?? BearShirt.hoodie.rawValue
        let legacyPants = defaults.string(forKey: BearSettings.pantsKey) ?? BearPants.jeans.rawValue
        let legacyName = defaults.string(forKey: BearSettings.nameKey) ?? "Pooh"

        let legacy = BearCharacter(
            id: UUID(),
            name: legacyName,
            bodyColorRaw: legacyBody,
            shirtRaw: legacyShirt,
            pantsRaw: legacyPants
        )
        save(characters: [legacy], activeId: legacy.id)
        return ([legacy], legacy.id)
    }

    static func save(characters: [BearCharacter], activeId: UUID?) {
        let defaults = BearSettings.defaults()
        let data = try? JSONEncoder().encode(characters)
        defaults.set(data, forKey: charactersKey)
        defaults.set(activeId?.uuidString, forKey: activeKey)
    }
}
