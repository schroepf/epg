import Foundation

func epgMiddleware() -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case _ as LoadEpgDataFromLocalXmlAsync:
            DispatchQueue.global().async {

                let data = Bundle.main.data(forResource: "epg", withExtension: "xml.gz")
                let epg = Epg.parse(xmlData: data ?? Data())
                print("Finished parsing XML: \(epg?.debugDescription ?? "nil")")

                dispatch(SetEpgData(epg: epg))
            }

        case let action as LoadEpgDataFromRemoteXmlAsync:
            DispatchQueue.global().async {

                EpgService().getEpg(url: action.url) { result in
                    switch result {
                    case .success(let epg):
                        print("Finished downloading XML from \(action.url): \(epg.debugDescription)")
                        dispatch(SetEpgData(epg: epg))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        default:
            break
        }
    }
}
