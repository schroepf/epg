import Foundation

extension EpgEntry {
    func formatStartEndTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let startString = dateFormatter.string(from: start)
        let endString = dateFormatter.string(from: stop)

        return "\(startString) - \(endString) Uhr"
    }
}
