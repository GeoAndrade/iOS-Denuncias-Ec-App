import SwiftUI
import Combine
import SwiftData

struct ReportFormView: View {
    @ObservedObject var viewModel: ReportFormViewModel
    var onSubmit: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Registro de denuncia")
                .font(.title3.weight(.semibold))

            VStack(alignment: .leading, spacing: 6) {
                Text("Título")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                TextField("Describe el incidente en pocas palabras", text: $viewModel.title)
                    .textInputAutocapitalization(.sentences)
                    .padding(12)
                    .background(fieldBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                if let titleError = viewModel.titleError {
                    Text(titleError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Descripción")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.details)
                        .frame(minHeight: 140)
                        .padding(8)
                        .scrollContentBackground(.hidden)
                        .background(fieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 18))

                    if viewModel.details.isEmpty {
                        Text("Amplía lo sucedido, agrega ubicaciones o referencias.")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .allowsHitTesting(false)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Fecha y hora del evento")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                HStack {
                    Spacer()
                    DatePicker(
                        "",
                        selection: $viewModel.eventDate,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(.primary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(fieldBackground)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Provincia")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Menu {
                    ForEach(EcuadorLocationCatalog.provinces) { province in
                        Button(province.name) {
                            viewModel.selectedProvince = province
                        }
                    }
                } label: {
                    selectorField(
                        text: viewModel.selectedProvince?.name ?? "Selecciona provincia",
                        isPlaceholder: viewModel.selectedProvince == nil,
                        icon: "map"
                    )
                }
                if let provinceError = viewModel.provinceError {
                    Text(provinceError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Text("Ciudad")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Menu {
                    ForEach(viewModel.selectedProvince?.cities ?? [], id: \.self) { city in
                        Button(city) {
                            viewModel.selectedCity = city
                        }
                    }
                } label: {
                    selectorField(
                        text: viewModel.selectedCity ?? "Selecciona ciudad",
                        isPlaceholder: viewModel.selectedCity == nil,
                        icon: "building.2"
                    )
                    .opacity(viewModel.selectedProvince == nil ? 0.6 : 1)
                }
                .disabled(viewModel.selectedProvince == nil)
                if let cityError = viewModel.cityError {
                    Text(cityError)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }

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
                Label("Guardar denuncia", systemImage: "tray.and.arrow.down.fill")
                    .font(.subheadline.weight(.semibold))
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.capsule)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 12, y: 6)
        )
    }

    private var fieldBackground: Color {
        Color(.secondarySystemBackground)
    }

    @ViewBuilder
    private func selectorField(text: String, isPlaceholder: Bool, icon: String) -> some View {
        HStack {
            Spacer(minLength: 0)
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(isPlaceholder ? .secondary : .primary)
                Text(text)
                    .foregroundStyle(isPlaceholder ? .secondary : .primary)
                    .multilineTextAlignment(.center)
            }
            .font(.subheadline)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(fieldBackground)
        )
        .overlay(
            Image(systemName: "chevron.down")
                .foregroundStyle(.secondary)
                .padding(.trailing, 18),
            alignment: .trailing
        )
    }
}

@MainActor
final class ReportFormViewModel: ObservableObject {
    @Published var title: String = "" {
        didSet {
            if !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                titleError = nil
            }
        }
    }
    @Published var details: String = ""
    @Published var eventDate: Date = .now
    @Published var selectedProvince: EcuadorProvince? {
        didSet {
            guard let selectedProvince else {
                selectedCity = nil
                return
            }
            provinceError = nil
            if let selectedCity, !selectedProvince.cities.contains(selectedCity) {
                self.selectedCity = nil
            }
        }
    }
    @Published var selectedCity: String? {
        didSet {
            if selectedCity != nil {
                cityError = nil
                return
            }
        }
    }
    @Published var visibility: ReportVisibility = .publico
    @Published var type: ReportType = .aseoYOrnato
    @Published var errorMessage: String?
    @Published var titleError: String?
    @Published var provinceError: String?
    @Published var cityError: String?

    func makeDraft(ownerEmail: String) throws -> ReportDraft {
        errorMessage = nil
        titleError = nil
        provinceError = nil
        cityError = nil
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedTitle.isEmpty else {
            let message = "El título es obligatorio."
            errorMessage = message
            titleError = message
            throw ReportFormError.invalidFields
        }

        guard let province = selectedProvince else {
            let message = "Selecciona una provincia."
            errorMessage = message
            provinceError = message
            throw ReportFormError.invalidFields
        }

        guard let city = selectedCity else {
            let message = "Selecciona una ciudad."
            errorMessage = message
            cityError = message
            throw ReportFormError.invalidFields
        }

        return ReportDraft(
            title: trimmedTitle,
            details: details.trimmingCharacters(in: .whitespacesAndNewlines),
            eventDate: eventDate,
            cityProvince: "\(province.name), \(city)",
            visibility: visibility,
            type: type,
            ownerEmail: ownerEmail
        )
    }

    func persist(draft: ReportDraft, modelContext: ModelContext) throws {
        let report = Report(
            title: draft.title,
            details: draft.details,
            eventDate: draft.eventDate,
            cityProvince: draft.cityProvince,
            visibility: draft.visibility,
            type: draft.type,
            ownerEmail: draft.ownerEmail
        )
        modelContext.insert(report)
        try modelContext.save()
        resetForm()
    }

    private func resetForm() {
        title = ""
        details = ""
        eventDate = .now
        selectedProvince = nil
        selectedCity = nil
        visibility = .publico
        type = .aseoYOrnato
        titleError = nil
        provinceError = nil
        cityError = nil
        errorMessage = nil
    }
}

enum ReportFormError: Error {
    case invalidFields
}

struct ReportDraft {
    let title: String
    let details: String
    let eventDate: Date
    let cityProvince: String
    let visibility: ReportVisibility
    let type: ReportType
    let ownerEmail: String
}

#Preview {
    let vm = ReportFormViewModel()
    vm.title = "Bache gigante"
    vm.details = "Ocupa dos carriles frente a la facultad."
    vm.selectedProvince = EcuadorLocationCatalog.provinces.first(where: { $0.name == "Pichincha" })
    vm.selectedCity = vm.selectedProvince?.cities.first
    vm.visibility = .publico
    vm.type = .transitoVial

    return ReportFormView(viewModel: vm, onSubmit: {})
        .padding()
}
