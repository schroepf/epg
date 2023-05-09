import Foundation

struct ChannelRepositoryImpl: ChannelRepository {
    let dataSource: ChannelDataSource

    func updateChannels(channels: [Channel]?) async throws {
        print("ChannelRepositoryImpl: updateChannels")
        try await dataSource.saveAll(channels: channels)
    }

    func getAllChannels() async -> Result<[Channel], ChannelError> {
        do {
            let channels = try await dataSource.getAll()
            print("Channels from DB: \(channels.count)")
            return .success(channels)
        } catch {
            return .failure(.persistenceError)
        }
    }
}
