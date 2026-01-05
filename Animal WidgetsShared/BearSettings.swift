//
//  BearSettings.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

enum BearBodyColor: String, CaseIterable, Identifiable {
    case caramel
    case cocoa
    case espresso
    case mist

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .caramel: return Color(red: 0.80, green: 0.63, blue: 0.42)
        case .cocoa: return Color(red: 0.62, green: 0.45, blue: 0.30)
        case .espresso: return Color(red: 0.39, green: 0.28, blue: 0.19)
        case .mist: return Color(red: 0.88, green: 0.88, blue: 0.88)
        }
    }

    var label: String {
        rawValue.capitalized
    }
}

enum BearShirt: String, CaseIterable, Identifiable {
    case hoodie
    case tee
    case jacket

    var id: String { rawValue }

    var label: String {
        switch self {
        case .hoodie: return "Hoodie"
        case .tee: return "Tee"
        case .jacket: return "Jacket"
        }
    }

    var color: Color {
        switch self {
        case .hoodie: return Color(red: 0.29, green: 0.47, blue: 0.77)
        case .tee: return Color(red: 0.85, green: 0.36, blue: 0.34)
        case .jacket: return Color(red: 0.20, green: 0.20, blue: 0.23)
        }
    }
}

enum BearPants: String, CaseIterable, Identifiable {
    case shorts
    case jeans

    var id: String { rawValue }

    var label: String {
        switch self {
        case .shorts: return "Shorts"
        case .jeans: return "Jeans"
        }
    }

    var color: Color {
        switch self {
        case .shorts: return Color(red: 0.25, green: 0.59, blue: 0.51)
        case .jeans: return Color(red: 0.19, green: 0.32, blue: 0.57)
        }
    }
}

enum AnimalHead: String, CaseIterable, Identifiable, Codable {
    case bear
    case cat
    case dog

    var id: String { rawValue }

    var label: String {
        rawValue.capitalized
    }
}

enum AnimalKind: String, CaseIterable, Identifiable, Codable {
    case bear
    case pig
    case pig2

    var id: String { rawValue }

    var label: String {
        switch self {
        case .bear:
            return "Bear"
        case .pig:
            return "Pig"
        case .pig2:
            return "Pig 2"
        }
    }
}

struct BearSettings {
    static let appGroupID = "group.com.hyoroklee.animalfriends"

    static let bodyKey = "bear.bodyColor"
    static let shirtKey = "bear.shirt"
    static let pantsKey = "bear.pants"
    static let nameKey = "bear.name"
    static let cashKey = "user.cash"

    static func defaults() -> UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }
}
