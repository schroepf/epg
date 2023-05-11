import SwiftUI

struct ChannelsListView: View {
    @EnvironmentObject var store: Store<AppDomain.State>

    // hold properties of the view
    struct Props {
        let channels: [Channel]
        let onFetchRemoteEpgXml: () -> Void
        let onFetchLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsDomain.State) -> Props {
        Props(
            channels: state.channels ?? [],
            onFetchRemoteEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onFetchLocalEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromLocalXml) },
            onLoadChannels: { store.dispatch(action: ChannelsDomain.Action.fetchAllChannels) }
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
        .navigationTitle("Channels")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
#if os(iOS)
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
#endif
            }
        }
        .embedInNavigationView()
    }
}

struct ChannelsListView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(
            reducer: reducer,
            state: AppDomain.State(),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return ChannelsListView().environmentObject(store)
    }
}
