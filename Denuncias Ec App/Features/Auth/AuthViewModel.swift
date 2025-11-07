import Foundation
import Combine
import SwiftData

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    func submit(modelContext: ModelContext, sessionService: SessionService) {
        errorMessage = nil
        let normalizedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let cleanPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)

        guard Validators.isValidEmail(normalizedEmail) else {
            errorMessage = "Por favor ingresa un correo válido."
            return
        }

        guard Validators.isValidPassword(cleanPassword) else {
            errorMessage = "La contraseña debe tener al menos 6 caracteres."
            return
        }

        isLoading = true
        defer { isLoading = false }

        do {
            var descriptor = FetchDescriptor<User>(
                predicate: #Predicate { $0.email == normalizedEmail },
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            descriptor.fetchLimit = 1

            if let existingUser = try modelContext.fetch(descriptor).first {
                guard existingUser.password == cleanPassword else {
                    errorMessage = "Contraseña incorrecta."
                    return
                }
                sessionService.login(with: existingUser.email)
                return
            }

            let newUser = User(email: normalizedEmail, password: cleanPassword)
            modelContext.insert(newUser)
            try modelContext.save()
            sessionService.login(with: normalizedEmail)
        } catch {
            errorMessage = "Ocurrió un error al procesar tus datos. Intenta de nuevo."
        }
    }
}
