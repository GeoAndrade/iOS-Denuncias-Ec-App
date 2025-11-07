import SwiftUI
import SwiftData

@MainActor
enum PreviewSamples {
    static let container: ModelContainer = {
        let schema = Schema([User.self, Report.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let user = User(email: "user@example.com", password: "123456")
        let publicReport = Report(
            title: "Bache en la vía",
            details: "Afecta el carril derecho de la Av. 6 de Diciembre",
            eventDate: .now.addingTimeInterval(-3600),
            cityProvince: "Pichincha, Quito",
            visibility: .publico,
            type: .transitoVial,
            ownerEmail: user.email
        )
        let privateReport = Report(
            title: "Acumulación de basura",
            details: "Contenedor lleno hace más de dos días",
            eventDate: .now.addingTimeInterval(-86400 * 2),
            cityProvince: "Azuay, Cuenca",
            visibility: .privado,
            type: .aseoYOrnato,
            ownerEmail: user.email
        )

        context.insert(user)
        context.insert(publicReport)
        context.insert(privateReport)
        try? context.save()

        return container
    }()

    static var sessionService: SessionService {
        let service = SessionService()
        service.login(with: "user@example.com")
        return service
    }

    static var report: Report {
        Report(
            title: "Fuga de agua",
            details: "Se desperdician litros por minuto",
            eventDate: .now.addingTimeInterval(-5400),
            cityProvince: "Guayas, Guayaquil",
            visibility: .publico,
            type: .aseoYOrnato,
            ownerEmail: "user@example.com"
        )
    }
}

struct PreviewStateWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: initialValue)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}
