import Foundation

struct EcuadorProvince: Identifiable, Hashable {
    let name: String
    let cities: [String]

    var id: String { name }
}

enum EcuadorLocationCatalog {
    static let provinces: [EcuadorProvince] = [
        EcuadorProvince(name: "Azuay", cities: ["Cuenca", "Gualaceo", "Paute"]),
        EcuadorProvince(name: "Bolívar", cities: ["Guaranda", "San Miguel", "Chimbo"]),
        EcuadorProvince(name: "Cañar", cities: ["Azogues", "Biblián", "La Troncal"]),
        EcuadorProvince(name: "Carchi", cities: ["Tulcán", "Mira", "Bolívar"]),
        EcuadorProvince(name: "Chimborazo", cities: ["Riobamba", "Guano", "Alausí"]),
        EcuadorProvince(name: "Cotopaxi", cities: ["Latacunga", "Pujilí", "Salcedo"]),
        EcuadorProvince(name: "El Oro", cities: ["Machala", "Santa Rosa", "Pasaje"]),
        EcuadorProvince(name: "Esmeraldas", cities: ["Esmeraldas", "Quinindé", "Atacames"]),
        EcuadorProvince(name: "Galápagos", cities: ["Puerto Baquerizo Moreno", "Puerto Ayora", "Puerto Velasco Ibarra"]),
        EcuadorProvince(name: "Guayas", cities: ["Guayaquil", "Samborondón", "Durán"]),
        EcuadorProvince(name: "Imbabura", cities: ["Ibarra", "Otavalo", "Cotacachi"]),
        EcuadorProvince(name: "Loja", cities: ["Loja", "Catamayo", "Macará"]),
        EcuadorProvince(name: "Los Ríos", cities: ["Babahoyo", "Quevedo", "Ventanas"]),
        EcuadorProvince(name: "Manabí", cities: ["Portoviejo", "Manta", "Chone"]),
        EcuadorProvince(name: "Morona Santiago", cities: ["Macas", "Gualaquiza", "Sucúa"]),
        EcuadorProvince(name: "Napo", cities: ["Tena", "Archidona", "El Chaco"]),
        EcuadorProvince(name: "Orellana", cities: ["Francisco de Orellana", "Joya de los Sachas", "Loreto"]),
        EcuadorProvince(name: "Pastaza", cities: ["Puyo", "Mera", "Santa Clara"]),
        EcuadorProvince(name: "Pichincha", cities: ["Quito", "Cayambe", "Rumiñahui"]),
        EcuadorProvince(name: "Santa Elena", cities: ["La Libertad", "Salinas", "Santa Elena"]),
        EcuadorProvince(name: "Santo Domingo de los Tsáchilas", cities: ["Santo Domingo", "La Concordia"]),
        EcuadorProvince(name: "Sucumbíos", cities: ["Nueva Loja", "Shushufindi", "Cascales"]),
        EcuadorProvince(name: "Tungurahua", cities: ["Ambato", "Baños de Agua Santa", "Pelileo"]),
        EcuadorProvince(name: "Zamora Chinchipe", cities: ["Zamora", "Yantzaza", "Zumba"])
    ]

    static var defaultProvince: EcuadorProvince {
        provinces.first ?? EcuadorProvince(name: "Pichincha", cities: ["Quito"])
    }
}
