//
//  SerialPortType.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/25/22.
//

import Foundation
import Virtualization

struct SerialPortType: Codable, RawRepresentable, Hashable {
    typealias RawValue = Int

    let rawValue: Int

    static let virtio = SerialPortType(rawValue: 0)
    static let pl011 = SerialPortType(rawValue: 1)
    static let p16550 = SerialPortType(rawValue: 2)

    func createSerialPortConfiguration() -> VZSerialPortConfiguration {
        if rawValue == SerialPortType.virtio.rawValue {
            return VZVirtioConsoleDeviceSerialPortConfiguration()
        } else if rawValue == SerialPortType.pl011.rawValue {
            return VZPrivateUtilities.createPL011SerialPortConfiguration()
        } else if rawValue == SerialPortType.p16550.rawValue {
            return VZPrivateUtilities.create16550SerialPortConfiguration()
        } else {
            fatalError()
        }
    }

    var hashValue: Int { rawValue.hashValue }
}
