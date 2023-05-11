import Foundation

extension URL {
    static func fallbackImageUrl(size: CGSize) -> URL? {
        return URL(string: "https://picsum.photos/\(Int(size.width))/\(Int(size.height))")
    }
}
