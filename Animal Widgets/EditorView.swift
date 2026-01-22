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
    @State private var bearImageIndex = 1

    private let maxBearImages = 6

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack(spacing: 10) {
                    HStack(spacing: 20) {
                        Button {
                            if bearImageIndex > 1 {
                                bearImageIndex -= 1
                            } else {
                                bearImageIndex = maxBearImages
                            }
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.title)
                                .foregroundStyle(.primary.opacity(0.7))
                        }
                        .buttonStyle(.plain)

                        Image("Bear\(bearImageIndex)")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 240, maxHeight: 280)

                        Button {
                            if bearImageIndex < maxBearImages {
                                bearImageIndex += 1
                            } else {
                                bearImageIndex = 1
                            }
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.title)
                                .foregroundStyle(.primary.opacity(0.7))
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity)

                    Text("Bear \(bearImageIndex)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)
            }
            .padding()
            .navigationTitle("Bear")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    EditorView(
        character: .constant(BearCharacter.default())
    )
}
