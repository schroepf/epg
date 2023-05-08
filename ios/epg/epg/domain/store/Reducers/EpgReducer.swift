import Foundation

func epgReducer(state: EpgState, action: Action) -> EpgState {
    var state = state

    switch action {
    case let action as PersistEpgData:
        state.epg = action.epg
    default:
        break
    }

    return state
}
