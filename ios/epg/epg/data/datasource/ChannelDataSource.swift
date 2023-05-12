import Foundation

protocol ChannelDataSource {
    func saveAll(channels: [Channel]?) async throws
    func getAll() async throws -> [ChannelItem]
}
