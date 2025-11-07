import SwiftUI
import SwiftData

struct MainTabView: View {
    @ObservedObject var sessionService: SessionService
    let userEmail: String
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            HomeView(sessionService: sessionService, userEmail: userEmail)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            HistoricoView(ownerEmail: userEmail)
                .tabItem {
                    Label("Histórico", systemImage: "clock.arrow.circlepath")
                }
                .tag(1)
        }
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        .toolbarColorScheme(.light, for: .tabBar)
    }
}

#Preview {
    MainTabView(sessionService: PreviewSamples.sessionService, userEmail: "demo@uni.edu")
        .modelContainer(PreviewSamples.container)
}
