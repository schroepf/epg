import Foundation

enum ChannelError: Error {
    case persistenceError
}

protocol ChannelRepository {
    func updateChannels()
    func getAllChannels() async -> Result<[Channel], ChannelError>
}
