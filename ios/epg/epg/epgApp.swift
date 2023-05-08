import SwiftUI

@main
struct epgApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                logMiddleware(),
                epgMiddleware()
            ]
        )

        WindowGroup {
            ChannelsListView().environmentObject(store)
        }
    }
}
