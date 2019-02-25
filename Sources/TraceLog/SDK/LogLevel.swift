///
///  LogLevel.swift
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
///  Created by Tony Stone on 4/23/16.
///
import Swift

///
/// LogLevels represent the logging level defined by TraceLog.  These parallel the
/// environment variables that can be set to configure TraceLog.
///
public enum LogLevel: Int, CaseIterable {

    /// Used to turn logging completely off for the selected level (global, prefix, tag).
    case off     = 0

    /// Represents the lowest level of logging and is used to log errors that happen in the system.
    case error   = 1

    /// Represents a warning in the system.
    case warning = 2

    /// An informational message for the user.  Note, this is the most common level used.
    case info    = 3

    /// The first level of low level tracing and debug logging.  Use this level for deeper information about the operation of a particular function.
    case trace1  = 4

    /// The second level of low level tracing and debug logging.
    case trace2  = 5

    /// The third level of low level tracing and debug logging.
    case trace3  = 6

    /// The forth level of low level tracing and debug logging. Use this level to get complete logging information.  This level includes all logging in the system.
    case trace4  = 7
}

/// Extend the LogLevel with the ability to compare them
extension LogLevel: Comparable {}

/// Returns true if lhs LogLevel is less than to rhs LogLevel
public func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

/// Returns true if lhs LogLevel is equal to rhs LogLevel
public func == (lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

internal extension LogLevel {

    ///
    /// Note: validLoggableRange is used to limit the values that can be passed to through from Objective-c when making a log primitive call.
    ///       The values in this range should only be the LogLevel's that represent a log call.  OFF should not be part of this range because
    ///       there is no LogOff call.
    ///
    static var validLoggableRange: ClosedRange<Int> { return LogLevel.error.rawValue...LogLevel.trace4.rawValue }

    ///
    /// Used to validate the trace levels that are used in Objective-c
    ///
    static var validTraceLevels:  ClosedRange<Int> { return 1...4 }
}

internal extension String {

    func asLogLevel () -> LogLevel? {

        let lowercasedSelf = self.lowercased()

        for level in LogLevel.allCases {

            if lowercasedSelf == String(describing: level) {
                    return level
            }
        }
        return nil
    }
}
