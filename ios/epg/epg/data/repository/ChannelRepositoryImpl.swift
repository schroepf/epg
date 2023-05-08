import Foundation

struct ChannelRepositoryImpl: ChannelRepository {
    let epgService: EpgService
    let dataSource: ChannelDataSource

    func updateChannels() {

    }

    func getAllChannels() async -> Result<[Channel], ChannelError> {
        do {
            let channels = try await dataSource.getAll()
            return .success(channels)
        } catch {
            return .failure(.persistenceError)
        }
    }
}
