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

    var url: URL {
        return self.stream.url
    }

    init(directory: URL, template: String, options: Set<FileStrategy.RotateOption>) throws {

        let config = FileConfiguration(directory: directory, template: template)

        for option in options {
            switch option {
            case .startup: break
            case .maxSize(let maxSize):
                self.maxSize = maxSize
            case .age(_):
                break
            }
        }
        let url = options.contains(.startup) ? config.newFileURL() : config.latestFileURL()

        self.mutex = Mutex(.normal)
        self.config = config

        /// Open the file for writing.
        self.stream = try FileOutputStream(url: url, options: [.create])
    }

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
        if let maxSize = self.maxSize, self.stream.position + UInt64(bytes.count) >= maxSize {
            do {
                /// Open the new file first so that if we get an error, we can leave the old stream as is
                let newStream = try FileOutputStream(url: config.newFileURL(), options: [.create])
                self.stream.close()

                self.stream = newStream
            } catch {
                return .failure(.error(error))
            }
        }
        return self.stream.write(bytes).mapError({ self.failureReason($0) })
    }


    private var maxSize: UInt64?

    private let config: FileConfiguration
    private var stream: FileOutputStream

    /// Low level mutex for locking print since it's not reentrant.
    ///
    private var mutex: Mutex
}

/// Represents log file configuration settings
///
internal /* @testable */
struct FileConfiguration: Equatable {

    public let directory: URL

    public var template: String {
        return self.nameFormatter.dateFormat
    }

    public init(directory: URL, template: String) {
        self.directory     = directory
        self.nameFormatter = DateFormatter()

        self.nameFormatter.dateFormat = template
    }

    private let nameFormatter: DateFormatter

    /// Create a file URL based on the files configuration.
    ///
    internal func newFileURL() -> URL {
        return self.directory.appendingPathComponent(self.nameFormatter.string(from: Date()))
    }

    /// Find the latest log file by creation date that exists.
    ///
    /// - Returns: a URL if there is an existing file otherwise, nil.
    ///
    internal func latestFileURL() -> URL {

        guard let contents = try? FileManager.default.contentsOfDirectory(at: self.directory, includingPropertiesForKeys: [.isDirectoryKey, .attributeModificationDateKey], options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles, .skipsPackageDescendants])
            else { return self.newFileURL() }

        let logs = contents.compactMap( { url -> (url: URL, modificationDate: Date?)? in

            guard url.isFileURL
                else { return nil }

            /// If we can convert the string to a date using the
            /// formatter for creating file dates, this is a log file.
            /// because it matches the entire pattern (prefix+date+extension.)
            ///
            guard self.nameFormatter.date(from: url.lastPathComponent) != nil
                else { return nil }

            return (url: url, modificationDate: url.modificationDate)

            /// Sort nils to the end (these files have not yet been created)
        }).sorted(by: { ($0.modificationDate ?? .distantFuture) < ($1.modificationDate ?? .distantFuture) })

        guard let latest = logs.last
            else { return self.newFileURL() }

        return latest.0
    }
}

private extension URL {

    var modificationDate: Date? {
        guard let values = try? FileManager.default.attributesOfItem(atPath: self.path)
            else { return nil }
        return values[FileAttributeKey.modificationDate] as? Date
    }
}

