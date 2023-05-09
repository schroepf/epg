import Foundation

func epgMiddleware(epgService: EpgService) -> Middleware<AppState> {
    return { state, action, dispatch in
        switch action {
        case _ as FetchEpgDataFromLocalXmlAsync:
            Task {
                let data = Bundle.main.data(forResource: "epg", withExtension: "xml.gz")
                let epg = await Epg.parse(xmlData: data ?? Data())

                print("Finished parsing XML: \(epg?.debugDescription ?? "nil")")
                dispatch(SaveEpgData(epg: epg))
            }

        case let action as FetchEpgDataFromRemoteXmlAsync:
            Task {
                do {
                    let epg = try await epgService.getEpg(url: action.url)
                    print("Finished downloading XML from \(action.url): \(epg.debugDescription)")
                    dispatch(SaveEpgData(epg: epg))
                } catch {
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
