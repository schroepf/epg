import SwiftUI

struct EpgCell: View {
    let epgEntry: EpgEntry

    var body: some View {
        VStack(alignment: .leading) {
            Text(epgEntry.title)
                .bold()
                .fontWeight(.heavy)

            Text("Zeit: \(epgEntry.formatStartEndTimeString())")
        }
    }
}

extension EpgEntry {
    func formatStartEndTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        let startString = dateFormatter.string(from: start)
        let endString = dateFormatter.string(from: stop)

        return "\(startString) - \(endString) Uhr"
    }
}

struct EpgCell_Previews: PreviewProvider {
    static var previews: some View {
        let epg = EpgEntry(
            channelId: "BRde",
            title: "Tagesschau",
            summary: "Aktuelle Nachrichten",
            start: Date(),
            stop: Date()
        )
        EpgCell(epgEntry: epg)
    }
}
