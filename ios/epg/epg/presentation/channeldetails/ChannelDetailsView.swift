import SwiftUI

struct ChannelDetailsView: View {
    @EnvironmentObject var store: Store<AppState>

    let channelId: String

    struct Props {
        let title: String
        let epgData: [EpgEntry]?
        let logoUrl: URL?
        let onLoadChannelDetails: () -> Void
    }

    private func map(state: ChannelDetailsState) -> Props {
        Props(
            title: state.channel?.name ?? "No channel found",
            epgData: state.epgData,
            logoUrl: state.channel?.icon?.url,
            onLoadChannelDetails: {
                store.dispatch(action: LoadChannelDetails(channelId: channelId))
            }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelDetailsState)
        VStack {
            AsyncImage(url: props.logoUrl)

            List(props.epgData ?? [], id: \.id) { epg in
                EpgCell(epgEntry: epg)
            }
            .listStyle(.plain)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(props.title)
        .onAppear {
            props.onLoadChannelDetails()
        }
    }
}

struct ChannelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return ChannelDetailsView(channelId: "BRde")
            .environmentObject(store)
    }
}
