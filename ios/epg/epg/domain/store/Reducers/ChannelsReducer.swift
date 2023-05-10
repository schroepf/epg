import Foundation

func channelsReducer(state: ChannelsState, action: Action) -> ChannelsState {
    switch action {
    case let action as SetChannels:
        return ChannelsState(channels: action.result)
    default:
        return state
    }
}
