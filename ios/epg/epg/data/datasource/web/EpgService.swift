import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case noData
}

class EpgService {
    func getEpg(url: String) async throws -> Epg {
        guard let url = URL(string: url) else {
            throw NetworkError.badURL
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            guard let epgData = await Epg.parse(xmlData: data) else {
                throw NetworkError.decodingError
            }

            return epgData
        } catch {
            throw NetworkError.noData
        }
    }
}
