import Foundation

// the "root reducer"
func appReducer(state: AppState, action: Action) -> AppState {
    var state = state

    state.epgState = epgReducer(state: state.epgState, action: action)

    return state
}
