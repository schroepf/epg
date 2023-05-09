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

    private func map(state: ChannelDetailsState) -> Props {
        Props(
            title: channelId,
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
            Text(props.title)
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
