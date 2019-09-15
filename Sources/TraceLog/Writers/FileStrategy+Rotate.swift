///
///  FileStrategyRotate.swift
///
///  Copyright 2019 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 2/1/19.
///
import CoreFoundation
import Foundation

internal class FileStrategyRotate: FileStrategyManager {

    /// The current url in use or if none open yet, the one that will be used.
    ///
    var url: URL {
        return self.stream.url
    }

    /// Initialize the FileStrategy with the directory for files, the template for
    /// file naming, and the options for rotation.
    ///
    /// - Parameters:
    ///     - directory: The directory URL that the strategy will write files to.
    ///     - template: The naming template to use for naming files.
    ///     - options: The rotation options to use for file rotation.
    ///
    init(directory: URL, template: String, options: Set<FileWriter.Strategy.RotationOption>) throws {

        var rotate: (onStartup: Bool, maxSize: UInt64?) = (false, nil)

        for option in options {
            switch option {
                case .startup:              rotate.onStartup = true
                case .maxSize(let maxSize): rotate.maxSize   = maxSize
            }
        }
        let fileStreamManager = FileStreamManager(directory: directory, template: template)

        /// Open the file for writing.
        self.stream = rotate.onStartup ? try fileStreamManager.openNewFileStream() : try fileStreamManager.openLatestFileStream()

        self.fileStreamManager = fileStreamManager
        self.rotate            = rotate
        self.mutex             = Mutex(.normal)
    }

    /// Required implementation for FileStrategyManager classes.
    ///
    func write(_ bytes: [UInt8]) -> Result<Int, FailureReason> {

        /// Note: Since we could be called on any thread in TraceLog direct mode
        /// we protect the file with a low-level mutex.
        ///
        /// PThreads mutexes were chosen because out of all the methods of synchronization
        /// available in swift (queue, dispatch semaphores, etc), PThread mutexes are
        /// the lowest overhead and fastest lock.
        ///
        /// We also want to ensure we maintain thread boundaries when in direct mode (avoid
        /// jumping threads).
        ///
        mutex.lock(); defer { mutex.unlock() }

        /// Does the file need to be rotated?
        if let maxSize = self.rotate.maxSize, self.stream.position + UInt64(bytes.count) >= maxSize {
            do {
                /// Open the new file first so that if we get an error, we can leave the old stream as is
                let newStream = try fileStreamManager.openNewFileStream()

                self.stream.close()
                self.stream = newStream
            } catch {
                return .failure(.error(error))
            }
        }
        return self.stream.write(bytes).mapError({ self.failureReason($0) })
    }

    /// Rotation options.
    ///
    private let rotate: (onStartup: Bool, maxSize: UInt64?)

    /// File configuration for naming file.
    ///
    private let fileStreamManager: FileStreamManager

    /// The outputStream to use for writing.
    ///
    private var stream: FileOutputStream

    /// Low level mutex for locking print since it's not reentrant.
    ///
    private let mutex: Mutex
}

/// Represents log file configuration settings
///
internal /* @testable */
struct FileStreamManager: Equatable {

    internal init(directory: URL, template: String) {
        self.directory     = directory
        self.nameFormatter = DateFormatter()
        self.nameFormatter.dateFormat = template

        let metaDirectory = directory.appendingPathComponent(".tracelog", isDirectory: true)

        self.metaDirectory = metaDirectory
        self.metaFile      = metaDirectory.appendingPathComponent("filewriter.meta", isDirectory: false)
    }

    /// Open the output stream creating the meta file when created
    ///
    internal func openNewFileStream() throws -> FileOutputStream {
        let newURL = self.newFileURL()

        try writeMetaFile(for: newURL)

        return try FileOutputStream(url: newURL, options: [.create])
    }

    /// Find the latest log file by creation date that exists.
    ///
    /// - Returns: a URL if there is an existing file otherwise, nil.
    ///
    internal func openLatestFileStream() throws -> FileOutputStream {
        let latestURL = latestFileURL()

        try writeMetaFile(for: latestURL)

        return try FileOutputStream(url: latestURL, options: [.create])
    }

    /// Create a file URL based on the files configuration.
    ///
    internal /* @testable */
    func newFileURL() -> URL {
        return self.directory.appendingPathComponent(self.nameFormatter.string(from: Date()))
    }

    /// Find the latest log file by creation date that exists.
    ///
    /// - Returns: a URL if there is an existing file otherwise, nil.
    ///
    internal /* @testable */
    func latestFileURL() -> URL {

        guard let latestPath = try? String(contentsOf: self.metaFile, encoding: .utf8)
            else { return self.newFileURL() }

        return URL(fileURLWithPath: latestPath, isDirectory: false)
    }

    /// Writes a meta file out for the url passed.
    ///
    private func writeMetaFile(for url: URL) throws {

        /// Write the file that contains the last path.
        do {
            if !FileManager.default.fileExists(atPath: self.metaDirectory.path) {
                try FileManager.default.createDirectory(at: self.metaDirectory, withIntermediateDirectories: true)
            }

            try url.path.write(to: self.metaFile, atomically: false, encoding: .utf8)
        } catch {
            throw FileOutputStreamError.unknownError(0, error.localizedDescription)
        }
    }


    private let directory: URL

    private var metaDirectory: URL

    private var metaFile: URL

    private let nameFormatter: DateFormatter
}
