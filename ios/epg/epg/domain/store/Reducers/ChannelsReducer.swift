import Foundation

func channelsReducer(state: ChannelsState, action: Action) -> ChannelsState {
    var state = state

    switch action {
    case let action as SetChannels:
        return state.apply(result: action.result)
    default:
        break
    }

    return state
}
