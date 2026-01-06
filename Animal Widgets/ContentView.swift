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

    func add(name: String, kind: AnimalKind) {
        let newCharacter = BearCharacter.default(name: name, kind: kind)
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
    @State private var selectedKind: AnimalKind = .bear
    @State private var editingId: UUID?
    @State private var isCreating = false
    @State private var showingDeleteConfirm = false
    @State private var pendingDeleteOffsets: IndexSet = []
    @State private var showingShareSheet = false
    @State private var pendingShareName = ""
    @AppStorage(BearSettings.cashKey, store: BearSettings.defaults())
    private var cashBalance = 250
    @AppStorage(BearSettings.musicKey, store: BearSettings.defaults())
    private var musicSelection = "waltz1"
    @State private var showingFocus = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(model.characters) { character in
                        let isActive = character.id == model.activeId
                        VStack(spacing: 10) {
                            HStack(spacing: 8) {
                                Button {
                                    model.activeId = character.id
                                } label: {
                                    Image(systemName: isActive ? "star.fill" : "star")
                                        .foregroundStyle(isActive ? .yellow : .secondary)
                                }
                                .buttonStyle(.plain)

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

                            AnimalCharacterView(
                                kind: character.kind,
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
                        .contentShape(Rectangle())
                        .onTapGesture {
                            model.activeId = character.id
                            editingId = character.id
                            isEditing = true
                        }
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
                        selectedKind = .bear
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
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Balance: \(cashBalance)")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
        }
        .onAppear {
            AudioManager.shared.playLooping(track: musicSelection)
        }
        .overlay(alignment: .bottom) {
            Button {
                showingFocus = true
            } label: {
                Text("FOCUS")
                    .font(.headline.weight(.heavy))
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 44)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.black)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
            }
            .padding(.bottom, 70)
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

                Text("Choose your starter")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                HStack(spacing: 12) {
                    CharacterOptionCard(
                        title: "Bear",
                        isSelected: selectedKind == .bear
                    ) {
                        BearWidgetView(
                            bodyColor: .caramel,
                            shirt: .hoodie,
                            pants: .jeans,
                            head: .bear,
                            showsCard: false
                        )
                    } action: {
                        selectedKind = .bear
                    }

                    CharacterOptionCard(
                        title: "Pig",
                        isSelected: selectedKind == .pig
                    ) {
                        Image("PigCharacter")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                    } action: {
                        selectedKind = .pig
                    }

                    CharacterOptionCard(
                        title: "Pig 2",
                        isSelected: selectedKind == .pig2
                    ) {
                        Image("Pig2")
                            .resizable()
                            .scaledToFit()
                            .padding(.vertical, 10)
                            .padding(.horizontal, 12)
                    } action: {
                        selectedKind = .pig2
                    }
                }
                .frame(maxWidth: 360)
                .padding(.horizontal)

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
                        model.add(name: trimmed.isEmpty ? "Pooh" : trimmed, kind: selectedKind)
                        isCreating = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 20)
            }
            .presentationDetents([.height(360)])
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
        .sheet(isPresented: $showingFocus) {
            FocusTimerView { minutes in
                cashBalance += minutes
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

private struct CharacterOptionCard<Preview: View>: View {
    let title: String
    let isSelected: Bool
    let preview: Preview
    let action: () -> Void

    init(
        title: String,
        isSelected: Bool,
        @ViewBuilder preview: () -> Preview,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isSelected = isSelected
        self.preview = preview()
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                preview
                    .frame(width: 140, height: 110)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
                    )

                Text(title)
                    .font(.caption.weight(.semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? Color(red: 0.93, green: 0.88, blue: 0.98) : Color(.secondarySystemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(isSelected ? Color(red: 0.60, green: 0.42, blue: 0.90) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
