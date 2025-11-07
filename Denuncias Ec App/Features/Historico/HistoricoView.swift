import SwiftUI
import SwiftData

struct HistoricoView: View {
    private let ownerEmail: String
    @Query(sort: [SortDescriptor(\Report.createdAt, order: .reverse)])
    private var storedReports: [Report]

    init(ownerEmail: String) {
        self.ownerEmail = ownerEmail
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Histórico de denuncias")
        }
        .background(Color(.systemBackground).ignoresSafeArea())
    }

    @ViewBuilder
    private var content: some View {
        if filteredReports.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("No hay denuncias registradas")
                    .font(.headline)
                Text("Usa el formulario en el inicio para crear una denuncia.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        } else {
            List(filteredReports) { report in
                ReportRowView(report: report)
                    .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
        }
    }

    private var filteredReports: [Report] {
        storedReports.filter { report in
            report.visibility == .publico || report.ownerEmail == ownerEmail
        }
    }
}

#Preview {
    HistoricoView(ownerEmail: "demo@example.com")
        .modelContainer(PreviewSamples.container)
}
