import Foundation

struct EpgRepositoryImpl: EpgRepository {
    let dataSource: EpgDataSource

    func updateEpgData(epgEntries: [EpgEntry]?) async throws {
        print("EpgRepositoryImpl: updateEpgData")
        try await dataSource.saveAll(epgEntries: epgEntries)
    }

    func getEpgDataByChannel(channelId: String) async throws -> [EpgEntry] {
        return try await dataSource.getEntries(channelId: channelId)
    }

    func getEpgEntry(channelId: String, at date: Date) async throws -> EpgEntry? {
        return try await dataSource.getEntry(channelId: channelId, at: date)
    }
}
