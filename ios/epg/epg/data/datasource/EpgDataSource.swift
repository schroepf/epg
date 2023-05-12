import Foundation

protocol EpgDataSource {
    func saveAll(epgEntries: [EpgEntry]?) async throws
}
