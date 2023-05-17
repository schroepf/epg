import Foundation

extension Icon {
    func forSize(size: CGSize) -> URL? {
        if (url.host() == "image.fzdigital.de") {
            return URL(string: "https://image.fzdigital.de/\(Int(size.width))x\(Int(size.height))/\(url.lastPathComponent)")
        } else if (url.host() == "epg-images.tvdirekt.de") {
            return URL(string: "https://epg-images.tvdirekt.de/\(Int(size.width))x\(Int(size.height))/\(url.lastPathComponent)")
        }

        return url
    }
}
