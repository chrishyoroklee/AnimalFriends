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

    func add(kind: AnimalKind) {
        let newCharacter = BearCharacter.default(kind: kind)
        characters.append(newCharacter)
        activeId = newCharacter.id
    }

    func hasCharacter(of kind: AnimalKind) -> Bool {
        characters.contains { $0.kind == kind }
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

                                Text(character.kind.label)
                                    .font(.headline)
                                Spacer()
                                Menu {
                                    Button("Share with a friend") {
                                        pendingShareName = character.kind.label
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

                if !model.hasCharacter(of: .bear) {
                    Section {
                        Button {
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
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(AppTheme.background)
            .navigationTitle("Farm House")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 6) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(AppTheme.primary)
                        Text("\(cashBalance)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                }
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
            cashBalance = BearSettings.defaults().integer(forKey: BearSettings.cashKey)
        }
        .onReceive(NotificationCenter.default.publisher(for: UserDefaults.didChangeNotification, object: BearSettings.defaults())) { _ in
            cashBalance = BearSettings.defaults().integer(forKey: BearSettings.cashKey)
        }
        .onReceive(NotificationCenter.default.publisher(for: .cashBalanceDidChange)) { _ in
            cashBalance = BearSettings.defaults().integer(forKey: BearSettings.cashKey)
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

                Text("Add Bear to your farm")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)

                Image("Bear1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 160, height: 180)
                    .padding()

                HStack(spacing: 12) {
                    Button("Cancel") {
                        isCreating = false
                    }
                    .buttonStyle(.bordered)

                    Button("Create") {
                        model.add(kind: .bear)
                        isCreating = false
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.bottom, 20)
            }
            .presentationDetents([.height(340)])
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

#Preview {
    ContentView()
}
