///
///  TLLogger.swift
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
///  Created by Tony Stone on 10/2/16.
///
import Foundation


#if os(macOS) || os(tvOS) || os(watchOS) || os(iOS)

///
/// Internal class exposed to objective-C for low level logging
///
@objc(TLLogger)
open class TLLogger : NSObject {
    
    ///
    /// Low level logging function for ObjC calls
    ///
    open class func logPrimitive(_ level: Int, tag: String, file: String, function: String, lineNumber: UInt, message: @escaping () -> String) {
        assert(LogLevel.rawRange.contains(level), "Invalid log level, values must be in the the range \(LogLevel.rawRange)")
        
        Logger.logPrimitive(LogLevel(rawValue: level)!, tag: tag, file: file, function: function, lineNumber: lineNumber, message: message)
    }
}

#endif
