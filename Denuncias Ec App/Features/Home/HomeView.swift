import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var sessionService: SessionService
    let userEmail: String

    @StateObject private var formViewModel = ReportFormViewModel()
    @StateObject private var publicReportsViewModel = PublicReportsViewModel()
    @State private var selectedRange: PublicReportRange = .ultimoDia
    @State private var showLogoutConfirmation = false
    @State private var confirmationMessage: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    HomeHeaderView(email: userEmail, onLogoutTap: { showLogoutConfirmation = true })

                    ReportFormView(viewModel: formViewModel, onSubmit: saveReport)

                    if let confirmationMessage {
                        Text(confirmationMessage)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    PublicReportsSection(
                        reports: publicReportsViewModel.reports,
                        selectedRange: $selectedRange,
                        isLoading: publicReportsViewModel.isLoading,
                        errorMessage: publicReportsViewModel.lastError
                    )
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(.systemGroupedBackground))
            .onAppear(perform: loadPublicReports)
            .onChange(of: selectedRange) { _ in loadPublicReports() }
            .confirmationDialog("¿Cerrar sesión?", isPresented: $showLogoutConfirmation, titleVisibility: .visible) {
                Button("Cerrar sesión", role: .destructive) {
                    sessionService.logout()
                }
                Button("Cancelar", role: .cancel) {}
            }
        }
    }

    private func saveReport() {
        do {
            try formViewModel.saveReport(modelContext: modelContext, ownerEmail: userEmail)
            confirmationMessage = "Denuncia registrada con éxito."
            loadPublicReports()
        } catch ReportFormError.invalidFields {
            confirmationMessage = nil
        } catch {
            confirmationMessage = "No se pudo guardar la denuncia. Intenta nuevamente."
        }
    }

    private func loadPublicReports() {
        publicReportsViewModel.loadReports(range: selectedRange, modelContext: modelContext)
    }
}

#Preview {
    HomeView(sessionService: PreviewSamples.sessionService, userEmail: "demo@uni.edu")
        .modelContainer(PreviewSamples.container)
}
