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
        internal let lineNumber: Int
        
        internal init(file: String, function: String, lineNumber: Int) {
            self.file       = file
            self.function   = function
            self.lineNumber = lineNumber
        }
    }
    
    ///
    /// Serilialization queue for init and writing 
    ///
    fileprivate static let queue = DispatchQueue(label: "tracelog.write.queue")
    
    ///
    /// Initialize the config with the default configuration
    /// read from the environment first.  The user can re-init
    /// this at a later time or simply use the default.
    ///
    fileprivate static let config = Configuration()
    
    ///
    /// Initializes the logging system with the specified writers and environement
    ///
    ///  Note: this is an optional call
    ///
    class func intialize(_ writers: [Writer] = [ConsoleWriter()], environment: Environment = Environment()) {
        
        ///
        /// Note: we use a syncrhonouse call here for the initialization, all
        ///       other calls must be async in order not to conflict with this one.
        ///
        queue.sync {
        
            let errors = config.load(writers, environment: environment)

            logPrimitive(.info, tag: ModuleLogName, file: #file, function: #function, lineNumber: #line) {
                "\(ModuleLogName) initialized with configuration: \(config.description)"
            }
            
            for error in errors {
                
                logPrimitive(.warning, tag: ModuleLogName, file: #file, function: #function, lineNumber: #line) {
                    "\(error)"
                }
            }
        }
    }
    
    ///
    /// Low level logging function for Swift calls
    ///
    class func logPrimitive(_ level: LogLevel, tag: String, file: String, function: String, lineNumber: Int, message: @escaping () -> String) {

        // Capture the context outside the dispatch queue
        let runtimeContext = RuntimeContextImpl()
        let staticContext  = StaticContextImpl(file: file, function: function, lineNumber: lineNumber)
        
        ///
        /// All logPrimative calls are asynchronous
        ///
        queue.async {
            
            if config.logLevel(for: tag) >= level {
                let timestamp = Date.timeIntervalSinceReferenceDate
                
                // Evaluate the message now
                let messageString = message()

                for writer in config.logWriters {
                    writer.log(timestamp, level: level, tag: tag, message: messageString, runtimeContext: runtimeContext, staticContext: staticContext)
                }
            }
        }
    }
}


#if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)
    
    ///
    /// Internal class exposed to objective-C for low level logging
    ///
    @objc(TLLogger)
    open class TLLogger : NSObject {
        
        ///
        /// Low level logging function for ObjC calls
        ///
        open class func logPrimitive(_ level: Int, tag: String, file: String, function: String, lineNumber: Int, message: @escaping () -> String) {
            assert(LogLevel.rawRange.contains(level), "Invalid log level, values must be in the the range \(LogLevel.rawRange)")
            
            Logger.logPrimitive(LogLevel(rawValue: level)!, tag: tag, file: file, function: function, lineNumber: lineNumber, message: message)
        }
    }
    
#endif







