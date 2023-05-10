import Foundation

struct ChannelRepositoryImpl: ChannelRepository {
    let dataSource: ChannelDataSource

    func updateChannels(channels: [Channel]?) async throws {
        print("ChannelRepositoryImpl: updateChannels")
        try await dataSource.saveAll(channels: channels)
    }

    func getAllChannels() async throws -> [Channel] {
        let channels = try await dataSource.getAll()
        print("Channels from DB: \(channels.count)")
        return channels
    }

    func getChannel(channelId: String) async throws -> Channel? {
        return try await dataSource.getChannel(channelId: channelId)
    }
}
