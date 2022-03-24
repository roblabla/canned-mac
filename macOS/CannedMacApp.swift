//
//  CannedMacApp.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import SwiftUI

@main
struct CannedMacApp: App {
    @ObservedObject
    var can = CannedMac()

    var body: some Scene {
        WindowGroup {
            CannedMacView(can: can)
        }
        .windowToolbarStyle(.unifiedCompact)

        Settings {
            CannedMacSettings()
        }
    }
}
