import SwiftUI

struct TVWallpaperView: View {
    @FocusedValue(\.focusedEpgEntry) var focusedEpgEntry
    @FocusedValue(\.focusedChannel) var focusedChannel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack(alignment: .topLeading) {
                    AsyncImage(url: focusedEpgEntry?.artwork?.forSize(size: geometry.size))

                    HStack(alignment: .center) {
                        ChannelIcon(icon: focusedChannel?.icon)
                            .frame(maxWidth: 100, maxHeight: 100)
                        Spacer()
                        Text(focusedChannel?.name ?? "")
                        Spacer()
                    }
                }
                .ignoresSafeArea()
            }
        }
    }
}

struct TVWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        TVWallpaperView()
    }
}
