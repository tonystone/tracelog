//
//  TLogger.h
//  Pods
//
//  Created by Tony Stone on 3/4/15.
//
//

#import <Foundation/Foundation.h>

/*
  WARNING:  This is a private file and nothing
  in this file should be used on it's own.  Please
  see TraceLog.h for the public interface to this.
*/


typedef enum {
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
