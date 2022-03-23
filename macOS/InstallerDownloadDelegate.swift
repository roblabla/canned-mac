//
//  InstallerDownloadDelegate.swift
//  macOS
//
//  Created by Kenneth Endfinger on 3/22/22.
//

import Foundation

class InstallerDownloadDelegate: NSObject, URLSessionDownloadDelegate {
    let progressUpdateCallback: (Int64, Int64) -> Void

    init(_ progressUpdateCallback: @escaping (Int64, Int64) -> Void) {
        self.progressUpdateCallback = progressUpdateCallback
    }

    func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didFinishDownloadingTo _: URL) {}

    func urlSession(_: URLSession, downloadTask _: URLSessionDownloadTask, didWriteData _: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        progressUpdateCallback(totalBytesWritten, totalBytesExpectedToWrite)
    }
}
