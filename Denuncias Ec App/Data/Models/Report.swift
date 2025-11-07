import Foundation
import SwiftData

enum ReportVisibility: String, Codable, CaseIterable, Identifiable {
    case publico
    case privado

    var id: String { rawValue }
    var title: String {
        switch self {
        case .publico: return "Pública"
        case .privado: return "Privada"
        }
    }
}

enum ReportType: String, Codable, CaseIterable, Identifiable {
    case aseoYOrnato
    case transitoVial
    case delito

    var id: String { rawValue }
    var title: String {
        switch self {
        case .aseoYOrnato: return "Aseo y Ornato"
        case .transitoVial: return "Tránsito Vial"
        case .delito: return "Delito"
        }
    }

    var iconName: String {
        switch self {
        case .aseoYOrnato: return "leaf.fill"
        case .transitoVial: return "car.fill"
        case .delito: return "exclamationmark.triangle.fill"
        }
    }
}

@Model
final class Report {
    var title: String
    var details: String
    var eventDate: Date
    var cityProvince: String
    var visibility: ReportVisibility
    var type: ReportType
    var createdAt: Date
    var ownerEmail: String

    init(
        title: String,
        details: String,
        eventDate: Date,
        cityProvince: String,
        visibility: ReportVisibility,
        type: ReportType,
        createdAt: Date = .now,
        ownerEmail: String
    ) {
        self.title = title
        self.details = details
        self.eventDate = eventDate
        self.cityProvince = cityProvince
        self.visibility = visibility
        self.type = type
        self.createdAt = createdAt
        self.ownerEmail = ownerEmail
    }
}
