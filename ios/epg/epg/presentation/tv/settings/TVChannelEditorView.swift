import SwiftUI

enum TVChannelEditorListItem: Hashable {
    case favoriteHeading
    case otherChannelsHeading
    case channel(channelItem: ChannelItem)
}

extension TVChannelEditorListItem: Identifiable {
    var id: String {
        switch self {
        case .favoriteHeading:
            return "FAVORITE_CHANNELS_HEADING"
        case .otherChannelsHeading:
            return "OTHER_CHANNELS_HEADING"
        case .channel(channelItem: let channelItem):
            return channelItem.id
        }
    }


}

struct TVChannelEditorItemView: View {
    let item: TVChannelEditorListItem

    var body: some View {
        switch item {
        case .favoriteHeading:
            Text("Favorites:")
                .font(.system(size: 48, weight: .bold))
                .moveDisabled(true)
                .deleteDisabled(true)
        case .otherChannelsHeading:
            Text("Other channels:")
                .font(.system(size: 48, weight: .bold))
                .moveDisabled(false)
                .deleteDisabled(true)
        case let .channel(channelItem):
            Text(channelItem.channel.name)
                .deleteDisabled(true)
        }
    }
}

struct TVChannelEditorView: View {
    @EnvironmentObject var store: Store<AppDomain.State>
    @Environment(\.editMode) var editMode

    // hold properties of the view
    struct ViewState {
        let listItems: [TVChannelEditorListItem]
    }

    private func map(state: ChannelEditorDomain.State) -> ViewState {
        let favoriteChannels = state.channels?.filter { $0.isFavorite } ?? []
        let nonFavoriteChannels = state.channels?.filter { !$0.isFavorite } ?? []

        return ViewState(
            listItems: [.favoriteHeading] + favoriteChannels.map { .channel(channelItem: $0) } + [.otherChannelsHeading] + nonFavoriteChannels.map { .channel(channelItem: $0) }
        )
    }

    var body: some View {
        let viewState = map(state: store.state.channelEditorState)

        VStack {
            List {
                ForEach(viewState.listItems) { listItem in
                    TVChannelEditorItemView(item: listItem)
                }
                .onMove { source, destination in
                    onMoveFavorites(viewState: viewState, source: source, destination: destination)
                }
            }


            Spacer()
        }
        .onAppear {
            self.editMode?.wrappedValue = .active
        }
        .onDisappear {
            self.editMode?.wrappedValue = .inactive
        }
    }

    private func onMoveFavorites(viewState: ViewState, source: IndexSet, destination: Int) {
        var listItems = viewState.listItems
        listItems.move(fromOffsets: source, toOffset: destination)
        let otherChannelsSeparater = listItems.firstIndex(of: .otherChannelsHeading) ?? 10
        let channels = listItems
            .enumerated()
            .compactMap { index, item in
            if case let .channel(channelItem) = item {
                let isFavorite = index < otherChannelsSeparater
                return ChannelItem(id: channelItem.id, isFavorite: isFavorite, channel: channelItem.channel, currentEpg: channelItem.currentEpg)
            }

            return nil
        }

        store.dispatch(action: ChannelEditorDomain.Action.onChannelsEdited(channels: channels))
    }

    private func onAddToFavorites(viewState: ViewState, channel: ChannelItem) {

    }
}

struct TVChannelEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TVChannelEditorView()
    }
}
