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
    #endif

    @AppStorage("virtualMachineDisplayWidth")
    var virtualMachineDisplayWidth = 1920

    @AppStorage("virtualMachineDisplayResolution")
    var virtualMachineDisplayResolution: DisplayResolution = .r1920_1080

    @AppStorage("virtualMachineDebugStub")
    var virtualMachineDebugStub = false

    var body: some View {
        Form {
            Toggle("Auto-Boot", isOn: $virtualMachineAutoBoot)
            #if CANNED_MAC_USE_PRIVATE_APIS
            Toggle("Recovery Mode", isOn: $virtualMachineBootRecovery)
            Toggle("Debug Stub", isOn: $virtualMachineDebugStub)
            #endif

            Slider(value: $virtualMachineMemoryGigabytes, in: toGigabytes(VZVirtualMachineConfiguration.minimumAllowedMemorySize) ... toGigabytes(VZVirtualMachineConfiguration.maximumAllowedMemorySize)) {
                Text("Virtual Machine Memory: \(virtualMachineMemoryGigabytes, specifier: "%.0f")GB")
            }

            Picker("Display Resolution", selection: $virtualMachineDisplayResolution) {
                Text("1920x1080").tag(DisplayResolution.r1920_1080)
                Text("3840x2160").tag(DisplayResolution.r3840_2160)
            }
        }
        .frame(width: 400)
        .padding()
    }

    private func toGigabytes(_ value: UInt64) -> Double {
        Double(value) / 1024.0 / 1024.0 / 1024.0
    }
}
