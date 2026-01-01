//
//  ProfileView.swift
//  Animal Widgets
//
//  Created by 이효록 on 1/1/26.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "person")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
