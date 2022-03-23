//
//  CannedMacView.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import SwiftUI

struct CannedMacView: View {
    @ObservedObject
    var can = CannedMac()

    var body: some View {
        VStack {
            switch can.state {
            case .installingMacOS:
                InstallerView(can: can)
                    .padding()
            case .bootVirtualMachine:
                VirtualMachineView(can.vm)
            case .downloadInstaller:
                DownloadInstallerView(can: can)
                    .padding()
            case .error:
                Text("ERROR: \(can.error?.localizedDescription ?? "Unknown")")
                    .padding()
            default:
                Text("Unknown State")
                    .padding()
            }
        }.task {
            do {
                try await can.bootVirtualMachine()
            } catch {
                can.setCurrentError(error)
            }
        }
        .frame(minWidth: 800, idealWidth: 1920, maxWidth: nil, minHeight: 450, idealHeight: 1080, maxHeight: nil, alignment: .center)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CannedMacView()
    }
}
