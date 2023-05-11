import Foundation

enum ChannelDetailsDomain {
    struct State: ReduxState {
        let channel: Channel?
        let currentEpgEntry: EpgEntry?
        let epgData: [EpgEntry]?
    }

    enum Action: epg.Action {
        case fetchChannelDetails(channelId: String)
        case setChannelDetails(channel: Channel?, currentEpgEntry: EpgEntry?, epgData: [EpgEntry]?)
    }
}

func reducer(state: [String: ChannelDetailsDomain.State], action: Action) -> [String: ChannelDetailsDomain.State] {
    switch action {
    case let ChannelDetailsDomain.Action.setChannelDetails(channel, currentEpgEntry, epgData):
        guard let channelId = channel?.id else {
            return state
        }

        var result = state
        result[channelId] = ChannelDetailsDomain.State(
            channel: channel,
            currentEpgEntry: currentEpgEntry,
            epgData: epgData
        )
        return result
    default:
        return state
    }
}
