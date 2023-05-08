import Foundation
import XMLCoder

struct Epg: Codable {
    let channels: [Channel]
    let epgEntries: [EpgEntry]

    enum CodingKeys: String, CodingKey {
        case channels = "channel"
        case epgEntries = "programme"
    }
}

extension Epg {
    static func parse(xmlData: Data) -> Self? {
        let decoder = XMLDecoder()
        do {
            let tv = try decoder.decode(Self.self, from: xmlData)
            return tv
        } catch {
            print("Error: Parsing XML Data failed - \(error.localizedDescription) - \(error)")
        }

        return nil
    }
}

extension Epg: CustomDebugStringConvertible {
    var debugDescription: String {
        """
        EPG[
            channels: \(channels.count),
            epgEntries: \(epgEntries.count)
        ]
        """
    }
}
