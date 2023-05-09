import Foundation

func channelsReducer(state: ChannelsState, action: Action) -> ChannelsState {
    switch action {
    case let action as SetChannels:
        return state.apply(result: action.result)
    default:
        return state
    }
}
