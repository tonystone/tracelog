///
///  TraceLog.swift
///
///  Copyright 2016 Tony Stone
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
///  Created by Tony Stone on 11/1/16.
///
import Swift
import Foundation

///
/// The modes that TraceLog can run in.
///
public enum Mode {
    ///
    /// Asynchronous non-blocking mode.  A general mode used for most
    /// application which queues all messages before being evaluated or logged.
    /// This ensures minimal delays in application execution due to logging.
    ///
    case async
    ///
    /// Synchronous blocking mode.  Useful for scripting applications and other
    /// applications where it is required for the call not to return until the
    /// message is printed.
    ///
    case sync
}

///
/// Initializes TraceLog with an optional array of Writers and the Environment.
///
/// This call is optional but in order to read from the environment on start up,
/// this method must be called.
///
/// - Parameters:
///     - mode:        The concurrency `Mode` to run TraceLog in. Async is the default.
///     - writers:     An Array of objects that implement the Writer protocol used to process messages that are logged. Note the writers are called in the order they are in this array.
///     - environment: Either a Dictionary<String, String> or an Environment object that contains the key/value pairs of configuration variables for TraceLog.
///
/// - Example:
///
/// Start TraceLog in the default mode, with default writers.
/// ```
///     TraceLog.configure()
/// ```
///
/// Start TraceLog in the default mode, replacing the default writer with `MyWriter` reading the environment for log level settings.
/// ```
///     TraceLog.configure(writers: [MyWriter()])
/// ```
///
/// Start TraceLog in the default mode, replacing the default writer with `MyWriter` and setting log levels programmatically.
/// ```
///     TraceLog.configure(writers: [MyWriter()], environment: ["LOG_ALL": "TRACE4",
///                                                              "LOG_PREFIX_NS" : "ERROR",
///                                                              "LOG_TAG_TraceLog" : "TRACE4"])
/// ```
///
public func configure(mode: Mode = .async, writers: [Writer] = [ConsoleWriter()], environment: Environment = Environment()) {
    #if !TRACELOG_DISABLED
    Logger.configure(mode: mode, writers: writers, environment: environment)
    #endif
}

///
/// logError logs a message with LogLevel Error to the LogWriters
///
/// - Parameters:
///     - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
///     - message: An closure or trailing closure that evaluates to the String message to log.
///
/// Examples:
/// ```
///     logError {
///         "Error message"
///     }
///
///     logError("MyAppName") {
///         "Error message"
///     }
///
///     logError("MyAppName") {
///
///          /// You can create complex closures that ultimately
///          /// return the String that will be logged to the
///          /// log Writers.
///
///         return "Final message String"
///     }
/// ```
public func logError(_ tag: String? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line, message: @escaping () -> String) {
    #if !TRACELOG_DISABLED
        let derivedTag = derivedTagIfNil(file: file, tag: tag)

        Logger.logPrimitive(level: LogLevel.error, tag: derivedTag, file: file, function: function, line: line, message: message)
    #endif
}

///
/// logWarning logs a message with LogLevel Warning to the LogWriters
///
/// - Parameters:
///     - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
///     - message: An closure or trailing closure that evaluates to the String message to log.
///
/// Examples:
/// ```
///     logWarning {
///         "Warning message"
///     }
///
///     logWarning("MyAppName") {
///         "Warning message"
///     }
///
///     logWarning("MyAppName") {
///
///         // You can create complex closures that ultimately
///         // return the String that will be logged to the
///         // log Writers.
///
///         return "Final message String"
///     }
/// ```
public func logWarning(_ tag: String? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line, message:  @escaping () -> String) {
    #if !TRACELOG_DISABLED
        let derivedTag = derivedTagIfNil(file: file, tag: tag)

        Logger.logPrimitive(level: LogLevel.warning, tag: derivedTag, file: file, function: function, line: line, message: message)
    #endif
}

/// logInfo logs a message with LogLevel Info to the LogWriters
///
/// - Parameters:
///     - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
///     - message: An closure or trailing closure that evaluates to the String message to log.
///
/// Examples:
/// ```
///     logInfo {
///         "Info message"
///     }
///
///     logInfo("MyAppName") {
///         "Info message"
///     }
///
///     logInfo("MyAppName") {
///
///         // You can create complex closures that ultimately
///         // return the String that will be logged to the
///         // log Writers.
///
///         return "Final message String"
/// ```
///
public func logInfo(_ tag: String? = nil, _ file: String = #file, _ function: String = #function, _ line: Int = #line, message:  @escaping () -> String) {
    #if !TRACELOG_DISABLED
        let derivedTag = derivedTagIfNil(file: file, tag: tag)

        Logger.logPrimitive(level: LogLevel.info, tag: derivedTag, file: file, function: function, line: line, message: message)
    #endif
}

///
/// logTrace logs a message with LogLevel Trace to the LogWriters
///
/// - Parameters:
///     - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
///     - level    An integer representing the trace LogLevel (i.e. 1, 2, 3, and 4.)
///     - message: An closure or trailing closure that evaluates to the String message to log.
///
/// Examples:
/// ```
///     logTrace {
///         "Trace message"
///     }
///
///     logTrace("MyAppName") {
///         "Trace message"
///     }
///
///     logTrace("MyAppName", level: 3) {
///         "Trace message"
///     }
///
///     logTrace("MyAppName") {
///
///         // You can create complex closures that ultimately
///         // return the String that will be logged to the
///         // log Writers.
///
///         return "Final message String"
///     }
/// ```
///
public func logTrace(_ tag: String? = nil, level: Int = LogLevel.trace1.rawValue, _ file: String = #file, _ function: String = #function, _ line: Int = #line, message: @escaping () -> String) {
    #if !TRACELOG_DISABLED
        assert(LogLevel.validTraceLevels.contains(level), "Invalid trace level, levels are in the range of \(LogLevel.validTraceLevels)")

        let derivedTag = derivedTagIfNil(file: file, tag: tag)

        Logger.logPrimitive(level: LogLevel(rawValue: LogLevel.trace1.rawValue + level - 1)!, tag: derivedTag, file: file, function: function, line: line, message: message)    // swiftlint:disable:this force_unwrapping
    #endif
}

///
/// logTrace logs a message with LogLevel Trace to the LogWriters.
///
/// - Parameters:
///     - level    An integer representing the trace LogLevel (i.e. 1, 2, 3, and 4.)
///     - message: An closure or trailing closure that evaluates to the String message to log.
///
/// Examples:
/// ```
///     logTrace(1) {
///         "Trace message"
///     }
///
///     logTrace(2) {
///         "Trace message"
///     }
///
///     logTrace(3) {
///         "Trace message"
///     }
///
///     logTrace(4) {
///
///         // You can create complex closures that ultimately
///         // return the String that will be logged to the
///         // log Writers.
///
///         return "Final message String"
///     }
/// ```
///
public func logTrace(_ level: Int, _ file: String = #file, _ function: String = #function, _ line: Int = #line, message: @escaping () -> String) {
    #if !TRACELOG_DISABLED
        assert(LogLevel.validTraceLevels.contains(level), "Trace levels are in the range of \(LogLevel.validTraceLevels)")

        let derivedTag = derivedTagIfNil(file: file, tag: nil)

        Logger.logPrimitive(level: LogLevel(rawValue: LogLevel.trace1.rawValue + level - 1)!, tag: derivedTag, file: file, function: function, line: line, message: message) // swiftlint:disable:this force_unwrapping
    #endif
}

/// MARK: Internal & private functions & Extensions.

@inline(__always)
private func derivedTagIfNil(file: String, tag: String?) -> String {
    if let unwrappedTag = tag {
       return unwrappedTag
    } else {
        return URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent
    }
}
