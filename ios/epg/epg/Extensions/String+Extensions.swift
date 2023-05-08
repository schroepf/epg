import Foundation

extension String {
    func urlEncode() -> String {
        self.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? self
    }

    func toInt() -> Int {
        let doubleValue = Double(self) ?? 0.0
        return Int(doubleValue.rounded())
    }
}
