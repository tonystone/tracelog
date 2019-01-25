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

    /// Defaults for init values
    ///
    public enum Default {

        /// File name to use for the log file.
        ///
        public static let fileName: String = "tracelog.log"

        /// Log file date formatter
        ///
        public static let fileNameDateFormatter: DateFormatter = {
            var formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd-HHmm-ss-SSS"

            return formatter
        }()

        /// The directory to store log files in.
        ///
        public static let directory: String = "./"

        ///  Max file size a log file will grow before being rotated.
        ///
        public static let maxFileSize = UInt64(1024 * 1024 * 10)

        /// Strip all control (formating) chars from the message before logging.
        ///
        /// - Note: true allows you to parse the log files much easier since each
        ///         message is terminated by a single newline.  If you use false, all
        ///         formatting is left in the message making it easier for humans to
        ///         read but harder for the machine to parse.
        ///
        public static let options: Set<TextFormat.Option> = [.controlCharacters(.strip)]
    }

    /// Represents log file configuration settings
    ///
    public struct FileConfiguration: Equatable {
        public let name: String
        public let directory: String
        public let maxSize: UInt64

        internal var url: URL {
            return URL(fileURLWithPath: directory).appendingPathComponent(name)
        }

        public init(name: String = Default.fileName, directory: String = Default.directory, maxSize: UInt64 = Default.maxFileSize) {
            self.name      = name
            self.directory = directory
            self.maxSize   = maxSize
        }
    }
}

/// File `Writer` which writes log output to an os file.
///
public class FileWriter: OutputStreamWriter {

    /// OutputStreamFormatter being used for formating output.
    ///
    public let format: OutputStreamFormatter

    /// Default constructor for this writer
    ///
    public init(fileConfiguration config: FileConfiguration = FileConfiguration(), format: OutputStreamFormatter = TextFormat(options: Default.options), fileNameDateFormatter: DateFormatter = Default.fileNameDateFormatter) throws {
        self.format = format
        self.mutex = Mutex(.normal)
        self.fileNameDateFormatter = fileNameDateFormatter

        /// If an existing file is present, archive it before starting.
        ///
        if FileManager.default.fileExists(atPath: config.url.path) {
            try archive(fileURL: config.url, dateFormatter: fileNameDateFormatter)
        }

        /// Open the file for writing.
        self.file = (stream: try open(fileURL: config.url), config: config)
    }

    deinit {
        close(fileStream: self.file.stream)
    }

    /// Required write function for the logger
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        let result = format.bytes(from: entry)

        guard case .success(let bytes) = result
            else { return result.map({ (_) in 0 }).mapError({ .error($0) })  }

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
        if self.file.stream.position + UInt64(bytes.count) >= file.config.maxSize {
            self.file = rotate(file: self.file, fallbackStream: Standard.out, dateFormatter: self.fileNameDateFormatter)
        }

        /// Write message to log
        ///
        return self.file.stream.write(bytes).mapError({ FailureReason($0) })
    }

    /// Internal type used by FileWriter and various utility functions.
    ///
    internal typealias LogFile = (stream: FileOutputStream, config: FileConfiguration)

    private let fileNameDateFormatter: DateFormatter

    /// The currently open log file handle and configuration.
    ///
    private var file: LogFile

    /// Low level mutex for locking print since it's not reentrant.
    ///
    private var mutex: Mutex
}

/// Maps an OutputStreamError to a Writer.FailureReason for this class only.
///
internal /* @testable */
extension FailureReason {

    init(_ error: OutputStreamError) {
        switch error {

        /// For files, these are the recoverable errors
        ///
        case .networkDown(_):                      fallthrough
        case .disconnected(_):                     self = .unavailable

        /// A file can't recover any other error type.
        ///
        default:
            self = .error(error)
        }
    }
}

/// Errors thrown from FileWriter init.
///
public extension FileWriter {

    enum Error: Swift.Error, CustomStringConvertible {
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
}

/// Rotate the log file specified falling back to the fallbackStream if the new log file cannot be opened.
///
internal /* @testable */
func rotate(file: FileWriter.LogFile, fallbackStream: FileOutputStream, dateFormatter: DateFormatter) -> FileWriter.LogFile {

    close(fileStream: file.stream)

    do {
        try archive(fileURL: file.config.url, dateFormatter: dateFormatter)

    } catch {
        _ = fallbackStream.write(Array("\(error)\n".utf8))
    }
    return (stream: open(fileURL: file.config.url, fallbackStream: fallbackStream), config: file.config)
}

/// Note: fileStream must be closed before calling this function.
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

/// Opens the file returning a FileStream and creates the file first if not created.
///
internal /* @testable */
func open(fileURL url: URL) throws -> FileOutputStream {

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

    return try FileOutputStream(url: url)
}

/// Open the file at fileURL return the default file handle if it can not be opened.
///
internal /* @testable */
func open(fileURL url: URL, fallbackStream: FileOutputStream) -> FileOutputStream {

    do {
        return try open(fileURL: url)

    } catch {
        _ = fallbackStream.write(Array("\(error)\n".utf8))

        return fallbackStream
    }
}

/// Flushes and closed the file handle passed in.
///
internal /* @testable */
func close(fileStream: FileOutputStream) {
//    fileStream.synchronizeFile()
    fileStream.close()
}
