import SwiftUI
import SwiftData
import Foundation

@main
struct DenunciasEcuadorApp: App {
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Report.self
        ])

        let storeURL = Self.makeStoreURL()
        let configuration = ModelConfiguration(
            schema: schema,
            url: storeURL
        )

        do {
            return try ModelContainer(for: schema, configurations: [configuration])
        } catch {
            fatalError("No se pudo crear el ModelContainer: \(error.localizedDescription)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .modelContainer(sharedModelContainer)
    }

    private static func makeStoreURL() -> URL {
        let support = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = support.appendingPathComponent("DenunciasEcApp", isDirectory: true)
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        } catch {
            print("No se pudo crear el directorio de datos: \(error)")
        }
        return directory.appendingPathComponent("default.store")
    }
}
