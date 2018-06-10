///
///  ConsoleWriter.swift
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
///  Created by Tony Stone on 5/25/18.
///

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation
import os.log

///
/// Apple Unified Logging System log writer for TraceLog.
///
/// Implementation of a TraceLog `Writer` to write to Apple's Unified Logging System.
///
/// - SeeAlso: https://developer.apple.com/documentation/os/logging
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
public class UnifiedLoggingWriter: Writer {

    ///
    /// The default LogLevel Conversion Table.
    ///
    public static let defaultLogLevelConversion: [LogLevel: OSLogType] = [
        .error:   OSLogType.error,
        .warning: OSLogType.default,
        .info:    OSLogType.default,
        .trace1:  OSLogType.debug,
        .trace2:  OSLogType.debug,
        .trace3:  OSLogType.debug,
        .trace4:  OSLogType.debug
    ]

    ///
    /// Custom subsystem passed to os_log
    ///
    private let sybsystem: String?

    ///
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    private let logLevelConversion: [LogLevel: OSLogType]

    ///
    /// Initializes an UnifiedLoggingWriter.
    ///
    /// - Parameters:
    ///     - sybsystem: An identifier string, usually in reverse DNS notation, representing the subsystem that’s performing logging (defaults to current process name).
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    public init(subsystem: String? = nil, logLevelConversion: [LogLevel: OSLogType] = UnifiedLoggingWriter.defaultLogLevelConversion) {
        self.sybsystem          = subsystem
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    public func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        let log = OSLog(subsystem: self.sybsystem ?? runtimeContext.processName, category: tag)

        os_log("%{public}@", log: log, type: convertLogLevel(for: level), message)
    }

    ///
    /// Converts TraceLog level to os_log.
    ///
    internal /* @testable */
    func convertLogLevel(for level: LogLevel) -> OSLogType {

        guard let level = logLevelConversion[level]
            else { return OSLogType.default }

        return level
    }
}
#endif
