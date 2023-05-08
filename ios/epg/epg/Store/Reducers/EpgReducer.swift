import Foundation

func taskReducer(state: EpgState, action: Action) -> EpgState {
    var state = state

    switch action {
    case let action as SetEpgData:
        state.epg = action.epg
    default:
        break
    }

    return state
}
