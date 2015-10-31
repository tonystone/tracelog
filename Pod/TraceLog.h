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

#import "TLogger.h"

/*
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

// Instance level macros

/**
 * LogError logs an message with LogLevel Error to the LogWriters
 *
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
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
#define LogError(...)       CLogError([self class],_cmd,self,__VA_ARGS__)

/**
 * LogWarning logs an message with LogLevel Warning to the LogWriters
 *
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
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
#define LogWarning(...)     CLogWarning([self class],_cmd,self,__VA_ARGS__)

/**
 * LogInfo logs an message with LogLevel Info to the LogWriters
 *
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
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
#define LogInfo(...)        CLogInfo([self class],_cmd,self,__VA_ARGS__)

/**
 * LogTrace logs an message with LogLevel Trace to the LogWriters
 *
 * @param level An integer representing the trace LogLevel (i.e. TRACE1, TRACE2, TRACE3, and TRACE4.
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
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
#define LogTrace(level,...) CLogTrace([self class],_cmd,self,level,__VA_ARGS__)

// Low level - for use in mixed low level C code.
/**
 * CLogError logs an message with LogLevel Error to the LogWriters and accepts
 * a class, selector and optionally an instance of a class to log.
 *
 * @param clazz The class that this call is related to.
 * @param sel   The selector that this call is related to.
 * @param clazzInstanceOrNil the class instance that this call is related to if available.  Optional.
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
 */
#define CLogError(clazz,sel,clazzInstanceOrNil,...)       LogIfEnabled(clazz,sel,clazzInstanceOrNil,LogLevelError,__VA_ARGS__)

/**
 * CLogWarning logs an message with LogLevel Error to the LogWriters and accepts
 * a class, selector and optionally an instance of a class to log.
 *
 * @param clazz The class that this call is related to.
 * @param sel   The selector that this call is related to.
 * @param clazzInstanceOrNil the class instance that this call is related to if available.  Optional.
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
 */
#define CLogWarning(clazz,sel,clazzInstanceOrNil,...)     LogIfEnabled(clazz,sel,clazzInstanceOrNil,LogLevelWarning,__VA_ARGS__)

/**
 * CLogInfo logs an message with LogLevel Error to the LogWriters and accepts
 * a class, selector and optionally an instance of a class to log.
 *
 * @param clazz The class that this call is related to.
 * @param sel   The selector that this call is related to.
 * @param clazzInstanceOrNil the class instance that this call is related to if available.  Optional.
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
 */
#define CLogInfo(clazz,sel,clazzInstanceOrNil,...)        LogIfEnabled(clazz,sel,clazzInstanceOrNil,LogLevelInfo,__VA_ARGS__)

/**
 * CLogTrace logs an message with LogLevel Error to the LogWriters and accepts
 * a class, selector and optionally an instance of a class to log.
 *
 * @param clazz The class that this call is related to.
 * @param sel   The selector that this call is related to.
 * @param clazzInstanceOrNil the class instance that this call is related to if available.  Optional.
 * @param level An integer representing the trace LogLevel (i.e. TRACE1, TRACE2, TRACE3, and TRACE4.
 * @param ...   A variable argument list which is similar to NSLog.  Should start with either a format string or a string with no format specifiers.
 */
#define CLogTrace(clazz,sel,clazzInstanceOrNil,level,...)  LogIfEnabled(clazz,sel,clazzInstanceOrNil,(LogLevel) LogLevelTrace1 + ((int)level) - 1,__VA_ARGS__)

#endif
