import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store<AppState>

    // hold properties of the view
    struct Props {
        let onLoadRemoteEpgXml: () -> Void
        let onLoadLocalEpgXml: () -> Void
    }

    private func map(state: EpgState) -> Props {
        Props(
            onLoadRemoteEpgXml: { store.dispatch(action: LoadEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onLoadLocalEpgXml: { store.dispatch(action: LoadEpgDataFromLocalXmlAsync() ) }
        )
    }

    var body: some View {

        let props = map(state: store.state.epgState)

        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)

            Button("Load remote XML") {
                props.onLoadRemoteEpgXml()
            }

            Button("Load local XML") {
                props.onLoadLocalEpgXml()
            }

            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {

        let store = Store(reducer: epgReducer, state: EpgState())
        return ContentView().environmentObject(store)
    }
}
