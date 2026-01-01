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

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(model.characters) { character in
                        Button {
                            model.activeId = character.id
                            editingId = character.id
                            isEditing = true
                        } label: {
                            VStack(spacing: 10) {
                                Text(character.name.isEmpty ? "Pooh" : character.name)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                BearWidgetView(
                                    bodyColor: character.bodyColor,
                                    shirt: character.shirt,
                                    pants: character.pants
                                )
                                .frame(maxWidth: 320)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                        .buttonStyle(.plain)
                    }

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
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                .foregroundStyle(.secondary)
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding()
            }
            .navigationTitle("Animal Widgets")
        }
        .sheet(isPresented: $isEditing) {
            if let editingId, let binding = binding(for: editingId) {
                BearEditorView(character: binding)
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
                if let activeId = model.activeId {
                    editingId = activeId
                    isEditing = true
                }
            }
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
