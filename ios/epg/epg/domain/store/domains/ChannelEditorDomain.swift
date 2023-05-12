import Foundation

enum ChannelEditorDomain {
    struct State: ReduxState {
        let channels: [ChannelItem]?
    }

    enum Action: epg.Action {
        case setChannels(channels: [ChannelItem])
        case onChannelsEdited(channels: [ChannelItem])
    }
}

func reducer(state: ChannelEditorDomain.State, action: Action) -> ChannelEditorDomain.State {
    switch action {
    case let ChannelEditorDomain.Action.setChannels(channelItems):
        return ChannelEditorDomain.State(
            channels: channelItems
        )
    default:
        return state
    }
}

