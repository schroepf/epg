import Foundation

enum ChannelsDomain {
    struct State: ReduxState {
        let channels: [Channel]?
    }

    enum Action: epg.Action {
        case fetchAllChannels
        case setChannels(channels: [Channel])
    }
}

func reducer(state: ChannelsDomain.State, action: Action) -> ChannelsDomain.State {
    switch action {
    case let ChannelsDomain.Action.setChannels(channels):
        return ChannelsDomain.State(channels: channels)
    default:
        return state
    }
}
