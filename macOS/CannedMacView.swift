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
    var can: CannedMac

    @State
    var isResetVirtualMachineDialogOpen = false

    @AppStorage("virtualMachineMemory")
    private var virtualMachineMemoryGigabytes = 4.0

    @AppStorage("virtualMachineAutoBoot")
    private var virtualMachineAutoBoot = true

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
            case .error:
                Text(can.error?.localizedDescription ?? "Unknown")
                    .padding()
            default:
                VirtualMachineView(can.vm, capturesSystemKeys: true)
            }
        }
        .task {
            if !inhibit, virtualMachineAutoBoot, can.currentVmState == .stopped {
                await bootVirtualMachine()
            }
        }
        .toolbar {
            ToolbarItem {
                if can.currentVmState == .stopped {
                    Button("􀊄") {
                        if let vm = can.vm {
                            vm.start { _ in }
                        } else {
                            Task {
                                await bootVirtualMachine()
                            }
                        }
                    }
                } else {
                    Button("􀛷") {
                        can.vm?.stop { _ in }
                    }
                }
            }

            ToolbarItem {
                Button("􀈒") {
                    isResetVirtualMachineDialogOpen = true
                }
            }
        }
        .confirmationDialog("Reset Virtual Machine", isPresented: $isResetVirtualMachineDialogOpen) {
            Button("Reset", role: .destructive) {
                Task {
                    try await can.deleteVirtualMachine(memory: Int(virtualMachineMemoryGigabytes))
                }
            }

            Button("Keep", role: .cancel) {}.keyboardShortcut(.defaultAction)
        }
        .frame(
            minWidth: 800,
            idealWidth: 1920,
            maxWidth: nil,
            minHeight: 500,
            idealHeight: 1080,
            maxHeight: nil,
            alignment: .center
        )
    }

    func bootVirtualMachine() async {
        do {
            try await can.bootVirtualMachine(
                memory: Int(virtualMachineMemoryGigabytes)
            )
        } catch {
            can.setCurrentError(error)
        }
    }
}

struct CannedMacView_Previews: PreviewProvider {
    static var previews: some View {
        CannedMacView(
            can: CannedMac(),
            inhibit: true
        )
    }
}
