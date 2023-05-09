import Foundation

enum EpgError: Error {
    case persistenceError
}

protocol EpgRepository {
    func updateEpgData(epgEntries: [EpgEntry]?) async throws
    func getEpgDataByChannel(channelId: String) async -> Result<[EpgEntry], EpgError>
}
