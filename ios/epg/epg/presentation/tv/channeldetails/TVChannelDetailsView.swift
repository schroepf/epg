import SwiftUI

struct TVChannelDetailsView: View {
    @EnvironmentObject var store: Store<AppState>

    let channelId: String

    struct Props {
        let title: String
        let epgData: [EpgEntry]?
        let logoUrl: URL?
        let onLoadChannelDetails: () -> Void
    }

    private func map(state: [String: ChannelDetailsState]) -> Props {
        let channelDetails = state[channelId]
        return Props(
            title: channelId,
            epgData: channelDetails?.epgData,
            logoUrl: channelDetails?.channel?.icon?.url,
            onLoadChannelDetails: {
                store.dispatch(action: LoadChannelDetails(channelId: channelId))
            }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelDetailsState)

        VStack {
            Text(props.title)

            List(props.epgData ?? [], id: \.id) { epg in
                Text(epg.title)
            }
        }
        .focusable()
        .task {
            props.onLoadChannelDetails()
        }
    }
}

struct TVChannelDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TVChannelDetailsView(channelId: "BYde")
    }
}
