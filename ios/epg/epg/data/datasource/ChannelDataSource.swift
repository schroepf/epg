import Foundation

protocol ChannelDataSource {
    func saveAll(channels: [ChannelItem]?) async throws
    func getAll() async throws -> [ChannelItem]
}
