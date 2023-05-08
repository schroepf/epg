import Foundation

enum NetworkError: Error {
    case badURL
    case decodingError
    case noData
}

class EpgService {
    func getEpg(url: String, completion: @escaping(Result<Epg, NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }

            guard let epgData = Epg.parse(xmlData: data) else {
                completion(.failure(.decodingError))
                return
            }

            completion(.success(epgData))
        }
        .resume()
    }
}
