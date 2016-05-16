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
    
    let dateFormatter: NSDateFormatter = {
        
        var formatter = NSDateFormatter()
        //2016-04-23 10:34:26.849 Fields[39068:5120468]
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return formatter
    }()
    
    public init() {}
    
    public func log(timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        let date    = NSDate(timeIntervalSinceReferenceDate: timestamp)
        let message = String(format: "%@ \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] %7@: <%@> %@", self.dateFormatter.stringFromDate(date), "\(level)", tag, message)
        
        synchronize {
            print(message)
        }
    }
    
    private func synchronize (block: () -> Void) {
        if NSThread.isMainThread() {
            block()
        } else {
            dispatch_sync(dispatch_get_main_queue(), block)
        }
    }
}