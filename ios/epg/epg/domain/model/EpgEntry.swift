import Foundation

struct EpgEntry: Decodable, Identifiable {
    let id = UUID()
    let channelId: String
    let title: String
    let summary: String?
    let start: Date
    let stop: Date
    let artwork: Icon?

    enum CodingKeys: String, CodingKey {
        case channelId = "channel"
        case title
        case summary = "desc"
        case start
        case stop
        case artwork = "icon"
    }
}
