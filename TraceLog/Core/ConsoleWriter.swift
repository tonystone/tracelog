/**
 *   ConsoleWriter.swift
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
import Foundation

public class ConsoleWriter : Writer {
    
    ///
    /// Default constructor for this writer
    ///
    public init() {}
    
    ///
    /// Required log function for the logger
    ///
    open func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        let date    = Date(timeIntervalSinceReferenceDate: timestamp)
        let message = String(format: "%@ \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] %7@: <%@> %@", self.dateFormatter.string(from: date), "\(level)", tag, message)
        
        synchronize {
            print(message)
        }
    }
    
    ///
    /// Synchronize the block pased on the main thread
    /// using the main thread directly if already on it.
    ///
    private func synchronize (_ block: () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.sync(execute: block)
        }
    }
    
    ///
    /// Internal date formattor for this logger
    ///
    private let dateFormatter: DateFormatter = {
        
        var formatter = DateFormatter()
        
        //2016-04-23 10:34:26.849 Fields[39068:5120468]
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return formatter
    }()
}
