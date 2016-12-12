/**
 *   TraceLog.h
 *
 *   Copyright 2015 The Climate Corporation
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
 *   Created by Tony Stone on 3/4/15.
 */
#ifndef Pods_TraceLog_h
#define Pods_TraceLog_h

/// Instance level macros

/**
 * LogError logs an message with LogLevel Error to the LogWriters
 *
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 *
 * Examples:
 * @code
 * {
 *      LogError(@"A string message");
 * }
 * @endcode
 * @code
 * {
 *      NSNumber * arg1 = @(100);
 *
 *      LogError(@"A format string message with format specifier %@", arg1);
 * }
 * @endcode
 */
#define LogError(format,...)       CLogError(NSStringFromClass([self class]), format, ##__VA_ARGS__)

/**
 * LogWarning logs an message with LogLevel Warning to the LogWriters
 *
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 *
 * Examples:
 * @code
 * {
 *      LogWarning(@"A string message");
 * }
 * @endcode
 * @code
 * {
 *      NSNumber * arg1 = @(100);
 *
 *      LogWarning(@"A format string message with format specifier %@", arg1);
 * }
 * @endcode
 */
#define LogWarning(format,...)     CLogWarning(NSStringFromClass([self class]), format, ##__VA_ARGS__)

/**
 * LogInfo logs an message with LogLevel Info to the LogWriters
 *
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 *
 * Examples:
 * @code
 * {
 *      LogInfo(@"A string message");
 * }
 * @endcode
 * @code
 * {
 *      NSNumber * arg1 = @(100);
 *
 *      LogInfo(@"A format string message with format specifier %@", arg1);
 * }
 * @endcode
 */
#define LogInfo(format,...)        CLogInfo(NSStringFromClass([self class]), format, ##__VA_ARGS__)

/**
 * LogTrace logs an message with LogLevel Trace to the LogWriters
 *
 * @param level An integer representing the trace LogLevel (i.e. TRACE1, TRACE2, TRACE3, and TRACE4.)
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 *
 * Examples:
 * @code
 * {
 *      LogTrace(1, @"A string message");
 * }
 * @endcode
 * @code
 * {
 *      NSNumber * arg1 = @(100);
 *
 *      LogTrace(4, @"A format string message with format specifier %@", arg1);
 * }
 * @endcode
 */
#define LogTrace(level,format,...) CLogTrace(level,NSStringFromClass([self class]), format, ##__VA_ARGS__)

/*
 WARNING:  LogIfEnabled is private and should not be used directly
 */
#if !TRACELOG_DISABLED
    #define LogIfEnabled(logLevel,tagName,format,...) [TLLogger logPrimitive: logLevel tag: tagName file: [NSString stringWithUTF8String: __FILE__] function: [NSString stringWithUTF8String: __FUNCTION__] line: __LINE__ message: ^{ return [NSString stringWithFormat: format, ##__VA_ARGS__]; }]
#else
    #define LogIfEnabled(logLevel,label, format, ...) ((void)0)
#endif

/// Low level - for use in mixed low level C code.
/**
 * CLogError logs an message with LogLevel Error to the LogWriters.
 *
 * @param tag    A string to use as a tag to group this call to other calls related to it. For instance, LogError(format,...) uses the NSStringFromClass([self class]) as a tag.
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 */
#define CLogError(tag,format,...) LogIfEnabled(TLLogger.LogLevelError, tag, format, ##__VA_ARGS__)

/**
 * CLogWarning logs an message with LogLevel Error to the LogWriters.
 *
 * @param tag    A string to use as a tag to group this call to other calls related to it. For instance, LogWarning(format,...) uses the NSStringFromClass([self class]) as a tag.
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 */
#define CLogWarning(tag,format,...) LogIfEnabled(TLLogger.LogLevelWarning, tag, format, ##__VA_ARGS__)

/**
 * CLogInfo logs an message with LogLevel Error to the LogWriters.
 *
 * @param tag    A string to use as a tag to group this call to other calls related to it. For instance, LogInfoformat,...) uses the NSStringFromClass([self class]) as a tag.
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 */
#define CLogInfo(tag,format,...) LogIfEnabled(TLLogger.LogLevelInfo, tag, format, ##__VA_ARGS__)

/**
 * CLogTrace logs an message with LogLevel Error to the LogWriters.
 *
 * @param level  An integer representing the trace LogLevel (i.e. TRACE1, TRACE2, TRACE3, and TRACE4.)
 * @param tag    A string to use as a tag to group this call to other calls related to it. For instance, LogInfoformat,...) uses the NSStringFromClass([self class]) as a tag.
 * @param format A format string. This value must not be nil.
 * @param ...    A comma-separated list of arguments to substitute into format.
 *
 * @Note Raises an NSInvalidArgumentException if format is nil.
 */
#define CLogTrace(level,tag,format,...) LogIfEnabled(TLLogger.LogLevelTrace1 + ((int)level) - 1, tag, format, ##__VA_ARGS__)

#endif
