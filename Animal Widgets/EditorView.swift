//
//  EditorView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI
import WidgetKit

struct EditorView: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var character: BearCharacter
    @State private var showingRename = false
    @State private var renameText = ""
    @State private var activeSheet: EditorSheet?

    private var bodyColor: BearBodyColor {
        BearBodyColor(rawValue: character.bodyColorRaw) ?? .caramel
    }

    private var shirt: BearShirt {
        BearShirt(rawValue: character.shirtRaw) ?? .hoodie
    }

    private var pants: BearPants {
        BearPants(rawValue: character.pantsRaw) ?? .jeans
    }

    private var head: AnimalHead {
        AnimalHead(rawValue: character.headRaw) ?? .bear
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    Menu {
                        ForEach(BearBodyColor.allCases) { color in
                            Button {
                                character.bodyColorRaw = color.rawValue
                            } label: {
                                HStack(spacing: 10) {
                                    Text(color.label)
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                                        .fill(color.color)
                                        .frame(width: 28, height: 16)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                                .stroke(Color.black.opacity(0.15), lineWidth: 1)
                                        )
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            HStack(spacing: 6) {
                                Text("Color")
                                    .font(.caption.weight(.semibold))
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(bodyColor.color)
                                    .frame(width: 28, height: 16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )

                            HStack(spacing: 6) {
                                Text("Wardrobe")
                                    .font(.caption.weight(.semibold))
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color(.systemGray4))
                                    .frame(width: 28, height: 16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .stroke(Color.black.opacity(0.15), lineWidth: 1)
                                    )
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color(.secondarySystemBackground))
                            )
                        }
                    }
                    .buttonStyle(.plain)

                    ZStack {
                        BearWidgetView(bodyColor: bodyColor, shirt: shirt, pants: pants, head: head)
                        EditorHitTargets { selection in
                            switch selection {
                            case .shirt:
                                activeSheet = .shirt
                            case .pants:
                                activeSheet = .pants
                            case .head:
                                activeSheet = .head
                            }
                        }
                    }
                    .frame(maxWidth: 360)
                    .frame(maxWidth: .infinity)
                }

                Spacer(minLength: 12)
            }
            .onChange(of: character.bodyColorRaw) {
                WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
            }
            .onChange(of: character.shirtRaw) {
                WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
            }
            .onChange(of: character.pantsRaw) {
                WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
            }
            .onChange(of: character.name) {
                WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
            }
            .onChange(of: character.headRaw) {
                WidgetCenter.shared.reloadTimelines(ofKind: "Animal_WidgetsWidget")
            }
            .padding()
            .navigationTitle(character.name.isEmpty ? "Pooh" : character.name)
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(character.name.isEmpty ? "Pooh" : character.name)
                        .font(.headline)
                        .onLongPressGesture {
                            renameText = character.name.isEmpty ? "Pooh" : character.name
                            showingRename = true
                        }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .alert("Rename Character", isPresented: $showingRename) {
                TextField("Name", text: $renameText)
                    .textInputAutocapitalization(.words)
                Button("Cancel", role: .cancel) { }
                Button("Save") {
                    let trimmed = renameText.trimmingCharacters(in: .whitespacesAndNewlines)
                    character.name = trimmed.isEmpty ? "Pooh" : trimmed
                }
            } message: {
                Text("Hold the title to rename.")
            }
            .sheet(item: $activeSheet) { sheet in
                NavigationStack {
                    Form {
                        switch sheet {
                        case .shirt:
                            Picker("Shirt", selection: $character.shirtRaw) {
                                ForEach(BearShirt.allCases) { item in
                                    Text(item.label).tag(item.rawValue)
                                }
                            }
                        case .pants:
                            Picker("Pants", selection: $character.pantsRaw) {
                                ForEach(BearPants.allCases) { item in
                                    Text(item.label).tag(item.rawValue)
                                }
                            }
                        case .head:
                            Picker("Head", selection: $character.headRaw) {
                                ForEach(AnimalHead.allCases) { item in
                                    Text(item.label).tag(item.rawValue)
                                }
                            }
                        }
                    }
                    .navigationTitle(sheet.title)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") { activeSheet = nil }
                        }
                    }
                }
                .presentationDetents([.height(240)])
            }
        }
    }
}

private enum EditorSheet: String, Identifiable {
    case head
    case shirt
    case pants

    var id: String { rawValue }
    var title: String {
        switch self {
        case .head: return "Head"
        case .shirt: return "Shirt"
        case .pants: return "Pants"
        }
    }
}

private struct EditorHitTargets: View {
    enum Selection {
        case head
        case shirt
        case pants
    }

    var onSelect: (Selection) -> Void

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let shirtRect = CGRect(
                x: size.width * 0.27,
                y: size.height * 0.38,
                width: size.width * 0.46,
                height: size.height * 0.22
            )
            let pantsRect = CGRect(
                x: size.width * 0.30,
                y: size.height * 0.60,
                width: size.width * 0.40,
                height: size.height * 0.20
            )
            let headRect = CGRect(
                x: size.width * 0.38,
                y: size.height * 0.10,
                width: size.width * 0.24,
                height: size.height * 0.22
            )

            Color.clear
                .contentShape(Rectangle())

            Button(action: { onSelect(.shirt) }) {
                Color.clear
            }
            .frame(width: shirtRect.width, height: shirtRect.height)
            .position(x: shirtRect.midX, y: shirtRect.midY)

            Button(action: { onSelect(.pants) }) {
                Color.clear
            }
            .frame(width: pantsRect.width, height: pantsRect.height)
            .position(x: pantsRect.midX, y: pantsRect.midY)

            Button(action: { onSelect(.head) }) {
                Color.clear
            }
            .frame(width: headRect.width, height: headRect.height)
            .position(x: headRect.midX, y: headRect.midY)
        }
    }
}

#Preview {
    EditorView(
        character: .constant(BearCharacter.default(name: "Pooh"))
    )
}
