import Foundation

enum ChannelError: Error {
    case persistenceError
}

protocol ChannelRepository {
    func updateChannels(channels: [Channel]?) async throws
    func getAllChannels() async -> Result<[Channel], ChannelError>
}
