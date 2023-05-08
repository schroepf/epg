import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState>

    // hold properties of the view
    struct Props {
        let channels: [Channel]
        let onLoadRemoteEpgXml: () -> Void
        let onLoadLocalEpgXml: () -> Void
    }

    private func map(state: EpgState) -> Props {
        Props(
            channels: state.epg?.channels ?? [],
            onLoadRemoteEpgXml: { store.dispatch(action: LoadEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onLoadLocalEpgXml: { store.dispatch(action: LoadEpgDataFromLocalXmlAsync() ) }
        )
    }

    var body: some View {

        let props = map(state: store.state.epgState)

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [epgMiddleware()]
        )

        return ContentView().environmentObject(store)
    }
}
