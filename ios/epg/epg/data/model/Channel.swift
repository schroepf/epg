import Foundation

struct Channel: Decodable, Identifiable {
    let id: String
    let name: String
    let icon: Icon?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "display-name"
        case icon
    }
}
