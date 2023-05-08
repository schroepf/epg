import SwiftUI

@main
struct epgApp: App {
    var body: some Scene {

        let store = Store(
            reducer: appReducer,
            state: AppState(),
            middlewares: [
                logMiddleware(),
                incrementMiddleware(),
                epgMiddleware()
            ]
        )

        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
