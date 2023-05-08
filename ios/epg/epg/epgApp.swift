//
//  epgApp.swift
//  epg
//
//  Created by Tobias Schröpf on 08.05.23.
//

import SwiftUI

@main
struct epgApp: App {
    var body: some Scene {

        let store = Store(reducer: reduce)

        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
