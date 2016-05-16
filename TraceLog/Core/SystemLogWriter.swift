/**
 *   SytemLogWriter.swift
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
 *   Created by Tony Stone on 4/27/16.
 */
import Foundation

public class SytemLogWriter : Writer {
    
    let dateFormatter: NSDateFormatter = {
        
        var formatter = NSDateFormatter()
        //2016-04-23 10:34:26.849 Fields[39068:5120468]
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        
        return formatter
    }()
    
    public init() {}
    
    public func log(timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {
        let date = NSDate(timeIntervalSinceReferenceDate: timestamp)
        
        let message = String(format: "%@ \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] %7@: <%@> %@", dateFormatter.stringFromDate(date), "\(level)", tag, message)
        
        //        log_client = asl_open("LogIt", "The LogIt Facility", ASL_OPT_STDERR)
        //asl_log(log_client, NULL, ASL_LEVEL_EMERG, message)
        //asl_close(log_client)
    }
}