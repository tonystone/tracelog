/**
 *   TraceLog.swift
 *
 *   Copyright 2015 Tony Stone
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
 *   Created by Tony Stone on 11/1/15.
 */
import Swift

public func initialize(logWriters writers: [Writer]) {
    #if DEBUG || TRACELOG_ENABLE
        Logger.intialize(writers, environment: Environment())
    #endif
}

public func initialize<T : CollectionType where T.Generator.Element == (String, String)>(environment environment: T) {
    #if DEBUG || TRACELOG_ENABLE
        Logger.intialize([ConsoleWriter()], environment: environment)
    #endif
}

public func initialize<T : CollectionType where T.Generator.Element == (String, String)>(logWriters writers: [Writer], environment environment: T) {
    #if DEBUG || TRACELOG_ENABLE
        Logger.intialize(writers, environment: environment)
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
public func logError(tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: () -> String) {
    #if DEBUG || TRACELOG_ENABLE
        let derivedTag = derivedTagIfNil(file, tag: tag)
        
        Logger.logPrimitive(LogLevel.Error, tag: derivedTag, file: file.stringValue, function: function.stringValue, lineNumber: line, message: message)
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
public func logWarning(tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: () -> String) {
    #if DEBUG || TRACELOG_ENABLE
        let derivedTag = derivedTagIfNil(file, tag: tag)
        
        Logger.logPrimitive(LogLevel.Warning, tag: derivedTag, file: file.stringValue, function: function.stringValue, lineNumber: line, message: message)
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
public func logInfo(tag: String? = nil, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: () -> String) {
    #if DEBUG || TRACELOG_ENABLE
        let derivedTag = derivedTagIfNil(file, tag: tag)
        
        Logger.logPrimitive(LogLevel.Info, tag: derivedTag, file: file.stringValue, function: function.stringValue, lineNumber: line, message: message)
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
public func logTrace(tag: String? = nil, level: Int = LogLevel.rawTraceLevels.start, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: () -> String) {
    #if DEBUG || TRACELOG_ENABLE
        assert(LogLevel.rawTraceLevels.contains(level), "Invalid trace level, levels are in the range of \(LogLevel.rawTraceLevels)")
        
        let derivedTag = derivedTagIfNil(file, tag: tag)
        
        Logger.logPrimitive(LogLevel(rawValue: LogLevel.Trace1.rawValue + level - 1)!, tag: derivedTag, file: file.stringValue, function: function.stringValue, lineNumber: line, message: message)
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
public func logTrace(level: Int, _ file: StaticString = #file, _ function: StaticString = #function, _ line: UInt = #line, message: () -> String) {
    #if DEBUG || TRACELOG_ENABLE
        assert(LogLevel.rawTraceLevels.contains(level), "Trace levels are in the range of \(LogLevel.rawTraceLevels)")
        
        let derivedTag = derivedTagIfNil(file, tag: nil)
        
        Logger.logPrimitive(LogLevel(rawValue: LogLevel.Trace1.rawValue + level - 1)!, tag: derivedTag, file: file.stringValue, function: function.stringValue, lineNumber: line, message: message)
    #endif
}


// MARK: Internal & private functions & Extensions.

internal extension String {
    func lastPathComponent() -> String {
        return (self as NSString).lastPathComponent
    }
    func stringByDeletingPathExtension() -> String {
        return (self as NSString).stringByDeletingPathExtension
    }
}

private func derivedTagIfNil(file: StaticString, tag: String?) -> String {
    if let unwrappedTag = tag {
       return unwrappedTag
    } else {
        return file.stringValue.lastPathComponent().stringByDeletingPathExtension()
    }
}