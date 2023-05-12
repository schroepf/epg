import NukeUI
import SwiftUI

struct FocusedChannel: FocusedValueKey {
    typealias Value = ChannelItem
}

extension FocusedValues {
    var focusedChannel: FocusedChannel.Value? {
        get { self[FocusedChannel.self] }
        set { self[FocusedChannel.self] = newValue }
    }
}

struct TVChannelsListView: View {
    @EnvironmentObject var store: Store<AppDomain.State>

    // hold properties of the view
    struct ViewState {
        let channelItems: [ChannelItem]
        let onFetchRemoteEpgXml: () -> Void
        let onFetchLocalEpgXml: () -> Void
        let onLoadChannels: () -> Void
    }

    private func map(state: ChannelsDomain.State) -> ViewState {
        return ViewState(
            channelItems: state.channels ?? [],
            onFetchRemoteEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromRemoteXmlAsync(url: "https://elres.de/epg")) },
            onFetchLocalEpgXml: { store.dispatch(action: AppDomain.Action.fetchEpgDataFromLocalXml ) },
            onLoadChannels: { store.dispatch(action: ChannelsDomain.Action.fetchAllChannels) }
        )
    }

    var body: some View {
        let viewState = map(state: store.state.channelsState)

        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    TVWallpaperView()

                    VStack {
                        Spacer()

                        ScrollView(.horizontal) {
                            LazyHStack(alignment: .bottom) {
                                ForEach(viewState.channelItems) { channelItem in
                                    Button {
                                        // no-op
                                    } label: {
                                        VStack(alignment: .leading) {
                                            GeometryReader { geometry in
                                                LazyImage(url: channelItem.channel.icon?.forSize(size: geometry.size))
                                            }

                                            Text(channelItem.channel.name)
                                                .font(.system(size: 16, weight: .bold))

                                            if let currentEpg = channelItem.currentEpg {
                                                Text(currentEpg.title)
                                                    .font(.system(size: 24, weight: .bold))
                                                    .multilineTextAlignment(.leading)
                                                Text(currentEpg.formatStartEndTimeString())
                                                    .font(.system(size: 16, weight: .thin))
                                                    .multilineTextAlignment(.leading)
                                                Text(currentEpg.summary ?? "-")
                                                    .font(.system(size: 24, weight: .thin))
                                                    .multilineTextAlignment(.leading)
                                            }

                                            Spacer()
                                        }
                                        .frame(width: 250, height: 400)
                                    }
                                    .focusedValue(\.focusedChannel, channelItem)
                                    .padding(16)
                                }
                            }
                        }
                        .padding([.bottom], 60)
                    }

                    TVSettingsView {
                        viewState.onLoadChannels()
                    } onShowChannelEditor: {
                        print("ZEFIX - nase")
                    } onImportLocalXml: {
                        viewState.onFetchLocalEpgXml()
                    } onImportRemoteXml: {
                        viewState.onFetchRemoteEpgXml()
                    }
                }
            }
        }
    }
}

struct TVChannelsListView_Previews: PreviewProvider {
    static var previews: some View {

        let epg: EpgEntry = EpgEntry(
            channelId: "",
            title: "Die Rosenheimcops",
            summary: "Eine kurze Zusammenfassung",
            start: Date.now,
            stop: Date.now,
            artwork: nil
        )

        let channels: [Channel] = [
            .init(id: "DasErsteDE", name: "Das Erste", icon: .init(url: URL(string: "https://images.tvdirekt.de/images/stories/stations/light/large/ard.png")!)),
            .init(id: "ZDFde", name: "ZDF", icon: .init(url: URL(string: "https://images.tvdirekt.de/images/stories/stations/light/large/zdf.png")!)),
            .init(id: "Sat1DE", name: "Sat.1", icon: .init(url: URL(string: "https://images.tvdirekt.de/images/stories/stations/light/large/sat1_neu.png")!))
        ]
        let channelItems = channels.map { ChannelItem(id: $0.id, channel: $0, currentEpg: epg) }

        let store = Store(
            reducer: reducer,
            state: AppDomain.State(channelsState: ChannelsDomain.State(channels: channelItems)),
            middlewares: [epgMiddleware(epgService: EpgService())]
        )

        return TVChannelsListView().environmentObject(store)
    }

    static var platform: PreviewPlatform? { .tvOS }
}
