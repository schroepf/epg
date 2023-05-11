import SwiftUI
import NukeUI

struct ChannelCell: View {
    let channel: Channel

    var body: some View {
        HStack {
            ChannelIcon(icon: channel.icon)
                .frame(maxWidth: 50, maxHeight: 100)
            Text("\(channel.name)")
        }
    }
}

struct ChannelIcon: View {
    let icon: Icon?

    var body: some View {
        LazyImage(url: icon?.url) { state in
            if let image = state.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if state.error != nil {
                Image(systemName: "xmark.icloud.fill")
            } else {
                Image(systemName: "tv.fill")
            }
        }
    }
}

struct ChannelCell_Previews: PreviewProvider {
    static var previews: some View {
        return ChannelCell(
            channel: Channel(
                id: "123",
                name: "3sat",
                icon: URL(string: "https://images.tvdirekt.de/images/stories/stations/light/large/3sat.png").map(Icon.init)
            )
        )
    }
}
