import SwiftUI

@main
struct epgApp: App {
    enum Dependencies {
        static let epgService: EpgService = .init()
        static let coreDataDataSource = CoreDataDataSource()
    }

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @StateObject var store = Store(
        reducer: appReducer,
        state: AppState(),
        middlewares: [
            epgMiddleware(epgService: Dependencies.epgService),
            persistenceMiddleware(
                channelRepository: ChannelRepositoryImpl(dataSource: Dependencies.coreDataDataSource),
                epgRepository: EpgRepositoryImpl(dataSource: Dependencies.coreDataDataSource)
            )
        ]
    )

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ChannelsListView().environmentObject(store)
            #elseif os(tvOS)
            TVChannelsListView().environmentObject(store)
            #endif
        }
        .onChange(of: scenePhase) { newScenePhase in
            if newScenePhase == .active {
                store.dispatch(action: LoadChannels())
            }
        }
    }
}
