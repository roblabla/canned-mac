//
//  CannedMacSettings.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/23/22.
//

import Foundation
import SwiftUI
import Virtualization

struct CannedMacSettings: View {
    @AppStorage("virtualMachineMemory")
    var virtualMachineMemoryGigabytes = 4.0

    @AppStorage("virtualMachineAutoBoot")
    var virtualMachineAutoBoot = true

    #if CANNED_MAC_USE_PRIVATE_APIS
    @AppStorage("virtualMachineBootRecovery")
    var virtualMachineBootRecovery = false

    @AppStorage("virtualMachineEnableDebugStub")
    var virtualMachineEnableDebugStub = false

    @AppStorage("virtualMachineEnableVncServer")
    var virtualMachineEnableVncServer = false

    @AppStorage("virtualMachineEnableVncServerAuthentication")
    var virtualMachineEnableVncServerAuthentication = false

    @AppStorage("virtualMachineVncServerPort")
    var virtualMachineVncServerPort = 5905

    @AppStorage("virtualMachineVncServerPassword")
    var virtualMachineVncServerPassword = "hunter2"

    @AppStorage("virtualMachineEnableMacInput")
    var virtualMachineEnableMacInput = false
    #endif

    @AppStorage("virtualMachineDisplayResolution")
    var virtualMachineDisplayResolution: DisplayResolution = .r1920_1080

    var body: some View {
        Form {
            Toggle("Auto-Boot", isOn: $virtualMachineAutoBoot)
            #if CANNED_MAC_USE_PRIVATE_APIS
            Toggle("Recovery Mode", isOn: $virtualMachineBootRecovery)
            Toggle("Debug Stub", isOn: $virtualMachineEnableDebugStub)
            Toggle("VNC Server", isOn: $virtualMachineEnableVncServer)

            if virtualMachineEnableVncServer {
                Toggle("VNC Server Authentication", isOn: $virtualMachineEnableVncServerAuthentication)
            }

            Toggle("Mac Input", isOn: $virtualMachineEnableMacInput)
            #endif

            Slider(value: $virtualMachineMemoryGigabytes, in: toGigabytes(VZVirtualMachineConfiguration.minimumAllowedMemorySize) ... toGigabytes(VZVirtualMachineConfiguration.maximumAllowedMemorySize)) {
                Text("Virtual Machine Memory: \(virtualMachineMemoryGigabytes, specifier: "%.0f")GB")
            }

            Picker("Display Resolution", selection: $virtualMachineDisplayResolution) {
                Text("1920x1080").tag(DisplayResolution.r1920_1080)
                Text("3840x2160").tag(DisplayResolution.r3840_2160)
            }

            #if CANNED_MAC_USE_PRIVATE_APIS
            if virtualMachineEnableVncServer {
                TextField("VNC Server Port", value: $virtualMachineVncServerPort, formatter: portNumberFormatter)
                    .textFieldStyle(.roundedBorder)
            }

            if virtualMachineEnableVncServerAuthentication {
                TextField("VNC Server Password", text: $virtualMachineVncServerPassword)
            }
            #endif
        }
        .frame(width: 400)
        .padding()
    }

    private func toGigabytes(_ value: UInt64) -> Double {
        Double(value) / 1024.0 / 1024.0 / 1024.0
    }

    var portNumberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }
}
