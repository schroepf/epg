import Foundation

struct ChannelItem: Identifiable {
    let id: String
    let channel: Channel
    let currentEpg: EpgEntry?
}
