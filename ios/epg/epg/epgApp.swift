import SwiftUI

@main
struct epgApp: App {
    private let epgService: EpgService = .init()    // FIXME!!!
    private let channelRepository: ChannelRepository = ChannelRepositoryImpl(
        epgService: EpgService(),
        dataSource: CoreDataChannelDataSource()
    )

    var body: some Scene {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                logMiddleware(),
                epgMiddleware(epgService: epgService),
                persistenceMiddleware(epgRepository: channelRepository)
            ]
        )

        WindowGroup {
            ChannelsListView().environmentObject(store)
        }
    }
}
