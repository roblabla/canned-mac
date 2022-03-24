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
    private var virtualMachineMemoryGigabytes = 4.0

    @AppStorage("virtualMachineAutoBoot")
    private var virtualMachineAutoBoot = true

    var body: some View {
        Form {
            Toggle("Auto-Boot", isOn: $virtualMachineAutoBoot)

            Slider(value: $virtualMachineMemoryGigabytes, in: toGigabytes(VZVirtualMachineConfiguration.minimumAllowedMemorySize) ... toGigabytes(VZVirtualMachineConfiguration.maximumAllowedMemorySize)) {
                Text("Virtual Machine Memory: \(virtualMachineMemoryGigabytes, specifier: "%.0f")GB")
            }
        }
        .padding()
        .frame(width: 350, height: 100)
    }

    private func toGigabytes(_ value: UInt64) -> Double {
        Double(value) / 1024.0 / 1024.0 / 1024.0
    }
}
