///
///  TraceLog.swift
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
///  Created by Tony Stone on 11/1/16.
///
import Swift
import Foundation

internal let ModuleLogName  = "TraceLog"

public func initialize() {
    #if !TRACELOG_DISABLED
        Logger.intialize()
    #endif
}

public func initialize(logWriters writers: [Writer]) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        Logger.intialize(writers, environment: Environment())
    #endif
}

public func initialize<T : Collection>(environment: T) where T.Iterator.Element == (key: String, value: String)  {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        Logger.intialize([ConsoleWriter()], environment: Environment(environment))
    #endif
}

public func initialize<T : Collection>(logWriters writers: [Writer], environment: T) where T.Iterator.Element == (key: String, value: String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        Logger.intialize(writers, environment: Environment(environment))
    #endif
}

// MARK: Public Interface

/**
    
    logError logs a message with LogLevel Error to the LogWriters

    - Parameters:
        - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
        - message: An closure or trailing closure that evailuates to the String message to log.

    Examples:
    ```
        logError {
            "Error message"
        }

        logError("MyAppName") {
            "Error message"
        }
 
        logError("MyAppName") {
            
            // You can create complex closures that ultimately
            // return the String that will be logged to the
            // log Writers.
 
            return "Final message String"
        }
    ```
*/
public func logError(_ tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: @escaping () -> String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        let derivedTag = derivedTagIfNil(file: file, tag: tag)
        
        Logger.logPrimitive(LogLevel.error, tag: derivedTag, file: String(describing: file), function: String(describing: function), lineNumber: line, message: message)
    #endif
}


/**
    
    logWarning logs a message with LogLevel Warning to the LogWriters

    - Parameters:
        - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
        - message: An closure or trailing closure that evailuates to the String message to log.

    Examples:
    ```
        logWarning {
            "Warning message"
        }

        logWarning("MyAppName") {
            "Warning message"
        }
 
        logWarning("MyAppName") {
            
            // You can create complex closures that ultimately
            // return the String that will be logged to the
            // log Writers.
            
            return "Final message String"
        }
    ```
*/
public func logWarning(_ tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message:  @escaping () -> String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        let derivedTag = derivedTagIfNil(file: file, tag: tag)
        
        Logger.logPrimitive(LogLevel.warning, tag: derivedTag, file: String(describing: file), function: String(describing: function), lineNumber: line, message: message)
    #endif
}

/**
    
    logInfo logs a message with LogLevel Info to the LogWriters

    - Parameters:
        - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
        - message: An closure or trailing closure that evailuates to the String message to log.

    Examples:
    ```
        logInfo {
            "Info message"
        }

        logInfo("MyAppName") {
            "Info message"
        }
 
        logInfo("MyAppName") {
            
            // You can create complex closures that ultimately
            // return the String that will be logged to the
            // log Writers.
            
            return "Final message String"
    ```
*/
public func logInfo(_ tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message:  @escaping () -> String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        let derivedTag = derivedTagIfNil(file: file, tag: tag)
        
        Logger.logPrimitive(LogLevel.info, tag: derivedTag, file: String(describing: file), function: String(describing: function), lineNumber: line, message: message)
    #endif
}

/**
    
    logTrace logs a message with LogLevel Trace to the LogWriters

    - Parameters:
        - tag:     A String to use as a tag to group this call to other calls related to it. If not passed or nil, the file name is used as a tag.
        - level    An integer representing the trace LogLevel (i.e. 1, 2, 3, and 4.)
        - message: An closure or trailing closure that evailuates to the String message to log.

    Examples:
    ```
        logTrace {
            "Trace message"
        }

        logTrace("MyAppName") {
            "Trace message"
        }
 
        logTrace("MyAppName", level: 3) {
            "Trace message"
        }
 
        logTrace("MyAppName") {
            
            // You can create complex closures that ultimately
            // return the String that will be logged to the
            // log Writers.
            
            return "Final message String"
        }
    ```
*/
public func logTrace(_ tag: String? = nil, level: Int = LogLevel.rawTraceLevels.lowerBound, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: @escaping () -> String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        assert(LogLevel.rawTraceLevels.contains(level), "Invalid trace level, levels are in the range of \(LogLevel.rawTraceLevels)")
        
        let derivedTag = derivedTagIfNil(file: file, tag: tag)
        
        Logger.logPrimitive(LogLevel(rawValue: LogLevel.trace1.rawValue + level - 1)!, tag: derivedTag, file: String(describing: file), function: String(describing: function), lineNumber: line, message: message)
    #endif
}

/**
    
    logTrace logs a message with LogLevel Trace to the LogWriters.

    - Parameters:
        - level    An integer representing the trace LogLevel (i.e. 1, 2, 3, and 4.)
        - message: An closure or trailing closure that evailuates to the String message to log.

    Examples:
    ```
        logTrace(1) {
            "Trace message"
        }

        logTrace(2) {
            "Trace message"
        }
 
        logTrace(3) {
            "Trace message"
        }
 
        logTrace(4) {
            
            // You can create complex closures that ultimately
            // return the String that will be logged to the
            // log Writers.
            
            return "Final message String"
        }
    ```
*/
public func logTrace(_ level: Int, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: @escaping () -> String) {
    #if DEBUG || TRACELOG_ENABLE || os(Linux)
        assert(LogLevel.rawTraceLevels.contains(level), "Trace levels are in the range of \(LogLevel.rawTraceLevels)")
        
        let derivedTag = derivedTagIfNil(file: file, tag: nil)
        
        Logger.logPrimitive(LogLevel(rawValue: LogLevel.trace1.rawValue + level - 1)!, tag: derivedTag, file: String(describing: file), function: String(describing: function), lineNumber: line, message: message)
    #endif
}


// MARK: Internal & private functions & Extensions.

internal extension String {
    func lastPathComponent() -> String {
        return URL(fileURLWithPath: self).lastPathComponent
    }
    func stringByDeletingPathExtension() -> String {
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
}

private func derivedTagIfNil(file: StaticString, tag: String?) -> String {
    if let unwrappedTag = tag {
       return unwrappedTag
    } else {
        return String(describing: file).lastPathComponent().stringByDeletingPathExtension()
    }
}