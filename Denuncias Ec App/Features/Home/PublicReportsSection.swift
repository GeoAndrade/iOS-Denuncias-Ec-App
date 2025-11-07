import SwiftUI
import Combine
import SwiftData

struct PublicReportsSection: View {
    let reports: [Report]
    @Binding var selectedRange: PublicReportRange
    let isLoading: Bool
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Denuncias públicas")
                    .font(.headline)
                Spacer()
                Picker("Rango", selection: $selectedRange) {
                    ForEach(PublicReportRange.allCases) { range in
                        Text(range.title).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 220)
            }

            if let errorMessage {
                Text(errorMessage)
                    .font(.footnote)
                    .foregroundStyle(.red)
            } else if isLoading {
                ProgressView("Consultando denuncias...")
                    .frame(maxWidth: .infinity)
            } else if reports.isEmpty {
                Text("No hay denuncias en el periodo seleccionado.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                VStack(spacing: 12) {
                    ForEach(reports) { report in
                        ReportRowView(report: report)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
}

enum PublicReportRange: String, CaseIterable, Identifiable {
    case ultimoDia
    case ultimaSemana

    var id: String { rawValue }

    var title: String {
        switch self {
        case .ultimoDia: return "Último día"
        case .ultimaSemana: return "Última semana"
        }
    }

    func startDate(from reference: Date) -> Date {
        let calendar = Calendar.current
        switch self {
        case .ultimoDia:
            return calendar.date(byAdding: .day, value: -1, to: reference) ?? reference
        case .ultimaSemana:
            return calendar.date(byAdding: .day, value: -7, to: reference) ?? reference
        }
    }
}

@MainActor
final class PublicReportsViewModel: ObservableObject {
    @Published private(set) var reports: [Report] = []
    @Published private(set) var isLoading = false
    @Published private(set) var lastError: String?

    func loadReports(range: PublicReportRange, modelContext: ModelContext) {
        isLoading = true
        lastError = nil

        do {
            let referenceDate = Date()
            let startDate = range.startDate(from: referenceDate)
            let targetVisibility = ReportVisibility.publico
            let predicate = #Predicate<Report> {
                $0.visibility == targetVisibility && $0.createdAt >= startDate
            }
            let descriptor = FetchDescriptor<Report>(
                predicate: predicate,
                sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
            )
            let fetched = try modelContext.fetch(descriptor)
            reports = fetched
            isLoading = false
        } catch {
            reports = []
            lastError = "No se pudieron cargar las denuncias públicas."
            isLoading = false
        }
    }
}

#Preview {
    PreviewStateWrapper(.ultimoDia) { binding in
        PublicReportsSection(
            reports: [PreviewSamples.report],
            selectedRange: binding,
            isLoading: false,
            errorMessage: nil
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
