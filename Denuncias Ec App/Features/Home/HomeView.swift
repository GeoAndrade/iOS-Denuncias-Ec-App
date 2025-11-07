import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var sessionService: SessionService
    let userEmail: String

    @StateObject private var formViewModel = ReportFormViewModel()
    @State private var activeAlert: HomeAlert?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HomeHeaderView(email: userEmail, onLogoutTap: {
                        activeAlert = .logout
                    })

                    ReportFormView(viewModel: formViewModel, onSubmit: saveReport)
                }
                .padding()
            }
            .background(Color(.systemBackground).ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .alert(item: $activeAlert) { alert in
                switch alert {
                case .logout:
                    return Alert(
                        title: Text("Cerrar sesión"),
                        message: Text("¿Deseas salir de DenunciasEcuador?"),
                        primaryButton: .destructive(Text("Cerrar sesión")) {
                            sessionService.logout()
                        },
                        secondaryButton: .cancel(Text("Cancelar"))
                    )
                case .summary(let draft):
                    return Alert(
                        title: Text("Denuncia lista"),
                        message: Text(summary(for: draft)),
                        dismissButton: .default(Text("OK")) {
                            finalizeSave(for: draft)
                        }
                    )
                }
            }
        }
    }

    private func saveReport() {
        do {
            let draft = try formViewModel.makeDraft(ownerEmail: userEmail)
            activeAlert = .summary(draft)
        } catch ReportFormError.invalidFields {
        } catch {
            formViewModel.errorMessage = "No se pudo preparar la denuncia. Intenta nuevamente."
        }
    }

    private func finalizeSave(for draft: ReportDraft) {
        do {
            try formViewModel.persist(draft: draft, modelContext: modelContext)
        } catch {
            formViewModel.errorMessage = "No se pudo guardar la denuncia. Intenta nuevamente."
        }
    }

    private func summary(for draft: ReportDraft) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        return """
        Título: \(draft.title)
        Ubicación: \(draft.cityProvince)
        Fecha: \(formatter.string(from: draft.eventDate))
        Visibilidad: \(draft.visibility.title)
        Tipo: \(draft.type.title)
        """
    }
}

private enum HomeAlert: Identifiable {
    case logout
    case summary(ReportDraft)

    var id: String {
        switch self {
        case .logout: return "logout"
        case .summary(let draft): return "summary_\(draft.title)"
        }
    }
}

#Preview {
    HomeView(sessionService: PreviewSamples.sessionService, userEmail: "demo@uni.edu")
        .modelContainer(PreviewSamples.container)
}
