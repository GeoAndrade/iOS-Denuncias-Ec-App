import SwiftUI
import SwiftData

@main
struct DenunciasEcuadorApp: App {
    private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            Report.self
        ])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

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
}
