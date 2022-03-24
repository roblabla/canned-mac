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
    var can = GlobalVirtualMachine.can

    var body: some Scene {
        WindowGroup {
            CannedMacView(can: can)
        }
        .windowToolbarStyle(.unifiedCompact)
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Reset Virtual Machine") {
                    can.isResetRequested = true
                }
            }
        }

        Settings {
            CannedMacSettings()
        }
    }
}
