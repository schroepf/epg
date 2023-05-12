import Foundation

protocol EpgRepository {
    func updateEpgData(epgEntries: [EpgEntry]?) async throws
}
