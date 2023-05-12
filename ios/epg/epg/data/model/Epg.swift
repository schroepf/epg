import Foundation
import XMLCoder

struct Epg: Decodable {
    let channels: [Channel]
    let epgEntries: [EpgEntry]

    enum CodingKeys: String, CodingKey {
        case channels = "channel"
        case epgEntries = "programme"
    }
}

extension Epg {
    static func parse(xmlData: Data) async -> Self? {
        let decoder = XMLDecoder()
        decoder.dateDecodingStrategy = .formatted(Formatter.epgDate)
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

struct Formatter {
    static let epgDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss Z"
        return formatter
    }()
}
