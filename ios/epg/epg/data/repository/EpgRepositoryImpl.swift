import Foundation

struct EpgRepositoryImpl: EpgRepository {
    let dataSource: EpgDataSource

    func updateEpgData(epgEntries: [EpgEntry]?) async throws {
        print("EpgRepositoryImpl: updateEpgData")
        try await dataSource.saveAll(epgEntries: epgEntries)
    }

    func getEpgDataByChannel(channelId: String) async -> Result<[EpgEntry], EpgError> {
        do {
            let epgEntries = try await dataSource.getEntries(channelId: channelId)
            return .success(epgEntries)
        } catch {
            return .failure(.persistenceError)
        }
    }
}
