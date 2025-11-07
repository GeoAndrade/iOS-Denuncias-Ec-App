import SwiftUI

struct ReportRowView: View {
    let report: Report

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(report.title)
                    .font(.headline)
                Spacer()
                Text(report.visibility == .publico ? "Pública" : "Privada")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(report.visibility == .publico ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                    .clipShape(Capsule())
            }

            Text(report.details.isEmpty ? "Sin descripción" : report.details)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(3)

            HStack {
                Label(report.type.title, systemImage: "tag")
                Label(report.cityProvince, systemImage: "mappin.and.ellipse")
                Spacer()
                Text(report.createdAt, style: .date)
                    .font(.caption)
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color(.secondarySystemBackground), in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ReportRowView(report: PreviewSamples.report)
        .padding()
        .previewLayout(.sizeThatFits)
}
