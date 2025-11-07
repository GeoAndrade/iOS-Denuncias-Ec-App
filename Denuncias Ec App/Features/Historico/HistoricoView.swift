import SwiftUI
import SwiftData

struct HistoricoView: View {
    private let ownerEmail: String
    @Query private var reports: [Report]

    init(ownerEmail: String) {
        self.ownerEmail = ownerEmail
        _reports = Query(
            filter: #Predicate<Report> { report in
                report.ownerEmail == ownerEmail
            },
            sort: [SortDescriptor(\.createdAt, order: .reverse)]
        )
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Histórico personal")
        }
    }

    @ViewBuilder
    private var content: some View {
        if reports.isEmpty {
            VStack(spacing: 12) {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                Text("No hay denuncias registradas")
                    .font(.headline)
                Text("Usa el formulario en Home para crear la primera.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        } else {
            List(reports) { report in
                ReportRowView(report: report)
                    .listRowInsets(.init(top: 12, leading: 12, bottom: 12, trailing: 12))
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
        }
    }
}

#Preview {
    HistoricoView(ownerEmail: "demo@uni.edu")
        .modelContainer(PreviewSamples.container)
}
