import SwiftUI

struct ChannelsListView: View {
    @EnvironmentObject var store: Store<AppState>

    // hold properties of the view
    struct Props {
        let channels: [Channel]
        let onFetchRemoteEpgXml: () -> Void
        let onFetchLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsState) -> Props {
        Props(
            channels: state.channels ?? [],
            onFetchRemoteEpgXml: { store.dispatch(action: FetchEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onFetchLocalEpgXml: { store.dispatch(action: FetchEpgDataFromLocalXmlAsync() ) },
            onLoadChannels: { store.dispatch(action: LoadChannels()) }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelsState)

        VStack {
            Text("Fetch EPG Data")

            HStack {
                Button("Remote") {
                    props.onFetchRemoteEpgXml()
                }

                Button("Local") {
                    props.onFetchLocalEpgXml()
                }
            }

            Spacer()

            List(props.channels, id: \.id) { channel in
                NavigationLink(destination: ChannelDetailsView(channelId: channel.id)) {
                    ChannelCell(channel: channel)
                }

            }
            .listStyle(.plain)
        }
        .onAppear {
            props.onLoadChannels()
        }
        .navigationTitle("Channels")
        .embedInNavigationView()
    }
}

struct ChannelsListView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return ChannelsListView().environmentObject(store)
    }
}
