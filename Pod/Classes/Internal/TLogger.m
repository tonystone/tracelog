//
//  TLogger.m
//  Pods
//
//  Created by Tony Stone on 3/4/15.
//
//

#import "TLogger.h"

static NSString * const LogScopeClass         = @"LOG_CLASS_";
static NSString * const LogScopePrefix        = @"LOG_PREFIX_";
static NSString * const LogScopeAll           = @"LOG_ALL";

static NSString * const LogLevelErrorString   = @"ERROR";
static NSString * const LogLevelWarningString = @"WARNING";
static NSString * const LogLevelInfoString    = @"INFO";
static NSString * const LogLevelTrace1String  = @"TRACE1";
static NSString * const LogLevelTrace2String  = @"TRACE2";
static NSString * const LogLevelTrace3String  = @"TRACE3";
static NSString * const LogLevelTrace4String  = @"TRACE4";

static LogLevel       globalLogLevel;
static NSDictionary * loggedPrefixes;
static NSDictionary * loggedClasses;

@interface TLogger (Private)
    + (NSNumber *)prefixLogLevelForClassName: (NSString *) className;
    + (LogLevel) logLevelForString: (NSString *) logLevelString;
    + (NSString *) stringForLogLevel: (LogLevel) logLevel;
@end

@implementation TLogger

    + (void) log:(Class)callingClass selector:(SEL)selector classInstance: (id) classInstanceOrNil sourceFile:(char *)sourceFile sourceLineNumber:(int)sourceLineNumber logLevel:(LogLevel)level message:(NSString *)message {

        //
        // All variables and class names are converted
        // to upper case for comparison.
        //
        NSString * className      = [NSStringFromClass(callingClass) uppercaseString];
        NSNumber * classLogLevel  = loggedClasses[className];
        NSNumber * prefixLogLevel = [self prefixLogLevelForClassName:className];

        // Set to the default global level first
        LogLevel currentLevel = globalLogLevel;

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
                NSLog(@"%7s: <%@ : %p> %@", [[TLogger stringForLogLevel: level] cStringUsingEncoding: NSUTF8StringEncoding], NSStringFromClass(callingClass), (__bridge void *) classInstanceOrNil, message);
            } else {
                NSLog(@"%7s: <%@> %@", [[TLogger stringForLogLevel:level] cStringUsingEncoding:NSUTF8StringEncoding], NSStringFromClass(callingClass), message);
            }
        }
    }

@end

@implementation TLogger (Private)

    + (void)initialize {

        if (self == [TLogger class]) {
            globalLogLevel = LogLevelNone;

#ifdef DEBUG

            NSDictionary        * environmentVariables = [[NSProcessInfo processInfo] environment];
            NSMutableDictionary * tmpLoggedPrefixes    = [[NSMutableDictionary alloc] init];
            NSMutableDictionary * tmpLoggedClasses     = [[NSMutableDictionary alloc] init];

            for (NSString * variable in environmentVariables) {
                //
                // All variables and class names are converted
                // to upper case for comparison.
                //
                NSString * upperCaseVariable = [variable uppercaseString];

                NSString * logLevelString  = environmentVariables[variable];

                if ([upperCaseVariable hasPrefix: LogScopeAll]) {

                    globalLogLevel = [TLogger logLevelForString: logLevelString];

                } else if ([upperCaseVariable hasPrefix: LogScopePrefix]) {

                    NSRange    logLevelScopeRange = [upperCaseVariable rangeOfString: LogScopePrefix];
                    NSString * logLevelScope      = [upperCaseVariable substringFromIndex: logLevelScopeRange.location + logLevelScopeRange.length];

                    tmpLoggedPrefixes[logLevelScope] =  @([TLogger logLevelForString: logLevelString]);

                } else if ([upperCaseVariable hasPrefix: LogScopeClass]) {

                    NSRange    logLevelScopeRange = [upperCaseVariable rangeOfString: LogScopeClass];
                    NSString * logLevelScope      = [upperCaseVariable substringFromIndex: logLevelScopeRange.location + logLevelScopeRange.length];

                    tmpLoggedClasses[logLevelScope]  = @([TLogger logLevelForString: logLevelString]);
                }
            }
            loggedPrefixes = [[NSDictionary alloc] initWithDictionary: tmpLoggedPrefixes];
            loggedClasses  = [[NSDictionary alloc] initWithDictionary: tmpLoggedClasses];

            //
            // In order to respect the users current log settings while outputting
            // our own messages, we use our own macros to print the output.
            //
            //
            [self log: self selector: _cmd classInstance: self sourceFile:__FILE__ sourceLineNumber:__LINE__ logLevel: LogLevelInfo message:
                    [NSString stringWithFormat:  @"DEBUG is enabled\nLog level settings: \n{%@\n}", ^() {

                        NSMutableString * loggedString = [[NSMutableString alloc] init];

                        if ([loggedClasses count] > 0) {

                            [loggedString appendString: @"\n\tclass: {\n"];

                            for (NSString  * className in [loggedClasses allKeys]) {
                                NSNumber  * logLevel = loggedClasses[className];

                                [loggedString appendString: [[NSMutableString alloc] initWithFormat: @"\n%30s=%@", [className UTF8String], [self stringForLogLevel: [logLevel intValue]]]];
                            }
                            [loggedString appendString: @"\n\t}"];
                        }

                        if ([loggedPrefixes count] > 0) {

                            [loggedString appendString: @"\n\tprefix: {\n"];

                            for (NSString  * prefix in [loggedPrefixes allKeys]) {
                                NSNumber  * logLevel = loggedPrefixes[prefix];

                                [loggedString appendString: [[NSMutableString alloc] initWithFormat: @"\n%30s=%@", [prefix UTF8String], [self stringForLogLevel: [logLevel intValue]]]];
                            }
                            [loggedString appendString: @"\n\t}"];
                        }


                        [loggedString appendFormat: @"\n\tglobal: {\n\n%30s=%@\n\t}", "ALL", [self stringForLogLevel: globalLogLevel]];

                        return loggedString;
                    }(/* execute the block */)]
            ];
#endif
        }
    }

    + (NSNumber *) prefixLogLevelForClassName: (NSString *) className {

        for (NSString * prefix in [loggedPrefixes allKeys]) {
            if ([className hasPrefix: prefix]) {
                NSNumber * level = loggedPrefixes[prefix];

                return level;
            }
        }
        return nil;
    }

    + (LogLevel) logLevelForString: (NSString *) logLevelString {

        if      ([[logLevelString uppercaseString] isEqualToString: LogLevelErrorString])   return LogLevelError;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelWarningString]) return LogLevelWarning;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelInfoString])    return LogLevelInfo;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelTrace1String])  return LogLevelTrace1;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelTrace2String])  return LogLevelTrace2;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelTrace3String])  return LogLevelTrace3;
        else if ([[logLevelString uppercaseString] isEqualToString: LogLevelTrace4String])  return LogLevelTrace4;

        return LogLevelNone;
    }

    + (NSString *) stringForLogLevel: (LogLevel) logLevel {

        switch (logLevel) {
            case LogLevelError:   return LogLevelErrorString;
            case LogLevelWarning: return LogLevelWarningString;
            case LogLevelInfo:    return LogLevelInfoString;
            case LogLevelTrace1:  return LogLevelTrace1String;
            case LogLevelTrace2:  return LogLevelTrace2String;
            case LogLevelTrace3:  return LogLevelTrace3String;
            case LogLevelTrace4:  return LogLevelTrace4String;
            default:              return @"OFF";
        }
    }

@end
