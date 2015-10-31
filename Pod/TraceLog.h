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

#ifdef DEBUG

// Instance level macros
#define LogError(...)       CLogError([self class],_cmd,self,__VA_ARGS__)
#define LogWarning(...)     CLogWarning([self class],_cmd,self,__VA_ARGS__)
#define LogInfo(...)        CLogInfo([self class],_cmd,self,__VA_ARGS__)
#define LogTrace(level,...) CLogTrace([self class],_cmd,self,level,__VA_ARGS__)

// Low level - for use in mixed low level C code.
#define CLogError(clazz,sel,clazzInstanceOrNil,...)       [TLogger log: clazz selector: sel classInstance: clazzInstanceOrNil sourceFile: __FILE__ sourceLineNumber: __LINE__ logLevel: LogLevelError   message: [NSString stringWithFormat:__VA_ARGS__]]
#define CLogWarning(clazz,sel,clazzInstanceOrNil,...)     [TLogger log: clazz selector: sel classInstance: clazzInstanceOrNil sourceFile: __FILE__ sourceLineNumber: __LINE__ logLevel: LogLevelWarning message: [NSString stringWithFormat:__VA_ARGS__]]
#define CLogInfo(clazz,sel,clazzInstanceOrNil,...)        [TLogger log: clazz selector: sel classInstance: clazzInstanceOrNil sourceFile: __FILE__ sourceLineNumber: __LINE__ logLevel: LogLevelInfo    message: [NSString stringWithFormat:__VA_ARGS__]]
#define CLogTrace(clazz,sel,clazzInstanceOrNil,level,...) [TLogger log: clazz selector: sel classInstance: clazzInstanceOrNil sourceFile: __FILE__ sourceLineNumber: __LINE__ logLevel: (LogLevel) LogLevelTrace1 + ((int)level) - 1   message: [NSString stringWithFormat:__VA_ARGS__]]

#else

// Instance level macros
#define LogError(...)   /* empty */
#define LogWarning(...) /* empty */
#define LogInfo(...)    /* empty */
#define LogTrace(...)   /* empty */

// Low level - for use in mixed low level C code.
#define CLogError(clazz,sel,clazzInstanceOrNil,...)       /* empty */
#define CLogWarning(clazz,sel,clazzInstanceOrNil,...)     /* empty */
#define CLogInfo(clazz,sel,clazzInstanceOrNil,...)        /* empty */
#define CLogTrace(clazz,sel,clazzInstanceOrNil,level,...) /* empty */

#endif

#endif
