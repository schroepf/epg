import Foundation

func epgMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case _ as LoadEpgDataFromXmlAsync:
            DispatchQueue.global().async {

                let data = Bundle.main.data(forResource: "epg", withExtension: "xml.gz")
                let epg = Epg.parse(xmlData: data ?? Data())
                print("Finished parsing XML: \(epg?.debugDescription ?? "nil")")

                dispatch(SetEpgData(epg: epg))
            }
        default:
            break
        }
    }
}

