/**
 *   Logger.swift
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
 *   Created by Tony Stone on 4/22/16.
 */
import Swift
import Foundation

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
            var threadID: UInt64 = 0
            
            pthread_threadid_np(pthread_self(), &threadID)
            self.processName = process.processName
            self.processIdentifier = Int(process.processIdentifier)
            self.threadIdentifier = threadID
        }
    }
    
    ///
    /// A concrete class that Implements the StaticContext interface
    ///
    internal class StaticContextImpl : StaticContext {
        internal let file: String
        internal let function: String
        internal let lineNumber: UInt
        internal let column: UInt
        
        internal init(file: String, function: String, lineNumber: UInt, column: UInt) {
            self.file       = file
            self.function   = function
            self.lineNumber = lineNumber
            self.column     = column
        }
    }
    
    fileprivate static let queue = RecursiveSerialQueue(name: "tracelog.write.queue")
    
    fileprivate static let config  = { () -> Configuration in
        
        let configuration = Configuration()
        
        configuration.load([ConsoleWriter()], environment: Environment())
        
        return configuration
    }()
    
    ///
    /// Initializes the logging system with the specified writers and environement
    ///
    ///  Note: this is an optional call
    ///
    class func intialize(_ writers: [Writer] = [ConsoleWriter()], environment: Environment = Environment()) {
        
        queue.performBlockAndWait {
            
            let errors = config.load(writers, environment: environment)
            
            for error in errors {
                logPrimitive(.info, tag: ModuleLogName, file: #file, function: #function, lineNumber: #line) {
                    "\(error)"
                }
            }
        }
    }
    
    ///
    /// Low level logging function for Swift calls
    ///
    class func logPrimitive(_ level: LogLevel, tag: String, file: String, function: String, lineNumber: UInt, message: () -> String) {

        // Capture the context outside the dispatch queue
        let runtimeContext = RuntimeContextImpl()
        let staticContext  = StaticContextImpl(file: file, function: function, lineNumber: lineNumber, column: 0)
        
        queue.performBlockAndWait {
            
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

///
/// Internal class exposed to objective-C for low level loggin
///
@objc(TLLogger)
open class TLLogger : NSObject {
    
    ///
    /// Low level logging function for ObjC calls
    ///
    open class func logPrimitive(_ level: Int, tag: String, file: String, function: String, lineNumber: UInt, message: () -> String) {
        assert(LogLevel.rawRange.contains(level), "Invalid log level, values must be in the the range \(LogLevel.rawRange)")
        
        Logger.logPrimitive(LogLevel(rawValue: level)!, tag: tag, file: file, function: function, lineNumber: lineNumber, message: message)
    }
}










