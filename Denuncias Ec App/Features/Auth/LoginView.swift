import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var sessionService: SessionService

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                VStack(spacing: 12) {
                    Text("DenunciasEcuador")
                        .font(.system(size: 34, weight: .bold))
                    Text("Registra y consulta reportes ciudadanos desde cualquier provincia del país con tu cuenta.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 18) {
                    Text("Correo")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    TextField("user@example.com", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding(14)
                        .background(fieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    Text("Contraseña")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    SecureField("Ingresa tu contraseña", text: $viewModel.password)
                        .textContentType(.password)
                        .padding(14)
                        .background(fieldBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: handleSubmit) {
                    HStack(spacing: 10) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .font(.headline)
                        }
                        Text(viewModel.isLoading ? "Ingresando..." : "Ingresar")
                            .font(.subheadline.weight(.semibold))
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .disabled(viewModel.isLoading)

                Spacer()
            }
            .padding(24)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground).ignoresSafeArea())
        }
    }

    private func handleSubmit() {
        viewModel.submit(modelContext: modelContext, sessionService: sessionService)
    }

    private var fieldBackground: Color {
        Color(.secondarySystemBackground)
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(), sessionService: SessionService())
        .modelContainer(PreviewSamples.container)
}
