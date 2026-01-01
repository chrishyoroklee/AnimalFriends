//
//  StoreView.swift
//  Animal Widgets
//
//  Created by Codex.
//

import SwiftUI

struct StoreView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "bag")
                    .font(.system(size: 44, weight: .semibold))
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Shop")
        }
    }
}

#Preview {
    StoreView()
}
