import SwiftUI

struct FocusedChannel: FocusedValueKey {
    typealias Value = Channel
}

extension FocusedValues {
    var focusedChannel: FocusedChannel.Value? {
        get { self[FocusedChannel.self] }
        set { self[FocusedChannel.self] = newValue }
    }
}

struct TVChannelsListView: View {
    @EnvironmentObject var store: Store<AppDomain.State>

    // hold properties of the view
    struct ViewState {
        let channels: [Channel]
        let onFetchRemoteEpgXml: () -> Void
        let onFetchLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsDomain.State) -> ViewState {
        return ViewState(
            channels: state.channels ?? [],
            onFetchRemoteEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onFetchLocalEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromLocalXml ) },
            onLoadChannels: { store.dispatch(action: ChannelsDomain.Action.fetchAllChannels) }
        )
    }

    var body: some View {
        let viewState = map(state: store.state.channelsState)

        GeometryReader { geometry in
            ZStack {
                TVWallpaperView()

                ScrollView(.horizontal) {
                    LazyHStack() {
                        ForEach(viewState.channels) { channel in
                            TVChannelDetailsView(channelId: channel.id)
                                .frame(width: geometry.size.width)
                                .focusedValue(\.focusedChannel, channel)
                        }
                    }
                }
                .tabViewStyle(.page)

                TVSettingsView {
                    viewState.onLoadChannels()
                } onImportLocalXml: {
                    viewState.onFetchLocalEpgXml()
                } onImportRemoteXml: {
                    viewState.onFetchRemoteEpgXml()
                }
            }
        }
    }
}

struct TVChannelsListView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(
            reducer: reducer,
            state: AppDomain.State(),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return TVChannelsListView().environmentObject(store)
    }

    static var platform: PreviewPlatform? { .tvOS }
}
