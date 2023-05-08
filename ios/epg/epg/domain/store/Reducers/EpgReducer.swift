import Foundation

func epgReducer(state: EpgState, action: Action) -> EpgState {
    var state = state

    switch action {
    case let action as SaveEpgData:
        state.epg = action.epg
    default:
        break
    }

    return state
}
