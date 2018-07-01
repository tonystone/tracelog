///
///  FilerWriter.swift
///
///  Copyright 2018 Tony Stone
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
///  Created by Tony Stone on 6/27/18.
///
import Foundation

///
/// File `Writer` which writes log output to an os file.
///
public class FileWriter: Writer {

    ///
    /// Default constructor for this writer
    ///
    public init(fileConfiguration: Configuration = Configuration(), stripFormatting: Bool = Default.stripFormatting, dateFormatter: DateFormatter = Default.dateFormatter) throws {

        self.dateFormatter = dateFormatter
        self.mutex = Mutex(.recursive)

        self.fileConfiguration = fileConfiguration
        self.stripFormatting   = stripFormatting

        try rotate(fileURL: fileConfiguration.fileURL, dateFormatter: dateFormatter)

        self.fileHandle = try open(fileURL: fileConfiguration.fileURL)
    }

    deinit {
        close(fileHandle: self.fileHandle)
    }

    ///
    /// Required log function for the logger
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        let uppercasedLevel = "\(level)".uppercased()
        let levelString     = "\(String(repeating: " ", count: 7 - uppercasedLevel.count))\(uppercasedLevel)"
        let message         = self.stripFormatting ? message.withoutFormatting() : message

        let logEntry = "\(self.dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))) \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] \(levelString): <\(tag)> \(message)\n"

        ///
        /// Note: Since we could be called on any thread in TraceLog direct mode
        /// we protect the file with a low-level mutex.
        ///
        /// Pthreads mutexes were chosen because out of all the methods of synchronization
        /// available in swift (queue, dispatch semaphores, etc), pthread mutexes are
        /// the lowest overhead and fastest lock.
        ///
        /// We also want to ensure we maintain thread boundaries when in direct mode (avoid
        /// jumping threads).
        ///
        mutex.lock()

        fileHandle.write(Data(logEntry.utf8))

        mutex.unlock()
    }

    ///
    /// Zthe currently open log file handle.
    ///
    private var fileHandle: FileHandle

    ///
    /// Configuration for the file and file management.
    ///
    private let fileConfiguration: Configuration

    ///
    /// Should we strip the formatting chars from messages.
    ///
    private let stripFormatting: Bool

    ///
    /// DateFormater being used
    ///
    private let dateFormatter: DateFormatter

    ///
    /// Low level mutex for locking print since it's not reentrent.
    ///
    private var mutex: Mutex
}

extension FileWriter {

    ///
    /// Defaults for init values
    ///
    public enum Default {
        ///
        /// Default DateFormatter for this writer if one is not supplied.
        ///
        /// - Note: Format is "yyyy-MM-dd HH:mm:ss.SSS"
        ///
        /// - Example: "2016-04-23 10:34:26.849"
        ///
        public static let dateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"

            return formatter
        }()

        ///
        /// File name to use for the log file.
        ///
        public static let fileName: String = "tracelog.log"

        ///
        /// The directory to store log files in.
        ///
        public static let directory: String = "./"

        ///
        /// Encoding of the messages logged to the log file.
        ///
        public static let encoding: String.Encoding = .utf8

        ///
        /// Strip all formatting chars from the message before logging.
        ///
        /// - Note: true allows you to parse the log files much easier since each
        ///         message is terminated by a single newline.  If you use false, all
        ///         formatting is left in the message making it easier for humans to
        ///         read but harder for the machine to parse.
        ///
        public static let stripFormatting: Bool = true
    }
}

public extension FileWriter {

    public enum Error: Swift.Error {
        case createFailed(String)
    }

    public struct Configuration {
        public let fileName: String
        public let directory: String
        public let encoding: String.Encoding

        internal var fileURL: URL {
            return URL(fileURLWithPath: directory).appendingPathComponent(fileName)
        }

        public init(fileName: String = Default.fileName, directory: String = Default.directory, encoding: String.Encoding = Default.encoding) {
            self.fileName  = fileName
            self.directory = directory
            self.encoding  = encoding
        }
    }
}

private extension String {

    func withoutFormatting() -> String {
        return self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: " ")
    }
}

///
/// Opens the file returning a FileHandle and creates the file first if not created.
///
private func open(fileURL url: URL) throws -> FileHandle {

    let fileManager = FileManager.default

    if !fileManager.fileExists(atPath: url.path) {

        guard fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            else {
                throw FileWriter.Error.createFailed("Failed to create log file: \(url.path)")
        }
    }

    let fileHandle = try FileHandle(forWritingTo: url)
    fileHandle.seekToEndOfFile()

    return fileHandle
}

///
/// Flushes and closed the file handle passed in.
///
private func close(fileHandle: FileHandle) {
    fileHandle.synchronizeFile()
    fileHandle.closeFile()
}

///
/// Note: fileHandle must be closed
///
private func rotate(fileURL url: URL, dateFormatter: DateFormatter) throws {

    let fileManager = FileManager.default

    /// Rotate if exists
    if fileManager.fileExists(atPath: url.path) {
        let directory = url.deletingLastPathComponent()
        let rootName  = url.deletingPathExtension().lastPathComponent

        let archivedFileURL = directory.appendingPathComponent("\(rootName)-\(dateFormatter.string(from: Date())).log")

        try fileManager.moveItem(at: url, to: archivedFileURL)
    }
}
