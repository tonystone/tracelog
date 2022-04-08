///
///  DarwinPlatformValidator.swift
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
///  Created by Tony Stone on 6/16/18.
///
import XCTest
@testable import TraceLog

#if os(macOS)

import os.log


@available(iOS 10.0, macOS 10.13, watchOS 3.0, tvOS 10.0, *)
class UnifiedLogReader: Reader {

    func logEntry(for writer: UnifiedLogWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> TestLogEntry? {

       let osLogType = OSLogType(rawValue: UInt8(writer.platformLogLevel(for: level)))

       /// If Unified Logging is not configured for this test, we fail early.
       let log = OSLog(subsystem: writer.subsystem, category: tag)

       guard log.isEnabled(type: osLogType)
               else {

                   XCTFail("\n\nCannot complete log entry search.\n\n" +
                           "\tUnified Logging is not configured for this LogLevel.\n\n" +
                           "\tPlease run `sudo log config --subsystem \"\(writer.subsystem)\" --mode \"persist:debug\"` before running this test.\n")
                   return nil
       }

       let command = "log show --predicate 'eventMessage == \"\(message)\"' --info --debug --style json"

        ///
        /// Note: Unified takes an undetermined time before log entries are available to
        /// the log command so we try up to 10 times to find the value before giving up.
        ///
        var retryTime: useconds_t = 1000

        for _ in 0...10 {

            guard let data = try? shell(command + " --last \(retryTime / 1000)")
                else { XCTFail("Could not run shell command \(command + " --last \(retryTime / 1000)")."); return nil }

            let objects: Any
            do {
                objects = try JSONSerialization.jsonObject(with: data)
            } catch {
               XCTFail("Could not parse JSON \(String(data: data, encoding: .utf8) ?? "nil"), error: \(error)."); return nil
            }

            guard let logEntries = objects as? [[String: Any]]
                else {
                    XCTFail("Incorrect json object returned from parsing log show results, expected [[String: Any]] but got \(type(of: objects))."); return nil
            }

            guard logEntries.count > 0
                else {
                    usleep(retryTime)
                    retryTime = retryTime * 2   /// progressivly sleep longer for each retry.

                    continue
                }

            /// Find the journal entry by message string (message string should be unique based on the string + timestamp).
            for jsonEntry in logEntries where jsonEntry["eventMessage"] as? String ?? "" == message {

                var customAttributes: [String:  Any]? = nil

                if let subsystem = jsonEntry["subsystem"] as? String {
                    customAttributes = ["subsystem": subsystem]
                }

                return TestLogEntry(timestamp: timestamp,
                                level: level,
                                message: message,  // Note we return the input message because we know it matches because we searched by message
                                tag: jsonEntry["category"] as? String,
                                customAttributes: customAttributes)
                // assertValue(for: jsonEntry, key: "messageType", eqauls: "\(osLogType.description)")
            }
        }
        return nil
    }
}

@available(iOS 10.0, macOS 10.13, watchOS 3.0, tvOS 10.0, *)
extension OSLogType {

    public var description: String {
        switch self {
        case .fault: return "Fault"
        case .error: return "Error"
        case .debug: return "Debug"
        default:     return "Default"
        }
    }
}


@available(iOS 10.0, macOS 10.13, watchOS 3.0, tvOS 10.0, *)
class DarwinPlatformValidator {

    static var `default`: Platform.LogLevel { return Platform.LogLevel(OSLogType.default.rawValue) }
    static var error:     Platform.LogLevel { return Platform.LogLevel(OSLogType.error.rawValue) }
    static var warning:   Platform.LogLevel { return Platform.LogLevel(OSLogType.default.rawValue) }
    static var info:      Platform.LogLevel { return Platform.LogLevel(OSLogType.default.rawValue) }
    static var trace1:    Platform.LogLevel { return Platform.LogLevel(OSLogType.debug.rawValue) }
    static var trace2:    Platform.LogLevel { return Platform.LogLevel(OSLogType.debug.rawValue) }
    static var trace3:    Platform.LogLevel { return Platform.LogLevel(OSLogType.debug.rawValue) }
    static var trace4:    Platform.LogLevel { return Platform.LogLevel(OSLogType.debug.rawValue) }
}

#endif
