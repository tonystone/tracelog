///
///  Logger.swift
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
///  Created by Tony Stone on 4/22/16.
///
import Swift
import Foundation
import Dispatch
import DispatchIntrospection

#if os(Linux) || os(FreeBSD)
   import SwiftGlibc.POSIX.pthread
#endif

private let moduleLogName  = "TraceLog"

///
/// A class that it used to initialize the system and
/// log messages to the writers.
///
internal final class Logger {

    ///
    /// Initialize the config with the default configuration first.  The
    /// user can re-init this at a later time or simply use the default.
    ///
    fileprivate static var config = Configuration()

    ///
    /// Configure the logging system with the specified writers and environment
    ///
    class func configure(writers: [WriterConcurrencyMode], environment: Environment) {

        self.config = Configuration(writers: writers, environment: environment)

        logPrimitive(level: .info, tag: moduleLogName, file: #file, function: #function, line: #line) {
            "\(moduleLogName) Configured using: \(config.description)"
        }

        for error in self.config.errors {
            logPrimitive(level: .warning, tag: moduleLogName, file: #file, function: #function, line: #line) {
                "\(error.description)"
            }
        }
    }

    ///
    /// Low level logging function for Swift calls
    ///
    class func logPrimitive(level: LogLevel, tag: String, file: String, function: String, line: Int, message: @escaping () -> String) {
        ///
        /// Capture the timestamp as early as possible to
        /// get the most accurate time.
        ///
        let timestamp = Date().timeIntervalSince1970

        /// Copy the config pointer so it does not change while we are using it.
        let localConfig = self.config

        if localConfig.logLevel(for: tag) >= level {

            /// Evaluate the message and create the LogEntry now that we
            /// know we are going to output the message.
            ///
            let entry: Writer.LogEntry = (timestamp: timestamp, level: level, tag: tag, message: message(), runtimeContext: RuntimeContextImpl(), staticContext: StaticContextImpl(file: file, function: function, line: line))

            for writer in localConfig.writers {
                writer.write(entry)
            }
        }
    }
}

private extension Logger {

    ///
    /// A concrete class that Implements the RuntimeContext interface
    ///
    private class RuntimeContextImpl: RuntimeContext {

        internal let processName: String
        internal let processIdentifier: Int
        internal let threadIdentifier: UInt64

        internal init() {
            let process  = ProcessInfo.processInfo
            self.processName = process.processName
            self.processIdentifier = Int(process.processIdentifier)

            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                var threadID: UInt64 = 0

                pthread_threadid_np(pthread_self(), &threadID)
                self.threadIdentifier = threadID
            #else  // FIXME: Linux does not support the pthread_threadid_np function, syscall(SYS_gettid) must be used.
                self.threadIdentifier = 0
            #endif
        }
    }

    ///
    /// A concrete class that Implements the StaticContext interface
    ///
    private class StaticContextImpl: StaticContext {

        public let file: String
        public let function: String
        public let line: Int

        internal init(file: String, function: String, line: Int) {
            self.file       = file
            self.function   = function
            self.line       = line
        }
    }
}

#if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)

    /// Internal class exposed to objective-C for low level logging.
    ///
    /// - Warning:  This is a private class and nothing in this class should be used on it's own.  Please see TraceLog.h for the public interface to this.
    ///
    /// - Note: In order to continue to support Objective-C, this class must be public and also visible to both Swift and ObjC.  This class is not meant to be
    ///         used directly in either language.
    ///
    @objc(TLLogger)
    public class TLLogger: NSObject {

        @objc public static let LogLevelError   = LogLevel.error.rawValue
        @objc public static let LogLevelWarning = LogLevel.warning.rawValue
        @objc public static let LogLevelInfo    = LogLevel.info.rawValue
        @objc public static let LogLevelTrace1  = LogLevel.trace1.rawValue
        @objc public static let LogLevelTrace2  = LogLevel.trace2.rawValue
        @objc public static let LogLevelTrace3  = LogLevel.trace3.rawValue
        @objc public static let LogLevelTrace4  = LogLevel.trace4.rawValue

        ///
        /// Low level logging function for ObjC calls
        ///
        @objc
        public class func logPrimitive(_ level: Int, tag: String, file: String, function: String, line: Int, message: @escaping () -> String) {
            assert(LogLevel.validLoggableRange.contains(level), "Invalid log level, values must be in the the range \(LogLevel.validLoggableRange)")

            Logger.logPrimitive(level: LogLevel(rawValue: level)!, tag: tag, file: file, function: function, line: line, message: message)  // swiftlint:disable:this force_unwrapping
        }
    }

#endif
