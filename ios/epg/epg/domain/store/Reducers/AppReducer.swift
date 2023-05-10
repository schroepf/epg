import Foundation

// the "root reducer"
func appReducer(state: AppState, action: Action) -> AppState {
    return AppState(
        channelsState: channelsReducer(state: state.channelsState, action: action),
        channelDetailsState: channelDetailsReducer(state: state.channelDetailsState, action: action)
    )
}
