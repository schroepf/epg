import SwiftUI

@main
struct epgApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let epgService: EpgService = .init()
    private let coreDataDataSource = CoreDataDataSource()

    var body: some Scene {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                epgMiddleware(epgService: epgService),
                persistenceMiddleware(
                    channelRepository: ChannelRepositoryImpl(dataSource: coreDataDataSource),
                    epgRepository: EpgRepositoryImpl(dataSource: coreDataDataSource)
                )
            ]
        )

        WindowGroup {
            #if os(iOS)
            ChannelsListView().environmentObject(store)
            #elseif os(tvOS)
            TVChannelsListView().environmentObject(store)
            #endif
        }
    }
}
