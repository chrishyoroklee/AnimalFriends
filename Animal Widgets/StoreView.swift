//
//  StoreView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct StoreView: View {
    @AppStorage(BearSettings.cashKey, store: BearSettings.defaults())
    private var cashBalance = 250
    @State private var ownedItemIds: Set<String> = []

    var body: some View {
        NavigationStack {
            List {
                Section("Items") {
                    ForEach(demoStoreItems) { item in
                        let isOwned = ownedItemIds.contains(item.id)
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

                            Spacer()

                            if isOwned {
                                Text("Owned")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            } else {
                                Button("Buy \(item.price)") {
                                    buy(item)
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(cashBalance < item.price)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Shop")
        }
        .onAppear {
            ownedItemIds = Set(InventoryStore.load())
        }
    }

    private func buy(_ item: StoreItem) {
        guard cashBalance >= item.price else { return }
        cashBalance -= item.price
        ownedItemIds.insert(item.id)
        InventoryStore.save(Array(ownedItemIds))
    }
}

#Preview {
    StoreView()
}
