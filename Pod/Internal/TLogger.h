/**
 *   TLogger.h
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
#import <Foundation/Foundation.h>

/*
  WARNING:  This is a private file and nothing
  in this file should be used on it's own.  Please
  see TraceLog.h for the public interface to this.
*/


typedef enum {
    LogLevelInvalid = -1,
    LogLevelOff     = 0,
    LogLevelError   = 1,
    LogLevelWarning = 2,
    LogLevelInfo    = 3,
    LogLevelTrace1  = 4,
    LogLevelTrace2  = 5,
    LogLevelTrace3  = 6,
    LogLevelTrace4  = 7
} LogLevel;

@interface TLogger : NSObject
    // NOTE: Do not call this directly, please use the macros for all calls.
    + (void)log:(Class)callingClass selector:(SEL)selector classInstance: (id) classInstanceOrNil sourceFile:(char *)sourceFile sourceLineNumber:(int)sourceLineNumber logLevel:(LogLevel)level message: (NSString *) message;
@end

#ifdef DEBUG
#define LogIfEnabled(clazz,sel,clazzInstanceOrNil,level,...) [TLogger log: clazz selector: sel classInstance: clazzInstanceOrNil sourceFile: __FILE__ sourceLineNumber: __LINE__ logLevel: level message: [NSString stringWithFormat:__VA_ARGS__]]
#else
#define LogIfEnabled(clazz,sel,clazzInstanceOrNil,level,...) /* empty */
#endif
