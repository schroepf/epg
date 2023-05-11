import Foundation

enum ChannelsDomain {
    struct State: ReduxState {
        let channels: [ChannelItem]?
    }

    enum Action: epg.Action {
        case fetchAllChannels
        case setChannels(channels: [ChannelItem])
    }
}

func reducer(state: ChannelsDomain.State, action: Action) -> ChannelsDomain.State {
    switch action {
    case let ChannelsDomain.Action.setChannels(channelItems):
        return ChannelsDomain.State(channels: channelItems)
    default:
        return state
    }
}

struct ChannelItem: Identifiable {
    let id: String
    let channel: Channel
    let currentEpg: EpgEntry?
}
