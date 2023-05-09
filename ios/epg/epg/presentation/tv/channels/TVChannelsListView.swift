import SwiftUI

struct TVChannelsListView: View {
    @EnvironmentObject var store: Store<AppState>

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
        if props.channels.isEmpty {
            VStack {
                Text("No channels found!")

                Button("Load from DB") {
                    props.onLoadChannels()
                }

                Button("Fetch from Local XML") {
                    props.onFetchLocalEpgXml()
                }

                Button("Fetch from Remote XML") {
                    props.onFetchRemoteEpgXml()
                }
            }
            .task {
                props.onLoadChannels()
            }
        } else {
            GeometryReader { geometry in
                ScrollView(.horizontal) {
                    LazyHStack() {
                        ForEach(props.channels) { channel in
                            TVChannelDetailsView(channelId: channel.id)
                                .frame(width: geometry.size.width)
                        }
                    }
                }
                .tabViewStyle(.page)
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

