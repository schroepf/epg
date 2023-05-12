import SwiftUI

struct TVChannelEditorView: View {
    @EnvironmentObject var store: Store<AppDomain.State>
    @Environment(\.editMode) var editMode

    // hold properties of the view
    struct ViewState {
        let channels: [Channel]?
    }

    private func map(state: ChannelsDomain.State) -> ViewState {
        return ViewState(
            channels: state.channels?.map(\.channel)
        )
    }

    var body: some View {
        let viewState = map(state: store.state.channelsState)

        VStack {
            if let channels = viewState.channels {
                List {
                ForEach(channels, id: \.id) { channel in
                    Text(channel.name)
//                        .moveDisabled(channels.first == channel)
//                        .deleteDisabled(channels.last == channel)
                }
                .onMove { source, destination in
                    onMove(channels: channels, source: source, destination: destination)
                }
                .onDelete { deleteIndexSet in
                    print("ZEFIX - onDelete")
//                    channels.remove(atOffsets: deleteIndexSet)
                }
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

    private func onMove(channels: [Channel]?, source: IndexSet, destination: Int) {
        guard var channels else {
            return
        }

        print("ZEFIX - move source: \(source), destination: \(destination)")
        channels.move(fromOffsets: source, toOffset: destination)
        print("ZEFIX - channels: \(channels)")

        store.dispatch(action: ChannelsDomain.Action.onChannelsEdited(channels: channels))
    }
}

struct TVChannelEditorView_Previews: PreviewProvider {
    static var previews: some View {
        TVChannelEditorView()
    }
}
