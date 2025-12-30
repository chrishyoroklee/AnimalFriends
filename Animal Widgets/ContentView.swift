//
//  ContentView.swift
//  Animal Widgets
//
//  Created by 이효록 on 12/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isEditing = false

    var body: some View {
        VStack {
            VStack(spacing: 12) {
                Text("Bear Widget")
                    .font(.title2.weight(.semibold))

                BearWidgetPreview()
                    .onTapGesture {
                        isEditing = true
                    }

                Text("Tap the widget to edit")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .sheet(isPresented: $isEditing) {
            BearEditorView()
        }
        .onOpenURL { url in
            if url.scheme == "animalwidgets" {
                isEditing = true
            }
        }
    }
}

#Preview {
    ContentView()
}
