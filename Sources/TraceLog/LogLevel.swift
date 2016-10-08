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
/// LogLevels
///
public enum LogLevel : Int {
    case off     = 0
    case error   = 1
    case warning = 2
    case info    = 3
    case trace1  = 4
    case trace2  = 5
    case trace3  = 6
    case trace4  = 7
    
    ///
    /// Note: Update below if you add another case statement to this enum
    ///
    /// I don't like this either but it's the only sane way to be able
    /// to loop through all the elemenets for lookup. It's kept
    /// here so you remember to update it should a new case
    /// statement be added above.
    ///
    static let allValues: [LogLevel]  = [.off,  .error,  .warning,  .info,  .trace1,  .trace2,  .trace3, .trace4]
}

/// Extend the LogLevel with the ability to compare them
extension LogLevel : Comparable {}

public func <(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

public func ==(lhs: LogLevel, rhs: LogLevel) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

internal extension LogLevel {
    static var rawRange:       ClosedRange<Int> { get { return LogLevel.off.rawValue...LogLevel.trace4.rawValue } }
    static var rawTraceLevels: ClosedRange<Int> { get { return 1...4 } }
}

internal extension String {
    
    func asLogLevel () -> LogLevel? {
        
        let lowercasedSelf = self.lowercased()
        
        for level in LogLevel.allValues {
            
            if lowercasedSelf == String(describing: level) {
                    return level
            }
        }
        return nil
    }
}
