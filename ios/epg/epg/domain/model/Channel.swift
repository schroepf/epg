import Foundation

struct Channel: Codable {
    let id: String
    let name: String
    let icon: Icon?

    enum CodingKeys: String, CodingKey {
        case id
        case name = "display-name"
        case icon
    }
}

struct Icon: Codable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "src"
    }
}
