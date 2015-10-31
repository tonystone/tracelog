/**
 *   TLogger.m
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
#import "TLogger.h"

static NSString * const ModuleLogName  = @"TraceLog";

static NSString * const LogScopeClass  = @"LOG_CLASS_";
static NSString * const LogScopePrefix = @"LOG_PREFIX_";
static NSString * const LogScopeAll    = @"LOG_ALL";

//
// Internal static data
//
static NSArray      * _logLevelStrings;
static LogLevel       _globalLogLevel;
static NSDictionary * _loggedPrefixes;
static NSDictionary * _loggedClasses;

//
// Forward declarations
//
NSNumber * prefixLogLevelForClassName(NSString * className);
LogLevel logLevelForString(NSString * logLevelString);
NSString * stringForLogLevel(LogLevel logLevel);

//
// Main implementation class
//
@implementation TLogger

    + (void) initialize {
#ifdef DEBUG

        if (self == [TLogger class]) {
            //
            // Note: This must match the positive values of the LogLevel enum.
            //
            _logLevelStrings = @[@"OFF", @"ERROR", @"WARNING", @"INFO", @"TRACE1", @"TRACE2", @"TRACE3", @"TRACE4"];
            _globalLogLevel  = LogLevelInfo;

            //
            // If the system is enabled, we always print our initialization messages and errors.
            //
            [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                logLevel: LogLevelInfo
                 message: [[NSMutableString alloc] initWithFormat: @"%@ is enabled, reading environment and configuring logging...", ModuleLogName]];
            
            NSDictionary * environment = [[NSProcessInfo processInfo] environment];

            NSMutableDictionary * loggedPrefixes = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * loggedClasses  = [[NSMutableDictionary alloc] init];

            for (NSString * variable in environment) {
                //
                // All variables and class names are converted
                // to upper case for comparison.
                //
                NSString * upperCaseVariable = [variable uppercaseString];
                NSString * upperCaselogLevelString  = [environment[variable] uppercaseString];

                if ([upperCaseVariable hasPrefix: LogScopeAll]) {
                    LogLevel requestedLogLevel = logLevelForString(upperCaselogLevelString);
                    
                    if (requestedLogLevel != LogLevelInvalid) {
                        _globalLogLevel = requestedLogLevel;
                    } else {
                        [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                            logLevel: LogLevelError
                             message: [NSString stringWithFormat: @"Variable '%@' has an invalid logLevel of '%@'. '%@' will be set to %@.", upperCaseVariable, upperCaselogLevelString, LogScopeAll, stringForLogLevel(_globalLogLevel)]];
                    }
                    
                } else if ([upperCaseVariable hasPrefix: LogScopePrefix]) {
                    LogLevel requestedLogLevel = logLevelForString(upperCaselogLevelString);
                    
                    if (requestedLogLevel != LogLevelInvalid) {
                        //
                        // Note: in order to allow for case sensitive class prefix names, we use the variable instead of the uppercase version.
                        //
                        NSRange    logLevelScopeRange = [variable rangeOfString: LogScopePrefix];
                        NSString * logLevelScope      = [variable substringFromIndex: logLevelScopeRange.location + logLevelScopeRange.length];
                        
                        loggedPrefixes[logLevelScope] =  @(requestedLogLevel);
                    } else {
                        [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                            logLevel: LogLevelError
                             message: [NSString stringWithFormat: @"Variable '%@' has an invalid logLevel of '%@'. '%@' will NOT be set.", upperCaseVariable, upperCaselogLevelString, upperCaseVariable]];
                    }
                    
                } else if ([upperCaseVariable hasPrefix: LogScopeClass]) {
                    LogLevel requestedLogLevel = logLevelForString(upperCaselogLevelString);
                    
                    if (requestedLogLevel != LogLevelInvalid) {
                        
                        //
                        // Note: in order to allow for case sensitive class names, we use the variable instead of the uppercase version.
                        //
                        NSRange    logLevelScopeRange = [variable rangeOfString: LogScopeClass];
                        NSString * logLevelScope      = [variable substringFromIndex: logLevelScopeRange.location + logLevelScopeRange.length];
                    
                        // Make sure the class is linked with the, give a warning if not
                        Class clazz = NSClassFromString(logLevelScope);
                        if (!clazz) {
                            [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                                logLevel: LogLevelWarning
                                 message: [NSString stringWithFormat: @"You've requested logLevel '%@' for class '%@' but this class is not linked with the application.", upperCaselogLevelString, logLevelScope]];
                        }
                        
                        loggedClasses[logLevelScope]  = @(requestedLogLevel);
                    } else {
                        [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                            logLevel: LogLevelError
                             message: [NSString stringWithFormat: @"Variable '%@' has an invalid logLevel of '%@'. '%@' will NOT be set.", upperCaseVariable, upperCaselogLevelString, upperCaseVariable]];
                    }
                }
            }
            _loggedPrefixes = [[NSDictionary alloc] initWithDictionary: loggedPrefixes];
            _loggedClasses  = [[NSDictionary alloc] initWithDictionary: loggedClasses];
            
            // Print the current configuration
            [TLogger log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__
                logLevel: LogLevelInfo
                 message: [NSString stringWithFormat: @"%@ has been configured with the following settings: \n%@", ModuleLogName, [TLogger currentConfigurationString]]];
        }
#endif
    }

    + (NSString *) currentConfigurationString {

        NSMutableString * loggedString = [[NSMutableString alloc] initWithString: @"{"];
        
        if ([_loggedClasses count] > 0) {
            
            [loggedString appendString: @"\n\tclass: {\n"];
            
            for (NSString  * className in [_loggedClasses allKeys]) {
                NSString * logLevel = stringForLogLevel((LogLevel)[_loggedClasses[className] intValue]);
                
                [loggedString appendString: [[NSMutableString alloc] initWithFormat: @"\n%30s = %@", [className UTF8String], logLevel]];
                
                Class clazz = NSClassFromString(className);
                if (!clazz) {
                    [loggedString appendString: [[NSMutableString alloc] initWithFormat: @"%*s" "%@",  8 - (int) [logLevel length], " ", @"(class missing)"]];
                }
            }
            [loggedString appendString: @"\n\t}"];
        }
        
        if ([_loggedPrefixes count] > 0) {
            
            [loggedString appendString: @"\n\tprefix: {\n"];
            
            for (NSString  * prefix in [_loggedPrefixes allKeys]) {
                NSNumber  * logLevel = _loggedPrefixes[prefix];
                
                [loggedString appendString: [[NSMutableString alloc] initWithFormat: @"\n%30s = %@", [prefix UTF8String], stringForLogLevel((LogLevel)[logLevel intValue])]];
            }
            [loggedString appendString: @"\n\t}"];
        }
        [loggedString appendFormat: @"\n\tglobal: {\n\n%30s = %@\n\t}\n}", "ALL", stringForLogLevel(_globalLogLevel)];
        
        return loggedString;
    }

    + (void) log:(Class)callingClass selector:(SEL)selector classInstance: (id) classInstanceOrNil sourceFile:(char *)sourceFile sourceLineNumber:(int)sourceLineNumber logLevel:(LogLevel)level message:(NSString *)message {

        // Set to the default global level first
        LogLevel currentLevel = _globalLogLevel;

        NSString * className = NSStringFromClass(callingClass);

        // Determine if there is a class log level first
        NSNumber * classLogLevel  = _loggedClasses[className];

        // Determine the prefixes log level if available
        NSNumber * prefixLogLevel = prefixLogLevelForClassName(className);

        //
        // Now see if there is a user set level for this class
        //
        if (classLogLevel) {
            currentLevel = (LogLevel) [classLogLevel intValue];
        } else if (prefixLogLevel) {
            currentLevel = (LogLevel) [prefixLogLevel intValue];
        }

        if (currentLevel >= level) {
            if (classInstanceOrNil) {
                NSLog(@"%7s: <%@ : %p> %@", [stringForLogLevel(level) cStringUsingEncoding: NSUTF8StringEncoding], NSStringFromClass(callingClass), (__bridge void *) classInstanceOrNil, message);
            } else {
                NSLog(@"%7s: <%@> %@", [stringForLogLevel(level) cStringUsingEncoding:NSUTF8StringEncoding], NSStringFromClass(callingClass), message);
            }
        }
    }

@end

//
// Low level C functions
//
NSNumber * prefixLogLevelForClassName(NSString * className) {

    for (NSString * prefix in [_loggedPrefixes allKeys]) {
        if ([className hasPrefix: prefix]) {
            return _loggedPrefixes[prefix];
        }
    }
    return nil;
}

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

