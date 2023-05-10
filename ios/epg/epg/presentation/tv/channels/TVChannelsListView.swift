import SwiftUI

struct TVChannelsListView: View {
    @EnvironmentObject var store: Store<AppState>
    @FocusState var isSettingsFocused: Bool
    @State var settingsVisible: Bool = false

    @Namespace private var settings

    // hold properties of the view
    struct Props {
        let channels: [Channel]
        let onFetchRemoteEpgXml: () -> Void
        let onFetchLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsState) -> Props {
        return Props(
            channels: state.channels ?? [],
            onFetchRemoteEpgXml: { store.dispatch(action: FetchEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onFetchLocalEpgXml: { store.dispatch(action: FetchEpgDataFromLocalXmlAsync() ) },
            onLoadChannels: { store.dispatch(action: LoadChannels()) }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelsState)

        GeometryReader { geometry in
            ZStack {
                ScrollView(.horizontal) {
                    LazyHStack() {
                        ForEach(props.channels) { channel in
                            TVChannelDetailsView(channelId: channel.id)
                                .frame(width: geometry.size.width)
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
                        props.onLoadChannels()
                        settingsVisible = false
                    } onImportLocalXml: {
                        props.onFetchLocalEpgXml()
                        settingsVisible = false
                    } onImportRemoteXml: {
                        props.onFetchRemoteEpgXml()
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
            reducer: appReducer,
            state: AppState(),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return TVChannelsListView().environmentObject(store)
    }

    static var platform: PreviewPlatform? { .tvOS }
}
