//
//  InstallerView.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import Foundation
import SwiftUI

struct InstallerView: View {
    @ObservedObject var can: CannedMac

    var body: some View {
        VStack {
            Text("Installing macOS")
            ProgressView(can.installerProgress ?? Progress())
        }
    }
}
