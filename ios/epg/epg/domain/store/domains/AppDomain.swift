import Foundation

enum AppDomain {
    struct State: ReduxState {
        var channelsState = ChannelsDomain.State(channels: nil)
    }

    enum Action: epg.Action {
        case fetchEpgDataFromLocalXml
        case fetchEpgDataFromRemoteXmlAsync(url: String)
        case saveEpgData(epg: Epg?)
    }
}

// the "root reducer"
func reducer(state: AppDomain.State, action: Action) -> AppDomain.State {
    return AppDomain.State(
        channelsState: reducer(state: state.channelsState, action: action)
    )
}
