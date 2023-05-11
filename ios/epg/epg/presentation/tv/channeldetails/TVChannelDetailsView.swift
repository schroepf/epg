import SwiftUI

struct FocusedEpgEntry: FocusedValueKey {
    typealias Value = EpgEntry
}

extension FocusedValues {
    var focusedEpgEntry: FocusedEpgEntry.Value? {
        get { self[FocusedEpgEntry.self] }
        set { self[FocusedEpgEntry.self] = newValue }
    }
}

struct TVChannelDetailsView: View {
    @EnvironmentObject var store: Store<AppDomain.State>

    let channelId: String

    struct ViewState {
        let title: String
        let currentArtwork: Icon?
        let epgData: [EpgEntry]?
        let channelLogo: Icon?
        let onLoadChannelDetails: () -> Void
    }

    private func map(state: [String: ChannelDetailsDomain.State]) -> ViewState {
        let channelDetails = state[channelId]

        return TVChannelDetailsView.ViewState(
            title: channelDetails?.channel?.name ?? channelId,
            currentArtwork: channelDetails?.currentEpgEntry?.artwork,
            epgData: channelDetails?.epgData,
            channelLogo: channelDetails?.channel?.icon,
            onLoadChannelDetails: {
                store.dispatch(action: ChannelDetailsDomain.Action.fetchChannelDetails(channelId: channelId))
            }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelDetailsState)

        GeometryReader { geometry in
            List(props.epgData ?? [], id: \.id) { epg in
                Button {
                    // no-op
                } label: {
                    VStack {
                        HStack {
                            Text(epg.title)
                            Spacer()
                            Text(epg.formatStartEndTimeString())
                        }
                    }
                }
                .focusedValue(\.focusedEpgEntry, epg)
            }
            .offset(.init(width: .zero, height: 300))
        }
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
