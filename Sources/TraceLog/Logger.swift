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

fileprivate let moduleLogName  = "TraceLog"

///
/// A class that it used to initialize the system and 
/// log messages to the writers.
///
internal final class Logger {
    
    ///
    /// A concrete class that Implements the RuntimeContext interface
    ///
    internal class RuntimeContextImpl : RuntimeContext {
        internal let processName: String
        internal let processIdentifier: Int
        internal let threadIdentifier: UInt64
        
        internal init() {
            let process  = ProcessInfo.processInfo
            self.processName = process.processName
            self.processIdentifier = Int(process.processIdentifier)
            
            #if os(macOS)
                var threadID: UInt64 = 0
                
                pthread_threadid_np(pthread_self(), &threadID)
                self.threadIdentifier = threadID
            #else   // FIXME: Currently it does not seem like Linux supports the pthread_threadid_np method
                self.threadIdentifier = 0
            #endif
        }
    }
    
    ///
    /// A concrete class that Implements the StaticContext interface
    ///
    internal class StaticContextImpl : StaticContext {
        internal let file: String
        internal let function: String
        internal let line: Int
        
        internal init(file: String, function: String, line: Int) {
            self.file       = file
            self.function   = function
            self.line       = line
        }
    }
    
    ///
    /// Serialization queue for init and writing
    ///
    fileprivate static let queue = DispatchQueue(label: "tracelog.write.queue")
    
    ///
    /// Initialize the config with the default configuration
    /// read from the environment first.  The user can re-init
    /// this at a later time or simply use the default.
    ///
    fileprivate static let config = Configuration()
    
    ///
    /// Configure the logging system with the specified writers and environment
    ///
    class func configure(writers: [Writer]? = nil, environment: Environment? = nil) {
        
        ///
        /// Note: we use a synchronous call here for the configuration, all
        ///       other calls must be async in order not to conflict with this one.
        ///
        queue.sync {
        
            if let writers = writers {
                self.config.writers = writers
            }
            
            if let environment = environment {
                
                let errors = config.load(environment: environment)
                
                logPrimitive(level: .info, tag: moduleLogName, file: #file, function: #function, line: #line) {
                    "\(moduleLogName) Configured using: \(config.description)"
                }
                
                for error in errors {
                    
                    logPrimitive(level: .warning, tag: moduleLogName, file: #file, function: #function, line: #line) {
                        "\(error.description)"
                    }
                }
            }
        }
    }
    
    ///
    /// Low level logging function for Swift calls
    ///
    class func logPrimitive(level: LogLevel, tag: String, file: String, function: String, line: Int, message: @escaping () -> String) {

        // Capture the context outside the dispatch queue
        let runtimeContext = RuntimeContextImpl()
        let staticContext  = StaticContextImpl(file: file, function: function, line: line)
        
        ///
        /// All logPrimitive calls are asynchronous
        ///
        queue.async {
            
            if config.logLevel(for: tag) >= level {
                let timestamp = Date().timeIntervalSince1970
                
                // Evaluate the message now
                let messageString = message()

                for writer in config.writers {
                    writer.log(timestamp, level: level, tag: tag, message: messageString, runtimeContext: runtimeContext, staticContext: staticContext)
                }
            }
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
    public class TLLogger : NSObject {
        
        public static let LogLevelError   = LogLevel.error.rawValue
        public static let LogLevelWarning = LogLevel.warning.rawValue
        public static let LogLevelInfo    = LogLevel.info.rawValue
        public static let LogLevelTrace1  = LogLevel.trace1.rawValue
        public static let LogLevelTrace2  = LogLevel.trace2.rawValue
        public static let LogLevelTrace3  = LogLevel.trace3.rawValue
        public static let LogLevelTrace4  = LogLevel.trace4.rawValue
        
        public class func configure() {
            Logger.configure(writers: [ConsoleWriter()], environment: Environment())
        }
        
        public class func configure(environment: [String : String]) {
            Logger.configure(writers: [ConsoleWriter()], environment: Environment(environment))
        }
        
        ///
        /// Low level logging function for ObjC calls
        ///
        public class func logPrimitive(_ level: Int, tag: String, file: String, function: String, line: Int, message: @escaping () -> String) {
            assert(LogLevel.rawRange.contains(level), "Invalid log level, values must be in the the range \(LogLevel.rawRange)")
            
            Logger.logPrimitive(level: LogLevel(rawValue: level)!, tag: tag, file: file, function: function, line: line, message: message)
        }
    }
    
#endif







