import Foundation

struct Icon: Hashable, Codable {
    let url: URL

    enum CodingKeys: String, CodingKey {
        case url = "src"
    }
}
