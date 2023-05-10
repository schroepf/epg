import Foundation

struct Icon: Codable {
    let url: URL

    enum CodingKeys: String, CodingKey {
        case url = "src"
    }
}
