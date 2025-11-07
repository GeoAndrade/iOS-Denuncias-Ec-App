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
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .padding(10)
                    .background(Color(.secondarySystemBackground), in: Circle())
            }
            .accessibilityLabel("Cerrar sesión")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, y: 4)
        )
    }
}

#Preview {
    HomeHeaderView(email: "user@example.com", onLogoutTap: {})
        .padding()
}
