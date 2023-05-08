import Foundation

protocol ChannelDataSource {
    func getAll() async throws -> [Channel]
}
