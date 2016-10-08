///
///  ConsoleWriter.swift
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
import Foundation
import Dispatch

public class ConsoleWriter : Writer {
    
    ///
    /// Default constructor for this writer
    ///
    public init() {}
    
    ///
    /// Required log function for the logger
    ///
    open func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {

        let uppercasedLevel = "\(level)".uppercased()
        let levelString     = "\(String(repeating: " ", count: 7 - uppercasedLevel.characters.count))\(uppercasedLevel)"
        let date            = Date(timeIntervalSince1970: timestamp)
        let message         = String(format: "\(self.dateFormatter.string(from: date)) \(runtimeContext.processName)[\(runtimeContext.processIdentifier):\(runtimeContext.threadIdentifier)] \(levelString): <\(tag)> \(message)")
        
        ///
        /// Note: we currently use the calling thread to synchronize knowing that 
        ///       TraceLog calls us a serial queue.  This can cause interleaving
        ///       of other message in the output should other threads be used to 
        ///       print to the screen.
        ///
        print(message)
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
