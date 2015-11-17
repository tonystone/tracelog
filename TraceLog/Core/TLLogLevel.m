/**
 *   TLLogLevel.m
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
 *   Created by Tony Stone on 11/13/15.
 */
#import "TLLogLevel.h"

static NSArray * _logLevelStrings;

__attribute__((used,visibility("internal"),constructor(101))) static void staticInitialization() {
    _logLevelStrings = @[
            @"OFF",
            @"ERROR",
            @"WARNING",
            @"INFO",
            @"TRACE1",
            @"TRACE2",
            @"TRACE3",
            @"TRACE4"
    ];
};

LogLevel logLevelForString(NSString * logLevelString) {

    for (LogLevel logLevel = LogLevelOff; logLevel < [_logLevelStrings count]; logLevel++) {
        if ([logLevelString isEqualToString: _logLevelStrings[logLevel]]) {
            return logLevel;
        }
    }
    return LogLevelInvalid;
}

NSString * stringForLogLevel(LogLevel logLevel) {

    if (logLevel > [_logLevelStrings count] || logLevel < 0) {
        return @"INVALID";
    }
    return _logLevelStrings[logLevel];
}