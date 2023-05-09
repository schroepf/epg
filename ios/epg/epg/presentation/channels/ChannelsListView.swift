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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        props.onFetchLocalEpgXml()
                    } label: {
                        HStack {
                            Image(systemName: "iphone.circle")
                            Text("Import local EPG data")
                        }
                    }

                    Button {
                        props.onFetchRemoteEpgXml()
                    } label: {
                        HStack {
                            Image(systemName: "arrow.clockwise.icloud")
                            Text("Import remote EPG data")
                        }
                    }
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
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
