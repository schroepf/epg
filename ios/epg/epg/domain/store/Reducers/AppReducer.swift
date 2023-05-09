import Foundation

// the "root reducer"
func appReducer(state: AppState, action: Action) -> AppState {
    var state = state

    state.channelsState = channelsReducer(state: state.channelsState, action: action)
    state.channelDetailsState = channelDetailsReducer(state: state.channelDetailsState, action: action)

    return state
}
