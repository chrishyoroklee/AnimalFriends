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
    var kindRaw: String
    var headRaw: String
    var bodyColorRaw: String
    var shirtRaw: String
    var pantsRaw: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case kindRaw
        case headRaw
        case bodyColorRaw
        case shirtRaw
        case pantsRaw
    }

    init(
        id: UUID,
        name: String,
        kindRaw: String,
        headRaw: String,
        bodyColorRaw: String,
        shirtRaw: String,
        pantsRaw: String
    ) {
        self.id = id
        self.name = name
        self.kindRaw = kindRaw
        self.headRaw = headRaw
        self.bodyColorRaw = bodyColorRaw
        self.shirtRaw = shirtRaw
        self.pantsRaw = pantsRaw
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? "Pooh"
        kindRaw = try container.decodeIfPresent(String.self, forKey: .kindRaw) ?? AnimalKind.bear.rawValue
        headRaw = try container.decodeIfPresent(String.self, forKey: .headRaw) ?? AnimalHead.bear.rawValue
        bodyColorRaw = try container.decodeIfPresent(String.self, forKey: .bodyColorRaw) ?? BearBodyColor.caramel.rawValue
        shirtRaw = try container.decodeIfPresent(String.self, forKey: .shirtRaw) ?? BearShirt.hoodie.rawValue
        pantsRaw = try container.decodeIfPresent(String.self, forKey: .pantsRaw) ?? BearPants.jeans.rawValue
    }

    var kind: AnimalKind {
        AnimalKind(rawValue: kindRaw) ?? .bear
    }

    var bodyColor: BearBodyColor {
        BearBodyColor(rawValue: bodyColorRaw) ?? .caramel
    }

    var shirt: BearShirt {
        BearShirt(rawValue: shirtRaw) ?? .hoodie
    }

    var pants: BearPants {
        BearPants(rawValue: pantsRaw) ?? .jeans
    }

    var head: AnimalHead {
        AnimalHead(rawValue: headRaw) ?? .bear
    }

    static func `default`(name: String = "Pooh", kind: AnimalKind = .bear) -> BearCharacter {
        BearCharacter(
            id: UUID(),
            name: name,
            kindRaw: kind.rawValue,
            headRaw: AnimalHead.bear.rawValue,
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
            kindRaw: AnimalKind.bear.rawValue,
            headRaw: AnimalHead.bear.rawValue,
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
