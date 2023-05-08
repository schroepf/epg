import SwiftUI

struct ChannelsListView: View {
    @EnvironmentObject var store: Store<AppState>

    // hold properties of the view
    struct Props {
        let channels: [Channel]
        let onLoadRemoteEpgXml: () -> Void
        let onLoadLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsState) -> Props {
        Props(
            channels: state.channels ?? [],
            onLoadRemoteEpgXml: { store.dispatch(action: LoadEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onLoadLocalEpgXml: { store.dispatch(action: LoadEpgDataFromLocalXmlAsync() ) },
            onLoadChannels: { store.dispatch(action: LoadChannels()) }
        )
    }

    var body: some View {

        let props = map(state: store.state.channelsState)

        VStack {
            Text("Load EPG Data")

            HStack {
                Button("Remote") {
                    props.onLoadRemoteEpgXml()
                }

                Button("Local") {
                    props.onLoadLocalEpgXml()
                }
            }

            Button("Load Channels") {
                props.onLoadChannels()
            }


            Spacer()

            List(props.channels, id: \.id) { channel in
                ChannelCell(channel: channel)
            }
            .listStyle(.plain)
        }
        .navigationTitle("EPG Data")
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
