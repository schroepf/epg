import Foundation

protocol EpgRepository {
    func updateEpgData(epgEntries: [EpgEntry]?) async throws
    func getEpgDataByChannel(channelId: String) async throws -> [EpgEntry]
    func getEpgEntry(channelId: String, at date: Date) async throws -> EpgEntry?
}
