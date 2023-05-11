import Foundation

extension Icon {
    func forSize(size: CGSize) -> URL? {
        if (url.host() == "image.fzdigital.de") {
            return URL(string: "https://image.fzdigital.de/\(Int(size.width))x\(Int(size.height))/\(url.lastPathComponent)")
        }

        return url
    }
}
