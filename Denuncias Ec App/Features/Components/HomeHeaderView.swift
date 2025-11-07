import SwiftUI

struct HomeHeaderView: View {
    let email: String
    let onLogoutTap: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Bienvenido,")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(email)
                    .font(.title3.weight(.semibold))
                    .textSelection(.enabled)
            }
            Spacer()
            Button(action: onLogoutTap) {
                Image(systemName: "power")
                    .font(.title3)
                    .foregroundStyle(.red)
            }
            .accessibilityLabel("Cerrar sesión")
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    HomeHeaderView(email: "demo@uni.edu", onLogoutTap: {})
        .padding()
        .previewLayout(.sizeThatFits)
}
