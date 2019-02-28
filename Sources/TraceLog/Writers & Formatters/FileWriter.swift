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

/// The `FileWriter` is a fully configurable TraceLog `OutputStreamWriter` implementation
/// that writes it's formatted data to files on persistent storage.
///
/// FileWriter allows file handling strategies to to be configured that determine how
/// the files are named and handled on the storage device.
///
/// Creating a FileWriter is simple using the built in defaults.
/// ```
///     let fileWriter = try FileWriter(directory: URL(fileURLWithPath: "./"))
///
///     TraceLog.configure(writers: [fileWriter])
/// ```
///
/// File Strategies
/// ===============
///
/// FileWriter allows various file management strategies to be configured and
/// used for management of the files on the storage device.  The default strategy
/// is the `.fixed` strategy which will create a fixed file that is continually
/// appended to and never rotated.  If you require a file rotation strategy
/// the `.rotate(at:)` strategy will allow you to set various rotation criteria
/// for the files created.
///
/// To rotate the file every time the the FIleWriter is started, you can pass the
/// `.startup` option to the rotate strategy sd in the example.
/// ```
///     let fileWriter = try FileWriter(directory: URL(fileURLWithPath: "./"), strategy: .rotate(at: [.startup]))
///
///     TraceLog.configure(writers: [fileWriter])
/// ```
///
/// The `.rotate` strategy allows for changing the naming `template` of the file
/// written to the storage device. If you change the default naming you must consider
/// the frequency that your files may rotate so that naming conflicts do not occur.
/// The default template is suitable for almost all strategies that may be used
/// since it names files based on date with millisecond precision.
///
/// Output Format
/// =============
///
/// Since FileWriter is an instance of `OutputStreamWriter` it allows you to specify
/// the format of the output with any instance of OutputStreamFormatter.  The default
/// format is `TextFormat` with the default TextFormat options.  You can easily change
/// the format by overriding the default on creation.
/// ```
///     let fileWriter = try FileWriter(directory: URL(fileURLWithPath: "./"), format: JSONFormat())
///
///     TraceLog.configure(writers: [fileWriter])
/// ```
///
/// - SeeAlso: `FileStrategy` for complete details of all strategies that can be used.
///
public class FileWriter: OutputStreamWriter {

    /// OutputStreamFormatter being used for formating output.
    ///
    public let format: OutputStreamFormatter

    /// Default constructor for this writer.
    ///
    /// - Parameters:
    ///     - directory: A URL that points to the directory where the FileWriter should write the log files.
    ///     - strategy: The FileStrategy to use for managing file on the storage device.
    ///     - format: An instance of an OutputStreamFormatter used to format the output before writing to the file.
    ///
    public init(directory: URL, strategy: Strategy = Default.strategy, format: OutputStreamFormatter = Default.format) throws {
        self.format = format

        /// Ensure we have a directory URL so that relative paths are resolved correctly.
        ///
        let directory = URL(fileURLWithPath: directory.path, isDirectory: true)

        /// Create the directory if required.
        try createDirectory(url: directory)

        switch strategy {
        case ._fixed(let fileName):
            self.fileManager = try FileStrategyFixed(directory:  directory, fileName: fileName)
        case ._rotate(let options, let template):
            self.fileManager = try FileStrategyRotate(directory: directory, template: template, options: options)
        }
    }

    /// Required write function for the logger
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        let result = format.bytes(from: entry)

        guard case .success(let bytes) = result
            else { return result.map({ (_) in 0 }).mapError({ .error($0) })  }

        /// Write message to log
        ///
        return self.fileManager.write(bytes)
    }

    internal /* @testable */
    var currentFileURL: URL {
        return self.fileManager.url
    }

    /// The currently open log file handle and configuration.
    ///
    private var fileManager: FileStrategyManager

}

extension FileWriter {

    /// Defaults for init values
    ///
    public enum Default {

        /// The default strategy for the FileWriter.
        ///
        /// Value:
        ///
        ///     FileWriter.Strategy.fixed(fileName: "trace.log")
        ///
        public static let strategy: Strategy = .fixed(fileName: "trace.log")

        /// Default format.
        ///
        /// Value:
        ///
        ///     TextFormat()
        ///
        public static let format: OutputStreamFormatter = TextFormat()
    }
}

private func createDirectory(url: URL) throws {
    do {
        try Foundation.FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        throw FileOutputStreamError.invalidURL(error.localizedDescription)
    }
}
