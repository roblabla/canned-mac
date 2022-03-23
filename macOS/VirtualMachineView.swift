//
//  VirtualMachineView.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import Foundation
import SwiftUI
import Virtualization

struct VirtualMachineView: NSViewRepresentable {
    typealias NSViewType = VZVirtualMachineView

    let virtualMachine: VZVirtualMachine?

    init(_ virtualMachine: VZVirtualMachine?) {
        self.virtualMachine = virtualMachine
    }

    func makeNSView(context _: Context) -> VZVirtualMachineView {
        VZVirtualMachineView()
    }

    func updateNSView(_ view: VZVirtualMachineView, context _: Context) {
        view.virtualMachine = virtualMachine
    }
}
