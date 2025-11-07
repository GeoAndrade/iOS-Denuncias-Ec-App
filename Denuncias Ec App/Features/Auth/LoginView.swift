import SwiftUI
import SwiftData

struct LoginView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var viewModel: AuthViewModel
    @ObservedObject var sessionService: SessionService

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("DenunciasEcuador")
                        .font(.largeTitle.weight(.semibold))
                    Text("Correo + Contraseña")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 40)

                VStack(alignment: .leading, spacing: 16) {
                    TextField("Correo institucional", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))

                    SecureField("Contraseña", text: $viewModel.password)
                        .textContentType(.password)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
                }

                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.footnote)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                Button(action: handleSubmit) {
                    HStack {
                        if viewModel.isLoading {
                            ProgressView()
                        }
                        Text("Ingresar")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)

                Spacer()
            }
            .padding()
        }
    }

    private func handleSubmit() {
        viewModel.submit(modelContext: modelContext, sessionService: sessionService)
    }
}

#Preview {
    LoginView(viewModel: AuthViewModel(), sessionService: SessionService())
        .modelContainer(PreviewSamples.container)
}
