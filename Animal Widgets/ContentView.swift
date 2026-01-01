//
//  ContentView.swift
//  Animal Widgets
//
//  Created by 이효록 on 12/30/25.
//

import SwiftUI
import WidgetKit

final class BearCharacterListModel: ObservableObject {
    @Published var characters: [BearCharacter]
    @Published var activeId: UUID?

    init() {
        let loaded = BearCharacterStore.load()
        characters = loaded.0
        activeId = loaded.1 ?? loaded.0.first?.id
    }

    func add(name: String) {
        let newCharacter = BearCharacter.default(name: name)
        characters.append(newCharacter)
        activeId = newCharacter.id
    }

    func delete(at offsets: IndexSet) {
        characters.remove(atOffsets: offsets)
        if let activeId, !characters.contains(where: { $0.id == activeId }) {
            self.activeId = characters.first?.id
        }
    }
}

struct ContentView: View {
    @State private var isEditing = false
    @StateObject private var model = BearCharacterListModel()
    @State private var newName = ""
    @State private var editingId: UUID?
    @State private var isCreating = false
    @State private var showingDeleteConfirm = false
    @State private var pendingDeleteOffsets: IndexSet = []
    @State private var showingShareSheet = false
    @State private var pendingShareName = ""

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(model.characters) { character in
                        let isActive = character.id == model.activeId
                        Button {
                            model.activeId = character.id
                            editingId = character.id
                            isEditing = true
                        } label: {
                            VStack(spacing: 10) {
                                HStack(spacing: 8) {
                                    if isActive {
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(.yellow)
                                    }
                                    Text(character.name.isEmpty ? "Pooh" : character.name)
                                        .font(.headline)
                                    Spacer()
                                    Menu {
                                        Button("Share with a friend") {
                                            pendingShareName = character.name.isEmpty ? "Pooh" : character.name
                                            showingShareSheet = true
                                        }
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundStyle(.secondary)
                                    }
                                    .buttonStyle(.plain)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)

                                BearWidgetView(
                                    bodyColor: character.bodyColor,
                                    shirt: character.shirt,
                                    pants: character.pants,
                                    head: character.head
                                )
                                .frame(maxWidth: 320)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(isActive ? Color(red: 0.93, green: 0.88, blue: 0.98) : Color.clear)
                            )
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            Button {
                                model.activeId = character.id
                            } label: {
                                Label("Use", systemImage: "star.fill")
                            }
                            .tint(.green)
                        }
                    }
                    .onDelete { offsets in
                        pendingDeleteOffsets = offsets
                        showingDeleteConfirm = true
                    }
                }

                Section {
                    Button {
                        newName = ""
                        isCreating = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Character")
                        }
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Animal Widgets")
        }
        .sheet(isPresented: $isEditing) {
            if let editingId, let binding = binding(for: editingId) {
                EditorView(character: binding)
            }
        }
        .sheet(isPresented: $isCreating) {
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.secondary.opacity(0.35))
                    .frame(width: 44, height: 5)
                    .padding(.top, 12)

                Text("New Character")
                    .font(.headline)

                TextField("Name", text: $newName)
                    .textInputAutocapitalization(.words)
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(.secondarySystemBackground))
                    )
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    Button("Cancel") {
                        isCreating = false
                    }
                    .buttonStyle(.bordered)

                    Button("Create") {
                        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                        model.add(name: trimmed.isEmpty ? "Pooh" : trimmed)
                        isCreating = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 20)
            }
            .presentationDetents([.height(220)])
        }
        .onChange(of: model.characters) {
            BearCharacterStore.save(characters: model.characters, activeId: model.activeId)
            WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
        }
        .onChange(of: model.activeId) {
            BearCharacterStore.save(characters: model.characters, activeId: model.activeId)
            WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
        }
        .onOpenURL { url in
            if url.scheme == "animalwidgets" {
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                let idParam = components?.queryItems?.first(where: { $0.name == "id" })?.value
                let parsedId = idParam.flatMap(UUID.init)

                if let parsedId {
                    model.activeId = parsedId
                    editingId = parsedId
                    isEditing = true
                } else if let activeId = model.activeId {
                    editingId = activeId
                    isEditing = true
                }
            }
        }
        .alert("Delete Character?", isPresented: $showingDeleteConfirm) {
            Button("Cancel", role: .cancel) {
                pendingDeleteOffsets = []
            }
            Button("Delete", role: .destructive) {
                model.delete(at: pendingDeleteOffsets)
                pendingDeleteOffsets = []
            }
        } message: {
            Text("This will remove the character and its outfit.")
        }
        .alert("Share with a friend", isPresented: $showingShareSheet) {
            Button("OK") { }
        } message: {
            Text("Sharing for \(pendingShareName) is coming soon.")
        }
    }

    private func binding(for id: UUID) -> Binding<BearCharacter>? {
        guard let index = model.characters.firstIndex(where: { $0.id == id }) else {
            return nil
        }
        return Binding(
            get: { model.characters[index] },
            set: { model.characters[index] = $0 }
        )
    }
}

#Preview {
    ContentView()
}
