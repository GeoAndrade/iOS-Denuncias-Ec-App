import SwiftUI
import Combine

@MainActor
final class SessionService: ObservableObject {
    @AppStorage("currentUserEmail", store: .standard) private var storedEmail: String?
    @Published private(set) var currentUserEmail: String?

    init() {
        currentUserEmail = storedEmail
    }

    var isAuthenticated: Bool {
        currentUserEmail != nil
    }

    func login(with email: String) {
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        storedEmail = normalizedEmail
        currentUserEmail = normalizedEmail
    }

    func logout() {
        storedEmail = nil
        currentUserEmail = nil
    }
}
