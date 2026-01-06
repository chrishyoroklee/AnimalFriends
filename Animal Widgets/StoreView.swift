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
    @State private var showingConfirm = false
    @State private var pendingItem: StoreItem?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text("Balance")
                            .font(.headline)
                        Spacer()
                        Text("\(cashBalance)")
                            .font(.headline)
                    }
                }

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
                                    pendingItem = item
                                    showingConfirm = true
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
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Shop")
        }
        .onAppear {
            ownedItemIds = Set(InventoryStore.load())
        }
        .alert("Confirm Purchase", isPresented: $showingConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Buy", role: .destructive) {
                if let item = pendingItem {
                    buy(item)
                }
            }
        } message: {
            if let item = pendingItem {
                Text("Buy \(item.name) for \(item.price)?")
            }
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
