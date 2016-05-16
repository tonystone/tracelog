/**
 *   LogLevel.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 4/23/16.
 */
import Swift

private let logLevelStrings = [
    "OFF",
    "ERROR",
    "WARNING",
    "INFO",
    "TRACE1",
    "TRACE2",
    "TRACE3",
    "TRACE4"
]

@objc public enum LogLevel : Int, Comparable {
    case Off     = 0
    case Error   = 1
    case Warning = 2
    case Info    = 3
    case Trace1  = 4
    case Trace2  = 5
    case Trace3  = 6
    case Trace4  = 7
}

public func <(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func ==(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

internal extension LogLevel {
    static var rawRange:       ClosedInterval<Int> { get { return LogLevel.Off.rawValue...LogLevel.Trace4.rawValue } }
    static var rawTraceLevels: ClosedInterval<Int> { get { return 1...4 } }
}

// Note: Objective-c type enum currently do not print their value
///      so this is required for display of the levels.
extension LogLevel: CustomStringConvertible {
    
    public var description: String {
        return logLevelStrings[self.rawValue]
    }
}

internal extension String {
    
    func asLogLevel () -> LogLevel? {
        
        for rawLevel in LogLevel.Off.rawValue...LogLevel.Trace4.rawValue {
            if let level = LogLevel(rawValue: rawLevel) {
            
                if self == level.description {
                    return level
                }
            }
        }
        return nil
    }
}
