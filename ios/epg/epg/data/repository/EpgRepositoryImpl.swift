import Foundation

struct EpgRepositoryImpl: EpgRepository {
    let dataSource: EpgDataSource

    func updateEpgData(epgEntries: [EpgEntry]?) async throws {
        try await dataSource.saveAll(epgEntries: epgEntries)
    }
}
