//
//  VirtualizationPrivate.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/24/22.
//

#if CANNED_MAC_USE_PRIVATE_APIS
import Foundation
import Virtualization

@objc protocol _VZAppleTouchScreenConfiguration {
    init()
}

@objc protocol _VZEFIBootLoader {
    init()

    var efiURL: URL { get }
    var VariableStore: _VZEFIVariableStore { get set }
}

@objc protocol _VZEFIVariableStore {
    init(url: URL) throws
}

@objc protocol _VZGDBDebugStubConfiguration {
    init(port: Int)
}

@objc protocol _VZVirtualMachineConfiguration {
    var _debugStub: _VZGDBDebugStubConfiguration { get @objc(_setDebugStub:) set }
}

@objc protocol _VZVNCNoSecuritySecurityConfiguration {
    init()
}

@objc protocol _VZVNCServer {
    init(port: Int, queue: DispatchQueue, securityConfiguration: AnyObject)

    var virtualMachine: VZVirtualMachine { get @objc(setVirtualMachine:) set }
    var port: Int { get }

    func start()
    func stop()
}

@objc protocol _VZVirtualMachine {
    @objc(_startWithOptions:completionHandler:)
    func _start(with options: _VZVirtualMachineStartOptions) async throws
}

@objc protocol _VZVirtualMachineStartOptions {
    init()
    var panicAction: Bool { get set }
    var stopInIBootStage1: Bool { get set }
    var stopInIBootStage2: Bool { get set }
    var bootMacOSRecovery: Bool { get set }
    var forceDFU: Bool { get set }
}

class VZEVirtualMachineStartOptions {
    var panicAction: Bool?
    var stopInIBootStage1: Bool?
    var stopInIBootStage2: Bool?
    var bootMacOSRecovery: Bool?
    var forceDFU: Bool?

    func toActualOptions() -> _VZVirtualMachineStartOptions {
        let options = unsafeBitCast(NSClassFromString("_VZVirtualMachineStartOptions")!, to: _VZVirtualMachineStartOptions.Type.self).init()

        if let panicAction = panicAction {
            options.panicAction = panicAction
        }

        if let stopInIBootStage1 = stopInIBootStage1 {
            options.stopInIBootStage1 = stopInIBootStage1
        }

        if let stopInIBootStage2 = stopInIBootStage2 {
            options.stopInIBootStage2 = stopInIBootStage2
        }

        if let bootMacOSRecovery = bootMacOSRecovery {
            options.bootMacOSRecovery = bootMacOSRecovery
        }

        if let forceDFU = forceDFU {
            options.forceDFU = forceDFU
        }
        return options
    }
}

extension VZVirtualMachineConfiguration {
    func setGdbDebugStub(_ gdb: _VZGDBDebugStubConfiguration) {
        unsafeBitCast(self, to: _VZVirtualMachineConfiguration.self)._debugStub = gdb
    }
}

extension VZVirtualMachine {
    func extendedStart(with options: VZEVirtualMachineStartOptions) async throws {
        try await unsafeBitCast(self, to: _VZVirtualMachine.self)._start(with: options.toActualOptions())
    }
}

enum VZPrivateUtilities {
    static func createEfiBootLoader() -> _VZEFIBootLoader {
        unsafeBitCast(NSClassFromString("_VZEFIBootLoader")!, to: _VZEFIBootLoader.Type.self).init()
    }

    static func createGdbDebugStub(_ port: Int) -> _VZGDBDebugStubConfiguration {
        unsafeBitCast(NSClassFromString("_VZGDBDebugStubConfiguration")!, to: _VZGDBDebugStubConfiguration.Type.self).init(port: port)
    }
}
#endif
