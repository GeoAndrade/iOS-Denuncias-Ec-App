import SwiftUI

struct RootView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var sessionService = SessionService()
    @State private var hasSeededSampleData = false

    var body: some View {
        Group {
            if let email = sessionService.currentUserEmail {
                MainTabView(sessionService: sessionService, userEmail: email)
            } else {
                LoginView(viewModel: AuthViewModel(), sessionService: sessionService)
            }
        }
        .animation(.easeInOut, value: sessionService.isAuthenticated)
        .task {
            await seedSampleReportsIfNeeded()
        }
    }

    @MainActor
    private func seedSampleReportsIfNeeded() async {
        guard !hasSeededSampleData else { return }
        do {
            try SampleDataSeeder.seedReportsIfNeeded(in: modelContext)
            hasSeededSampleData = true
        } catch {
            print("No se pudo sembrar datos de ejemplo: \(error)")
        }
    }
}
