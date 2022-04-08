
///
///  UnifiedLogWriter.swift
///
///  Copyright 2022 Tony Stone
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
///  Created by Tony Stone on 4/8/22.
///
///
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)

import Foundation
import Swift
import os.log

public struct Platform {
    ///
    /// The LogLevel type for all Platforms.
    ///
    public typealias LogLevel = Int32
}

///
/// Apple Unified Logging System log writer for TraceLog.
///
/// Implementation of a TraceLog `Writer` to write to Apple's Unified Logging System.
///
/// - SeeAlso: https://developer.apple.com/documentation/os/logging
///
@available(iOS 10.0, macOS 10.12, watchOS 3.0, tvOS 10.0, *)
public class UnifiedLogWriter: Writer {

    ///
    /// The default LogLevel Conversion Table.
    ///
    public static let defaultLogLevelConversion: [TraceLog.LogLevel: Platform.LogLevel] = [
        .error:   Platform.LogLevel(OSLogType.error.rawValue),
        .warning: Platform.LogLevel(OSLogType.default.rawValue),
        .info:    Platform.LogLevel(OSLogType.default.rawValue),
        .trace1:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace2:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace3:  Platform.LogLevel(OSLogType.debug.rawValue),
        .trace4:  Platform.LogLevel(OSLogType.debug.rawValue)
    ]

    ///
    /// Custom subsystem passed to os_log
    ///
    internal let subsystem: String

    ///
    /// A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    private let logLevelConversion: [LogLevel: Platform.LogLevel]

    ///
    /// Initializes an UnifiedLoggingWriter.
    ///
    /// - Parameters:
    ///     - sybsystem: An identifier string, usually in reverse DNS notation, representing the subsystem that’s performing logging (defaults to current process name).
    ///     - logLevelConversion: A dictionary keyed by TraceLog LogLevels with the value to convert to the os_log level.
    ///
    public init(subsystem: String? = nil, logLevelConversion: [TraceLog.LogLevel: Platform.LogLevel] = defaultLogLevelConversion) {
        self.subsystem          = subsystem ?? ProcessInfo.processInfo.processName
        self.logLevelConversion = logLevelConversion
    }

    ///
    /// Required log function for the `Writer`.
    ///
    @inline(__always)
    public func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {

        let log = OSLog(subsystem: self.subsystem, category: entry.tag)

        os_log("%{public}@", log: log, type: OSLogType(UInt8(platformLogLevel(for: entry.level))), entry.message)

        return .success(entry.message.count)
    }

    ///
    /// Converts TraceLog level to os_log.
    ///
    @inline(__always)
    func platformLogLevel(for level: LogLevel) -> Platform.LogLevel {

        guard let level = self.logLevelConversion[level]
            else { return Platform.LogLevel(OSLogType.default.rawValue) }

        return level
    }
}

#endif
