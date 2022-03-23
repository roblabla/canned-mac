//
//  DownloadInstallerView.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import Foundation
import SwiftUI

struct DownloadInstallerView: View {
    @ObservedObject var can: CannedMac

    var body: some View {
        VStack {
            Text("Downloading macOS Installer")
            ProgressView(can.downloadProgress ?? Progress())
        }
    }
}
