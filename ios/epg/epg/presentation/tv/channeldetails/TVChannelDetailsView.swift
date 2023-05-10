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
    @EnvironmentObject var store: Store<AppState>

    let channelId: String

    struct ViewState {
        let title: String
        let currentArtwork: Icon?
        let epgData: [EpgEntry]?
        let channelLogo: Icon?
        let onLoadChannelDetails: () -> Void
    }

    private func map(state: [String: ChannelDetailsState]) -> ViewState {
        let channelDetails = state[channelId]

        return TVChannelDetailsView.ViewState(
            title: channelDetails?.channel?.name ?? channelId,
            currentArtwork: channelDetails?.currentEpgEntry?.artwork,
            epgData: channelDetails?.epgData,
            channelLogo: channelDetails?.channel?.icon,
            onLoadChannelDetails: {
                store.dispatch(action: LoadChannelDetails(channelId: channelId))
            }
        )
    }

    var body: some View {
        let props = map(state: store.state.channelDetailsState)

        GeometryReader { geometry in
            ZStack {
                TVWallpaperView()
                .ignoresSafeArea()

                List(props.epgData ?? [], id: \.id) { epg in
                    Button(epg.title) {
                        // no-op
                    }
                    .focusedValue(\.focusedEpgEntry, epg)

                }
                .padding([.leading, .trailing], 90)
                .offset(.init(width: .zero, height: 300))
            }
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

extension Icon {
    func forSize(size: CGSize) -> URL? {
        if (url.host() == "image.fzdigital.de") {
            return URL(string: "https://image.fzdigital.de/\(Int(size.width))x\(Int(size.height))/\(url.lastPathComponent)")
        }

        return url
    }
}
