import NukeUI
import SwiftUI

struct TVWallpaperView: View {
    @FocusedValue(\.focusedEpgEntry) var focusedEpgEntry
    @FocusedValue(\.focusedChannel) var focusedChannel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ZStack(alignment: .topLeading) {
                    LazyImage(url: focusedEpgEntry?.artwork?.forSize(size: geometry.size), transaction: Transaction(animation: .default)) { state in
                        if let image = state.image {
                            image
                        } else if state.error != nil {
                            AsyncImage(url: .fallbackImageUrl(size: geometry.size))
                        }
                    }

                    HStack(alignment: .center) {
                        ChannelIcon(icon: focusedChannel?.icon)
                            .frame(maxWidth: 100, maxHeight: 100)
                        Spacer()
                        Text(focusedChannel?.name ?? "")
                        Spacer()
                    }
                    .padding([.horizontal], 90)
                    .padding([.vertical], 60)
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct TVWallpaperView_Previews: PreviewProvider {
    static var previews: some View {
        TVWallpaperView()
    }
}
