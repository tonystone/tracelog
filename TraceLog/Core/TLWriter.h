/**
 *   TLWriter.h
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
 *   Created by Tony Stone on 11/12/15.
 */
#import <Foundation/Foundation.h>
#import "TLLogLevel.h"

/**
 * @interface   TLWriter
 *
 * @brief       Implement this protocol to allow you to plug in your class as a TLWriter into TraceLog.
 *
 * @author      Tony Stone
 * @date        11/12/15
 */
@protocol TLWriter <NSObject>

@required

    /**
     * Called when the logger needs to log an event to this logger.
     *
     * @param timestamp             Timestamp of the log event (number of seconds from 1970).
     * @param level                 The LogLevel of this logging event. Note: log will not be called if the LegLevel is not set to above this calls log level
     * @param tag                   The tag associated with the log event.
     * @param message               The message string (already formatted) for this logging event.
     * @param file                  The source file (of the calling program) of this logging event.
     * @param function              The function (of the calling program) which is being called.
     * @param lineNumber            The source line number (of the calling program) of this logging event.
     */
    - (void) log: (NSTimeInterval) timestamp level: (LogLevel) level tag: (nonnull const NSString *) tag message: (nullable const NSString *) message file: (nonnull const NSString *) file function: (nonnull const NSString *) function lineNumber: (NSUInteger) lineNumber;

@end