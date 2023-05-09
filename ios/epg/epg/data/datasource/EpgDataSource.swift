protocol EpgDataSource {
    func saveAll(epgEntries: [EpgEntry]?) async throws
    func getEntries(channelId: String) async throws -> [EpgEntry]
}

