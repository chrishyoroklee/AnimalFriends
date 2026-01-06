//
//  InventoryView.swift
//  Animal Widgets
//
//  Created by 이효록 on 1/1/26.
//

import SwiftUI

struct InventoryView: View {
    @State private var ownedItems: [StoreItem] = []

    var body: some View {
        NavigationStack {
            List {
                if ownedItems.isEmpty {
                    Section {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 40, weight: .semibold))
                                .foregroundStyle(.secondary)
                            Text("No items yet")
                                .font(.headline)
                            Text("Buy items from the shop to see them here.")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                    }
                } else {
                    Section("Owned Items") {
                        ForEach(ownedItems) { item in
                            HStack(spacing: 12) {
                                Image(systemName: item.icon)
                                    .font(.title2)
                                    .frame(width: 30)
                                    .foregroundStyle(.secondary)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text(item.category)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Inventory")
        }
        .onAppear {
            let ownedIds = Set(InventoryStore.load())
            ownedItems = demoStoreItems.filter { ownedIds.contains($0.id) }
        }
    }
}

#Preview {
    InventoryView()
}
