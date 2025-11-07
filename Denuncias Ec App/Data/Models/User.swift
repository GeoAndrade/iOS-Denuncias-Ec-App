import Foundation
import SwiftData

@Model
final class User {
    @Attribute(.unique) var email: String
    var password: String
    var createdAt: Date

    init(email: String, password: String, createdAt: Date = .now) {
        self.email = email
        self.password = password
        self.createdAt = createdAt
    }
}
