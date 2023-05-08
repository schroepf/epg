import Foundation

protocol ChannelDataSource {
    func saveAll(channels: [Channel]?) async
    func getAll() async throws -> [Channel]
}
