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
import Foundation

/**
    TraceLog is a runtime configurable debug logging system.  It allows flexible
    configuration via environment variables at run time which allows each developer
    to configure log output per session based on the debugging needs of that session.

    When compiled in a RELEASE build, TraceLog is compiled out and has no overhead at
    all in the application.

    Log output can be configured globally using the LOG_ALL environment variable,
    by CLASS name using the LOG_CLASS_<CLASSNAME> environment variable pattern,
    and/or by a CLASS group by using the CLASS_PREFIX_<CLASSPREFIX> environment
    variable pattern.

    Each environment variable set is set with a level as the value.  The following
    levels are available in order of display priority.  Each level encompasses the
    level below it with TRACE4 including the output from every level.  The lowest
    level setting, aside from no output or OFF, is ERROR which only output errors when
    they occur.

    Levels:

            TRACE4
            TRACE3
            TRACE2
            TRACE1
            INFO
            WARNING
            ERROR
            OFF

    Environment Variables and syntax:

            LOG_CLASS_<CLASSNAME>=<LEVEL>
            LOG_PREFIX_<CLASSPREFIX>=<LEVEL>
            LOG_ALL=<LEVEL>


    Multiple Environment variables can be set at one time to get the desired level
    of visibility into the workings of the app.  Here are some examples.

    Suppose you wanted the first level of TRACE logging for the ClimateSecurity module
    which has a class prefix of CS and you wanted to see only errors and warnings for
    the rest of the application.  You would set the following:

            LOG_ALL=WARNING
            LOG_PREFIX_CS=TRACE1

    More specific settings override less specific so in the above example the less specific
    setting is LOG_ALL which is set to WARNING.  The class prefix is specifying a particular
    collection of classes that start with the string CS so this is more specific and overrides
    the LOG_ALL.  If you chose to name a specific class, that would override the prefix settings.

    For instance, in the example above, if we decided for one class in the ClimateSecurity module
    we needed more output, we could set the following

            LOG_ALL=WARNING
            LOG_PREFIX_CS=TRACE1
            LOG_CLASS_CSManager=TRACE4

    This outputs the same as the previous example with the exception of the CSManager class
    which is set to TRACE4 instead of using the less specific TRACE1 setting in LOG_PREFIX.

*/

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
public func logError(tag: String? = nil, _ file: StaticString = __FILE__, _ function: StaticString = __FUNCTION__, _ line: UInt = __LINE__, message: () -> String) {
    #if !NDEBUG || TRACELOG_TRACE_ALWAYS_ON
        let derivedTag = derivedTagIfNil(file, tag: tag);
        
        TLogger.log(LogLevel.Error, tag: derivedTag, message: message(), file: file.stringValue, function: function.stringValue, lineNumber: UInt32(line));
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
public func logWarning(tag: String? = nil, _ file: StaticString = __FILE__, _ function: StaticString = __FUNCTION__, _ line: UInt = __LINE__, message: () -> String) {
    #if !NDEBUG || TRACELOG_TRACE_ALWAYS_ON
        let derivedTag = derivedTagIfNil(file, tag: tag);
        
        TLogger.log(LogLevel.Warning, tag: derivedTag, message: message(), file: file.stringValue, function: function.stringValue, lineNumber: UInt32(line));
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
public func logInfo(tag: String? = nil, _ file: StaticString = __FILE__, _ function: StaticString = __FUNCTION__, _ line: UInt = __LINE__, message: () -> String) {
    #if !NDEBUG || TRACELOG_TRACE_ALWAYS_ON
        let derivedTag = derivedTagIfNil(file, tag: tag);
        
        TLogger.log(LogLevel.Info, tag: derivedTag, message: message(), file: file.stringValue, function: function.stringValue, lineNumber: UInt32(line));
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
public func logTrace(tag: String? = nil, level: Int = LogLevel.rawTraceLevels.start, _ file: StaticString = __FILE__, _ function: StaticString = __FUNCTION__, _ line: UInt = __LINE__, message: () -> String) {
    #if !NDEBUG || TRACELOG_TRACE_ALWAYS_ON
        assert(LogLevel.rawTraceLevels.contains(level), "Trace levels are in the range of \(LogLevel.rawTraceLevels)");
        
        let derivedTag = derivedTagIfNil(file, tag: tag);
        
        TLogger.log(LogLevel(rawValue: LogLevel.Trace1.rawValue + level - 1)!, tag: derivedTag, message: message(), file: file.stringValue, function: function.stringValue, lineNumber: UInt32(line));
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
public func logTrace(level: Int, _ file: StaticString = __FILE__, _ function: StaticString = __FUNCTION__, _ line: UInt = __LINE__, message: () -> String) {
    #if !NDEBUG || TRACELOG_TRACE_ALWAYS_ON
        assert(LogLevel.rawTraceLevels.contains(level), "Trace levels are in the range of \(LogLevel.rawTraceLevels)");
        
        let derivedTag = derivedTagIfNil(file, tag: nil);
        
        TLogger.log(LogLevel(rawValue: LogLevel.Trace1.rawValue + level - 1)!, tag: derivedTag, message: message(), file: file.stringValue, function: function.stringValue, lineNumber: UInt32(line));
    #endif
}


// MARK: Internal Private functions & Extensions.

private extension LogLevel {
    static var rawRange:       ClosedInterval<Int> { get { return LogLevel.Off.rawValue...LogLevel.Trace4.rawValue } }
    static var rawTraceLevels: ClosedInterval<Int> { get { return 1...4 } }
}

private extension String{
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