import SwiftUI
import Combine
import SwiftData

struct ReportFormView: View {
    @ObservedObject var viewModel: ReportFormViewModel
    var onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Registro de denuncia")
                .font(.headline)

            TextField("Título", text: $viewModel.title)
                .textInputAutocapitalization(.sentences)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

            TextEditor(text: $viewModel.details)
                .frame(minHeight: 120)
                .padding(8)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    Group {
                        if viewModel.details.isEmpty {
                            Text("Descripción")
                                .foregroundStyle(.secondary)
                                .padding(16)
                                .allowsHitTesting(false)
                        }
                    }
                )

            DatePicker("Fecha del evento", selection: $viewModel.eventDate, displayedComponents: .date)
                .datePickerStyle(.compact)

            TextField("Ciudad / Provincia", text: $viewModel.cityProvince)
                .textInputAutocapitalization(.words)
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading) {
                Text("Visibilidad")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Visibilidad", selection: $viewModel.visibility) {
                    ForEach(ReportVisibility.allCases) { visibility in
                        Text(visibility.title)
                            .tag(visibility)
                    }
                }
                .pickerStyle(.segmented)
            }

            VStack(alignment: .leading) {
                Text("Tipo")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Picker("Tipo", selection: $viewModel.type) {
                    ForEach(ReportType.allCases) { type in
                        Text(type.title)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }

            Button(action: onSubmit) {
                Text("Guardar denuncia")
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 10, y: 4)
    }
}

@MainActor
final class ReportFormViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var details: String = ""
    @Published var eventDate: Date = .now
    @Published var cityProvince: String = ""
    @Published var visibility: ReportVisibility = .publico
    @Published var type: ReportType = .aseoYOrnato
    @Published var errorMessage: String?

    func saveReport(modelContext: ModelContext, ownerEmail: String) throws {
        errorMessage = nil
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            errorMessage = "El título es obligatorio."
            throw ReportFormError.invalidFields
        }

        guard !cityProvince.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Indica una ciudad o provincia."
            throw ReportFormError.invalidFields
        }

        let report = Report(
            title: trimmedTitle,
            details: details.trimmingCharacters(in: .whitespacesAndNewlines),
            eventDate: eventDate,
            cityProvince: cityProvince.trimmingCharacters(in: .whitespacesAndNewlines),
            visibility: visibility,
            type: type,
            ownerEmail: ownerEmail
        )

        modelContext.insert(report)
        try modelContext.save()
        resetForm()
    }

    private func resetForm() {
        title = ""
        details = ""
        eventDate = .now
        cityProvince = ""
        visibility = .publico
        type = .aseoYOrnato
    }
}

enum ReportFormError: Error {
    case invalidFields
}

#Preview {
    let vm = ReportFormViewModel()
    vm.title = "Bache gigante"
    vm.details = "Ocupa dos carriles frente a la facultad."
    vm.cityProvince = "Quito"
    vm.visibility = .publico
    vm.type = .transitoVial

    return ReportFormView(viewModel: vm, onSubmit: {})
        .padding()
        .previewLayout(.sizeThatFits)
}
