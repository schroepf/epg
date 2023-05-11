import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")

        if #available(tvOS 11.0, *) {
            NotificationCenter.default.addObserver(forName: UIFocusSystem.movementDidFailNotification, object: nil, queue: .main) { notification in
                let context = notification.userInfo![UIFocusSystem.focusUpdateContextUserInfoKey] as! UIFocusUpdateContext
                print(context) // If you add a breakpoint here you can quicklook the context in the debugger for more information
//                        print(UIFocusDebugger.checkFocusability(for: self!.collectionView)) // replace collectionView with the view you want to check
            }
        }

        URLCache.shared.memoryCapacity = 10_000_000 // ~10 MB memory space
        URLCache.shared.diskCapacity = 1_000_000_000 // ~1GB disk cache space

        return true
    }
}
