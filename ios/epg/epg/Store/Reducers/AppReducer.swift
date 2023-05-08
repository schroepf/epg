import Foundation

// the "root reducer"
func appReducer(state: AppState, action: Action) -> AppState {
    var state = state

    state.counterState = counterReducer(state: state.counterState, action: action)
    state.taskState = taskReducer(state: state.taskState, action: action)

    return state
}
