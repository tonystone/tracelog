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
/// ### File Strategies
///
/// FileWriter allows various file management strategies to be configured and
/// used for management of the files on the storage device.  The default strategy
/// is the `.fixed` strategy which will create a fixed file that is continually
/// appended to and never rotated.  If you require a file rotation strategy
/// the `.rotate(at:)` strategy will allow you to set various rotation criteria
/// for the files created.
///
/// To rotate the file every time the the FIleWriter is started, you can pass the
/// `.startup` option to the rotate strategy as in this example.
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
/// ### Output Format
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
/// - SeeAlso: `FileWriter.Strategy` for complete details of all strategies that can be used.
///
@available(iOSApplicationExtension, unavailable, message: "FileWriter can not be initialized in an Extension.  Please initialize it in the main App.")
public class FileWriter: OutputStreamWriter {

    // MARK: Initialization

    /// Default constructor for this writer.
    ///
    /// - Parameters:
    ///     - directory: A URL that points to the directory where the FileWriter should write the log files.
    ///     - strategy: The `FileWriter.Strategy` to use for managing file on the storage device.
    ///     - format: An instance of an `OutputStreamFormatter` used to format the output before writing to the file.
    ///
    /// - SeeAlso: `FileWriter.Default` for default values to for this class.
    /// - SeeAlso: `FileWriter.Strategy` for strategies available to configure this writer.
    /// - SeeAlso: `OutputStreamFormatter` for more information about formatters that can be used.
    ///
    /// - Throws: An `Error` type should the init fail.
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

    // MARK: OutputStreamWriter conformance

    /// Required write function for the logger
    ///
    /// - SeeAlso: `Writer` for more information about the `write` function.
    /// - SeeAlso: 'Writer.LogEntry' for a complete definition of the loggable entry.
    /// - SeeAlso: `FailureReason` for failure return types.
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        let result = format.bytes(from: entry)

        guard case .success(let bytes) = result
            else { return result.map({ (_) in 0 }).mapError({ .error($0) })  }

        /// Write message to log
        ///
        return self.fileManager.write(bytes)
    }

    /// OutputStreamFormatter being used for formating output.
    ///
    /// - SeeAlso: `OutputStreamWriter` for more information about the protocol and the format field.
    ///
    public let format: OutputStreamFormatter

    // MARK: Private Data

    internal /* @testable */
    var currentFileURL: URL {
        return self.fileManager.url
    }

    /// The currently open log file handle and configuration.
    ///
    private var fileManager: FileStrategyManager
}

@available(iOSApplicationExtension, unavailable)
extension FileWriter {

    // MARK: Default Values

    /// Defaults for init values
    ///
    public enum Default {

        // MARK: Available Defaults

        /// The default strategy for the `FileWriter`.
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

    // MARK: Available Strategies

    /// A `Strategy` defines how `FileWriter` will manage file naming
    /// and physical file management.
    ///
    public enum Strategy {

        // MARK: Strategies

        /// Default file strategy which creates a fixed
        /// file and reuses the same file on every startup.
        ///
        /// - Parameter fileName: The file name to use for the
        ///             logging file.  The file name should be
        ///             the name + any extension you would like
        ///             to use but should not include the path
        ///             component. Default is "trace.log".
        ///
        /// - Note: There are no points of file rotation
        ///         with this option, TraceLog will continue
        ///         to append to the file name specified.
        ///
        /// - Note: On the iOS platform, this strategy will monitor protected data availability
        ///         and if you use the `ConcurrencyMode.async(options:)` mode with the
        ///         `AsyncConcurrencyModeOption.buffer(writeInterval:strategy:)` the FileWriter will
        ///         buffer when protected data is not available.
        ///
        /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
        ///           this will func will be changed to a case in the enum with default values.  We must
        ///           use a func now to work around the lack of defaults on enums.
        ///
        public static func fixed(fileName: String = "trace.log") -> Strategy {
            return ._fixed(fileName: fileName)
        }

        /// A strategy that includes rotation of the files
        /// at various points in time (E.g. at startup,
        /// a max file size, or a certain age of the file.)
        ///
        /// - Parameters:
        ///     - at: A set of `FileWriter.Strategy.RotationOption` values specifying
        ///           at what point to rotate the file that TraceLog
        ///           writes to.
        ///     - template: A Unicode String pattern to use to uniquely
        ///                 name new files. Internally TraceLog uses
        ///                 `DateFormatter` to format the log file names
        ///                 which means you can use any DateFormatter
        ///                 legal format.
        ///                 \
        ///                 To ensure unique files during rotation, you
        ///                 must specify a format that includes a date
        ///                 component that will produce a unique file name
        ///                 for the granularity of file rotation. For instance
        ///                 passing "'trace-'yyyyMMdd'.log'" would give you 1
        ///                 day of granularity meaning that only one log
        ///                 file can be produced per day.
        ///                 \
        ///                 Default is "'trace-'yyyyMMdd-HHmm-ss.SSSS'.log'".
        ///                 \
        ///                 The default template is suitable for any practical
        ///                 rotation granularity.
        ///
        /// - Remark: Once Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md) is implemented
        ///           this func will be changed to a case in the enum with default values.  We must
        ///           use a func now to work around the lack of defaults on enums.
        ///
        public static func rotate(at options: Set<RotationOption>, template: String = "'trace-'yyyyMMdd-HHmm-ss.SSSS'.log'") -> Strategy {
            return ._rotate(at: options, template: template)
        }

        // MARK: `Strategy.rotate(at:)` Options

        /// Options available for rotation strategy.
        ///
        public enum RotationOption {

            /// Rotate on startup of TraceLog
            ///
            case startup

            /// Rotate when the max file size reaches maxSize.
            ///
            case maxSize(UInt64)
        }

        /// :nodoc:
        /// - Warning: Internal, don't use directly. Use the versions with no underscore prefix
        ///            (`.fixed` and `.rotate`) instead. these cases will be removed at the end of the beta.
        ///
        /// - Remark: These are only here to allow us to have a beta and still provide the final
        ////          public interface with default parameters. We currently have no way of providing
        ///           default parameters to enum cases until Swift Evolution [SE-0155](https://github.com/apple/swift-evolution/blob/master/proposals/0155-normalize-enum-case-representation.md)
        ///           is implemented.
        ///
        case _fixed(fileName: String)
        /// :nodoc:
        case _rotate(at: Set<RotationOption>, template: String)
    }
}

/// :nodoc:
/// Internal extension to allow use of a Set<RotationOption>
/// to ensure we only get one instance of each.
///
@available(iOSApplicationExtension, unavailable)
extension FileWriter.Strategy.RotationOption: Hashable {

    /// :nodoc:
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .startup:     hasher.combine(1); return
        case .maxSize(_):  hasher.combine(2); return
        }
    }
}


private func createDirectory(url: URL) throws {
    do {
        try Foundation.FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    } catch {
        throw FileOutputStreamError.invalidURL(error.localizedDescription)
    }
}
