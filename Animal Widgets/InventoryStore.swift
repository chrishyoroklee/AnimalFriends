//
//  InventoryStore.swift
//  Animal Widgets
//
//  Created by Codex.
//

import Foundation

struct StoreItem: Identifiable {
    let id: String
    let name: String
    let category: String
    let price: Int
    let icon: String
}

let demoStoreItems: [StoreItem] = [
    StoreItem(id: "shirt.cozy", name: "Cozy Shirt", category: "Shirt", price: 20, icon: "tshirt"),
    StoreItem(id: "hat.sunny", name: "Sunny Hat", category: "Hat", price: 20, icon: "sun.max")
]

enum InventoryStore {
    static func load() -> [String] {
        let defaults = BearSettings.defaults()
        guard let data = defaults.data(forKey: BearSettings.inventoryKey),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return decoded
    }

    static func save(_ ids: [String]) {
        let defaults = BearSettings.defaults()
        let data = try? JSONEncoder().encode(ids)
        defaults.set(data, forKey: BearSettings.inventoryKey)
    }
}
