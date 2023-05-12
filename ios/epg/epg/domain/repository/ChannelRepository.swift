import Foundation

protocol ChannelRepository {
    func updateChannels(channels: [ChannelItem]?) async throws
    func getAllChannels() async throws -> [ChannelItem]
}
