//
//  CannedMacView.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import SwiftUI
import Virtualization

struct CannedMacView: View {
    @ObservedObject
    var can = CannedMac()

    var inhibit: Bool = false

    var body: some View {
        VStack {
            switch can.state {
            case .downloadInstaller:
                DownloadInstallerView(can: can)
                    .padding()
            case .installingMacOS:
                InstallerView(can: can)
                    .padding()
            case .bootVirtualMachine:
                VirtualMachineView(can.vm, capturesSystemKeys: true)
            case .error:
                Text("ERROR: \(can.error?.localizedDescription ?? "Unknown")")
                    .padding()
            default:
                Text("macOS in a can")
                    .padding()
            }
        }
        .task {
            if !inhibit {
                do {
                    try await can.bootVirtualMachine()
                } catch {
                    can.setCurrentError(error)
                }
            }
        }
        .onDisappear {
            can.vm?.stop { _ in }
        }
        .toolbar {
            ToolbarItem {
                if can.currentVmState == .stopped {
                    Button("􀊄") {
                        can.vm?.start { _ in }
                    }
                } else {
                    Button("􀛷") {
                        can.vm?.stop { _ in }
                    }
                }
            }
        }
        .frame(
            minWidth: 800,
            idealWidth: 1920,
            maxWidth: nil,
            minHeight: 450,
            idealHeight: 1080,
            maxHeight: nil,
            alignment: .center
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CannedMacView(
            inhibit: true
        )
    }
}
