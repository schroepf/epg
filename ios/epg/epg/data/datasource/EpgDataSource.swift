import Foundation

protocol EpgDataSource {
    func saveAll(epgEntries: [EpgEntry]?) async throws
    func getEntries(channelId: String) async throws -> [EpgEntry]
    func getEntry(channelId: String, at: Date) async throws -> EpgEntry?
}
