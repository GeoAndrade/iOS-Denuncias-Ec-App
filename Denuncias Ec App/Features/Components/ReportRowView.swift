import SwiftUI

struct ReportRowView: View {
    let report: Report

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Label {
                    Text(report.type.title)
                        .font(.subheadline.weight(.semibold))
                } icon: {
                    Image(systemName: report.type.iconName)
                        .foregroundStyle(typeColor)
                        .font(.title3)
                }
                .labelStyle(.titleAndIcon)

                Spacer()

                Text(report.visibility == .publico ? "Pública" : "Privada")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(report.visibility == .publico ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .foregroundStyle(report.visibility == .publico ? .green : .orange)
                    .clipShape(Capsule())
            }

            Text(report.title)
                .font(.headline)

            Text(report.details.isEmpty ? "Sin descripción" : report.details)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            VStack(alignment: .leading, spacing: 6) {
                Label(normalizedLocation, systemImage: "mappin.and.ellipse")
                Label(dateTimeString, systemImage: "calendar.badge.clock")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)

            Text("Registrado por \(report.ownerEmail)")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var typeColor: Color {
        switch report.type {
        case .aseoYOrnato:
            return .green
        case .transitoVial:
            return .orange
        case .delito:
            return .red
        }
    }

    private var normalizedLocation: String {
        let trimmed = report.cityProvince.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        guard trimmed.count >= 2 else { return report.cityProvince }
        let first = trimmed[0]
        let second = trimmed[1]
        if provinceNames.contains(String(second)), !provinceNames.contains(String(first)) {
            return "\(second), \(first)"
        }
        return "\(first), \(second)"
    }

    private var dateTimeString: String {
        let dateText = ReportRowView.formatters.date.string(from: report.eventDate)
        let timeText = ReportRowView.formatters.time.string(from: report.eventDate)
        return "\(dateText) a las \(timeText)"
    }
}

private let provinceNames: Set<String> = {
    Set(EcuadorLocationCatalog.provinces.map(\.name))
}()

private enum ReportRowFormatters {
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_EC")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let time: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_EC")
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
}

private extension ReportRowView {
    static var formatters: ReportRowFormatters.Type { ReportRowFormatters.self }
}

#Preview {
    ReportRowView(report: PreviewSamples.report)
        .padding()
}
