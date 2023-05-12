import Foundation

struct ChannelRepositoryImpl: ChannelRepository {
    let dataSource: ChannelDataSource

    func updateChannels(channels: [Channel]?) async throws {
        try await dataSource.saveAll(channels: channels)
    }

    func getAllChannels() async throws -> [ChannelItem] {
        let channels = try await dataSource.getAll()
        return channels
    }
}
