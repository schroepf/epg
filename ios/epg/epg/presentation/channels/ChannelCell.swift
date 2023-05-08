import SwiftUI

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
        AsyncImage(url: icon?.url) { phase in
            switch phase {
            case .empty:
                Image(systemName: "tv.fill")
            case .success(let image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            case .failure:
                Image(systemName: "xmark.icloud.fill")
            @unknown default:
                EmptyView()
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
