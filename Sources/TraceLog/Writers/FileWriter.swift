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

extension FileWriter {

    public enum Error: Swift.Error, CustomStringConvertible {
        case createFailed(String)
        case fileDoesNotExist(String)

        public var description: String {
            switch self {
            case let .createFailed(message):
                return message
            case let .fileDoesNotExist(message):
                return message
            }
        }
    }

    ///
    /// Defaults for init values
    ///
    public enum Default {

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
        ///  Max file size a log file will grow before being rotated.
        ///
        public static let maxFileSize = UInt64(1024 * 1024 * 10)

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
        /// Strip all formatting chars from the message before logging.
        ///
        /// - Note: true allows you to parse the log files much easier since each
        ///         message is terminated by a single newline.  If you use false, all
        ///         formatting is left in the message making it easier for humans to
        ///         read but harder for the machine to parse.
        ///
        public static let stripFormatting: Bool = true
    }

    ///
    /// Represents log file configuration settings
    ///
    public struct FileConfiguration: Equatable {
        public let name: String
        public let directory: String
        public let encoding: String.Encoding
        public let maxSize: UInt64

        internal var url: URL {
            return URL(fileURLWithPath: directory).appendingPathComponent(name)
        }

        public init(name: String = Default.fileName, directory: String = Default.directory, encoding: String.Encoding = Default.encoding, maxSize: UInt64 = Default.maxFileSize) {
            self.name      = name
            self.directory = directory
            self.encoding  = encoding
            self.maxSize   = maxSize
        }
    }
}

///
/// File `Writer` which writes log output to an os file.
///
public class FileWriter: Writer {

    ///
    /// Internal type used by FileWriter and various utility functions.
    ///
    internal typealias LogFile = (handle: FileHandle, config: FileConfiguration)

    ///
    /// Default constructor for this writer
    ///
    public init(fileConfiguration config: FileConfiguration = FileConfiguration(), stripFormatting: Bool = Default.stripFormatting, dateFormatter: DateFormatter = Default.dateFormatter) throws {

        self.dateFormatter   = dateFormatter
        self.mutex           = Mutex(.normal)
        self.stripFormatting = stripFormatting

        ///
        /// If an existing file is present, archive it before starting.
        ///
        if FileManager.default.fileExists(atPath: config.url.path) {
            try archive(fileURL: config.url, dateFormatter: dateFormatter)
        }

        /// Open the file for writng.
        self.file = (handle: try open(fileURL: config.url), config: config)
    }

    deinit {
        close(fileHandle: self.file.handle)
    }

    ///
    /// Required log function for the logger
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogResult {

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

        /// Does the file need to be rotated?
        if self.file.handle.offsetInFile + UInt64(logEntry.utf8.count) >= file.config.maxSize {
            self.file = rotate(file: self.file, fallbackHandle: FileHandle.standardOutput, dateFormatter: self.dateFormatter)
        }

        ///
        /// Write message to log
        ///
        self.file.handle.write(Data(logEntry.utf8))

        mutex.unlock()

        return .success
    }

    ///
    /// The currently open log file handle and configuration.
    ///
    private var file: LogFile

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

///
/// Rotate the log file specified falling back to the fallbackHandle if the new logi file cannot be opened.
///
internal /* @testable */
func rotate(file: FileWriter.LogFile, fallbackHandle: FileHandle, dateFormatter: DateFormatter) -> FileWriter.LogFile {

    close(fileHandle: file.handle)

    do {
        try archive(fileURL: file.config.url, dateFormatter: dateFormatter)

    } catch {
        fallbackHandle.write(Data("\(error)\n".utf8))
    }
    return (handle: open(fileURL: file.config.url, fallbackHandle: fallbackHandle), config: file.config)
}

///
/// Note: fileHandle must be closed before calling this function.
///
internal /* @testable */
func archive(fileURL url: URL, dateFormatter: DateFormatter) throws {

    let fileManager = FileManager.default

    guard fileManager.fileExists(atPath: url.path)
        else { throw FileWriter.Error.fileDoesNotExist("Failed to archive, file does not exist: \(url.absoluteString)")}

    /// Rotate if exists
    let directory = url.deletingLastPathComponent()
    let rootName  = url.deletingPathExtension().lastPathComponent

    let archivedFileURL = directory.appendingPathComponent("\(rootName)-\(dateFormatter.string(from: Date())).log")

    try fileManager.moveItem(at: url, to: archivedFileURL)
}

///
/// Opens the file returning a FileHandle and creates the file first if not created.
///
internal /* @testable */
func open(fileURL url: URL) throws -> FileHandle {

    let fileManager = FileManager.default

    if !fileManager.fileExists(atPath: url.path) {

        ///
        /// Create the directory if it does not exist.
        ///
        /// Note: If the directory already exists this method will succeed if withIntermediateDirectories is true.
        ///
        try fileManager.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)

        guard fileManager.createFile(atPath: url.path, contents: nil, attributes: nil)
            else { throw FileWriter.Error.createFailed("Failed to create log file: \(url.absoluteString)") }
    }

    let fileHandle = try FileHandle(forWritingTo: url)
    fileHandle.seekToEndOfFile()

    return fileHandle
}

///
/// Open the file at fileURL return the default file handle if it can not be opened.
///
internal /* @testable */
func open(fileURL url: URL, fallbackHandle: FileHandle) -> FileHandle {

    do {
        return try open(fileURL: url)

    } catch {
        fallbackHandle.write(Data("\(error)\n".utf8))

        return fallbackHandle
    }
}

///
/// Flushes and closed the file handle passed in.
///
internal /* @testable */
func close(fileHandle: FileHandle) {
    fileHandle.synchronizeFile()
    fileHandle.closeFile()
}

///
/// Extension for stripping out new line formatting.
///
private extension String {

    func withoutFormatting() -> String {
        return self.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\r", with: "").replacingOccurrences(of: "\t", with: " ")
    }
}
