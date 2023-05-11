import Foundation

func epgMiddleware(epgService: EpgService) -> Middleware<AppDomain.State> {
    return { state, action, dispatch in
        switch action {
        case AppDomain.Action.fetchEpgDataFromLocalXml:
            Task {
                let data = Bundle.main.data(forResource: "epg", withExtension: "xml.gz")
                let epg = await Epg.parse(xmlData: data ?? Data())

                print("Finished parsing XML: \(epg?.debugDescription ?? "nil")")
                dispatch(AppDomain.Action.saveEpgData(epg: epg))
            }

        case let AppDomain.Action.fetchEpgDataFromRemoteXmlAsync(url):
            Task {
                do {
                    let epg = try await epgService.getEpg(url: url)
                    print("Finished downloading XML from \(url): \(epg.debugDescription)")
                    dispatch(AppDomain.Action.saveEpgData(epg: epg))
                } catch {
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
}
