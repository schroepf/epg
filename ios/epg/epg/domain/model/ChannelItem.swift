import Foundation

struct ChannelItem: Hashable, Identifiable {
    let id: String
    let isFavorite: Bool
    let channel: Channel
    let currentEpg: EpgEntry?
}
