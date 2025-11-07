//
//  Denuncias_Ec_AppApp.swift
//  Denuncias Ec App
//
//  Created by Geovanny Norberto Moreno Andrade on 6/11/25.
//

import SwiftUI
import SwiftData

@main
struct Denuncias_Ec_AppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
