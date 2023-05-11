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
    @FocusState var isSettingsFocused: Bool
    @State var settingsVisible: Bool = false

    @Namespace private var settings

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
                    .ignoresSafeArea()

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

                HStack {
                    Spacer()

                    VStack {
                        ZStack(alignment: .topTrailing) {
                            Button {
                                settingsVisible.toggle()
                            } label: {
                                Image(systemName: "gearshape")
                            }
                            .clipShape(Circle())
                        }

                        Spacer()
                    }
                }

                if (settingsVisible) {
                    TVSettingsView {
                        viewState.onLoadChannels()
                        settingsVisible = false
                    } onImportLocalXml: {
                        viewState.onFetchLocalEpgXml()
                        settingsVisible = false
                    } onImportRemoteXml: {
                        viewState.onFetchRemoteEpgXml()
                        settingsVisible = false
                    } onExit: {
                        settingsVisible = false
                    }
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
