import Foundation

struct EpgEntry: Codable {
    let id = UUID()
    let channelId: String
    let title: String
    let summary: String?
    let start: Date
    let stop: Date

    enum CodingKeys: String, CodingKey {
        case channelId = "channel"
        case title
        case summary = "desc"
        case start
        case stop
    }
}
