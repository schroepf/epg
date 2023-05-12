import Foundation

protocol ChannelRepository {
    func updateChannels(channels: [Channel]?) async throws
    func getAllChannels() async throws -> [ChannelItem]
}
