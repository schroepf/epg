import Foundation

protocol ChannelDataSource {
    func saveAll(channels: [Channel]?) async throws
    func getAll() async throws -> [Channel]
    func getChannel(channelId: String) async throws -> Channel?
}
