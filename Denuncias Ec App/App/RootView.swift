import SwiftUI

struct RootView: View {
    @StateObject private var sessionService = SessionService()

    var body: some View {
        Group {
            if let email = sessionService.currentUserEmail {
                MainTabView(sessionService: sessionService, userEmail: email)
            } else {
                LoginView(viewModel: AuthViewModel(), sessionService: sessionService)
            }
        }
        .animation(.easeInOut, value: sessionService.isAuthenticated)
    }
}
