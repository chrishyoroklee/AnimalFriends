//
//  Animal_WidgetsApp.swift
//  Animal Widgets
//
//  Created by 이효록 on 12/30/25.
//

import SwiftUI

@main
struct Animal_WidgetsApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                StoreView()
                    .tabItem {
                        Label("Store", systemImage: "bag")
                    }
            }
        }
    }
}
