import Foundation
import SwiftData

enum SampleDataSeeder {
    static func seedReportsIfNeeded(in context: ModelContext) throws {
        let descriptor = FetchDescriptor<Report>()
        let existing = try context.fetch(descriptor)
        guard existing.isEmpty else { return }

        sampleReports.forEach { context.insert($0) }
        try context.save()
    }

    private static var sampleReports: [Report] {
        [
            Report(
                title: "Bache peligroso en la Av. 10 de Agosto",
                details: "Ocupa el carril derecho y ya causó varios daños a vehículos.",
                eventDate: date("2024-10-05T10:30:00Z"),
                cityProvince: "Pichincha, Quito",
                visibility: .publico,
                type: .transitoVial,
                createdAt: date("2024-10-05T11:00:00Z"),
                ownerEmail: "sofia.perez@gmail.com"
            ),
            Report(
                title: "Acumulación de basura en el parque central",
                details: "Los contenedores no se vacían desde hace tres días.",
                eventDate: date("2024-09-28T08:00:00Z"),
                cityProvince: "Guayas, Guayaquil",
                visibility: .publico,
                type: .aseoYOrnato,
                createdAt: date("2024-09-28T09:15:00Z"),
                ownerEmail: "carlos.mejia@hotmail.com"
            ),
            Report(
                title: "Luminaria dañada en la Av. del Bombero",
                details: "Tramo completamente oscuro, riesgo para peatones.",
                eventDate: date("2024-09-20T19:45:00Z"),
                cityProvince: "Guayas, Samborondón",
                visibility: .publico,
                type: .aseoYOrnato,
                createdAt: date("2024-09-20T20:10:00Z"),
                ownerEmail: "valeria.quito@yahoo.com"
            ),
            Report(
                title: "Venta de sustancias ilícitas",
                details: "Se observan intercambios sospechosos todas las noches.",
                eventDate: date("2024-08-15T22:00:00Z"),
                cityProvince: "Azuay, Cuenca",
                visibility: .publico,
                type: .delito,
                createdAt: date("2024-08-16T00:05:00Z"),
                ownerEmail: "maria.villalba@gmail.com"
            ),
            Report(
                title: "Semáforo fuera de servicio",
                details: "Intersección peligrosa frente al estadio.",
                eventDate: date("2024-09-30T07:30:00Z"),
                cityProvince: "Manabí, Manta",
                visibility: .publico,
                type: .transitoVial,
                createdAt: date("2024-09-30T07:50:00Z"),
                ownerEmail: "diego.castro@outlook.com"
            ),
            Report(
                title: "Ruidos fuertes hasta la madrugada",
                details: "Locales nocturnos no respetan ordenanzas municipales.",
                eventDate: date("2024-10-02T01:30:00Z"),
                cityProvince: "Imbabura, Ibarra",
                visibility: .publico,
                type: .delito,
                createdAt: date("2024-10-02T02:00:00Z"),
                ownerEmail: "ana.santamaria@gmail.com"
            ),
            Report(
                title: "Arbol caído bloqueando la vía",
                details: "Vía antigua a Nayón permanece cerrada.",
                eventDate: date("2024-10-08T05:45:00Z"),
                cityProvince: "Pichincha, Quito",
                visibility: .publico,
                type: .aseoYOrnato,
                createdAt: date("2024-10-08T06:10:00Z"),
                ownerEmail: "ricardo.vera@gmail.com"
            ),
            Report(
                title: "Fuga de agua en la calle 9 de Octubre",
                details: "El agua corre por toda la vereda, provoca charcos.",
                eventDate: date("2024-09-18T14:10:00Z"),
                cityProvince: "Los Ríos, Babahoyo",
                visibility: .publico,
                type: .aseoYOrnato,
                createdAt: date("2024-09-18T15:00:00Z"),
                ownerEmail: "laura.andrade@gmail.com"
            ),
            Report(
                title: "Vehículos estacionados en zona peatonal",
                details: "Ocurre todos los fines de semana frente al malecón.",
                eventDate: date("2024-09-14T18:20:00Z"),
                cityProvince: "Esmeraldas, Esmeraldas",
                visibility: .publico,
                type: .transitoVial,
                createdAt: date("2024-09-14T19:00:00Z"),
                ownerEmail: "kevin.molina@gmail.com"
            ),
            Report(
                title: "Robo a mano armada reportado",
                details: "Dos sujetos encapuchados atracaron a transeúntes.",
                eventDate: date("2024-10-01T21:15:00Z"),
                cityProvince: "Tungurahua, Ambato",
                visibility: .publico,
                type: .delito,
                createdAt: date("2024-10-01T22:00:00Z"),
                ownerEmail: "paula.benitez@gmail.com"
            )
        ]
    }

    private static func date(_ isoString: String) -> Date {
        isoFormatter.date(from: isoString) ?? .now
    }

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()
}
