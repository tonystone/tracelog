# TraceLog

[![Build Status](https://travis-ci.org/tonystone/tracelog.svg?branch=master)](https://travis-ci.org/tonystone/tracelog)
[![Version](https://img.shields.io/cocoapods/v/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)
[![License](https://img.shields.io/cocoapods/l/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)
[![Platform](https://img.shields.io/cocoapods/p/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)


## Introduction
    
TraceLog is a configurable debug logging system.  It is unique in that it's configured 
after compilation in the runtime environment. It reads environment variables from the 
process context to set log levels. This allows each developer to configure log output 
per session based on the debugging needs of that session.

## Usage

Using TraceLog is extremely simple out of the box.  Although TraceLog is 
highly configurable, to get started all you have to do is add the pod to your project,
import TraceLog to the files that require logging, and start adding log statements where 
you need them.  TraceLog initializes itself and does everything else for you. 

## Requirements

| Xcode | Swift | iOS | tvOS |  OS X |
|:-----:|:-----:|:---:|:----:|:-----:|
| 8.0   |  3.0  | 8.0 | 9.0  | 10.10 |

### Swift

For Swift Tracelog comes with the following basic Logging functions (Note: hidden 
parameters and defaults where omitted for simplicity).

```Swift
    logError  (tag: String?, message: () -> String)
    logWarning(tag: String?, message: () -> String)
    logInfo   (tag: String?, message: () -> String)
    logTrace  (tag: String?, level: UInt, message: () -> String)
    logTrace  (level: UInt,  message: () -> String)
```

Using it is as simple as calling one of the methods depending on the current type of 
message you want to log, for instance to log a simple informational message.

```Swift
    logInfo { "A simple informational message" }
```

Since the message parameter is a closure that evaluates to a String, any expression 
that results in a string message can be used.

```Swift
   logInfo { 
        "A simple informational message: " + 
        " Another expression or constant that evaluates to a string" 
   }
```

We used closures for several reasons, one is that the closure will not be evaluated (and you wont incur the overhead) 
if logging is disabled or if the log level for this call is higher then the current log level set. And two, more complex
expressions can be put into the closure to make decisions on the message to be printed based on the current context of
of the call.  Again, these complex closures will not get executed in the cases mentioned above.  For instance:

```Swift
    logInfo { 
         if let unwrappedOptionalString = optionalString {
            return "Executing with \(unwrappedOptionalString)..."
         } else {
            return "Executing..."
         }
    }
```

Log methods take an optional tag that you can use to to group related messages and also be used to determine whether 
this statement gets logged based on the current environment configuration.  It no tag is set, the file name of the 
calling method is used as the tag.

```Swift
   logInfo("MyCustomTag") { 
        "A simple informational message" 
   }
```

There are several trace levels for `logTrace` that can be use.  If you don't pass a level, you get level 3, otherwise specify 
a level when making the `logTrace` call.   For example, here is a trace level 1 and a level 3 call.

```Swift
   logTrace { 
        "A simple trace level 1 message" 
   }

   logTrace(3) { 
        "A simple trace level 3 message" 
   }
```

You can of course also pass a tag like the rest of the log calls.

```Swift
    logTrace("MyCustomTag", level: 3) { 
         "A simple trace level message" 
    }
```

That is all there is to adding logging to your **Swift** application!

### Objective-C

As with Swift using TraceLog with Objective-C is extremely simple out of the box.  The Objective-C
implementation consists of the following main logging methods. Each has a format specifier (like `NSLog`)
and an optional variable number of arguments that represent your placeholder replacement values. 

```Objective-C
    LogError  (format,...)
    LogWarning(format,...)
    LogInfo   (format,...)
    LogTrace  (level,format,...)
```

Using it is as simple as calling one of the methods depending on the current type of 
message you want to log, for instance to log a simple informational message.

```Objective-C
    LogInfo(@"A simple informational message");
```

You can also call it as you would `NSlog` by using the format specifier and parameters for placeholder replacement.

```Objective-C
    LogInfo(@"A simple informational message: %@", @"Another NSString or expression that evaluates to an NSString");
```

More complex expressions can be put into the placeholder values by using Objective-C blocks that return 
a printable NSObject. These can be used to make decisions on the message to be printed based on the current context of
of the call.  These complex blocks will not get executed (and you wont incur the overhead) if logging is disabled 
or if the log level for this call is higher then the current log level set.  For instance:

```Objective-C
    LogInfo(@"Executing%@...", 
        ^() {
            if (optionalString != nil) {
                return [NSString stringWithFormat: @" with %@", optionalString];
            } else {
                return @"";
            }
        }() 
    );
```

There is a special version of Log methods take an optional tag that you can use to to group related messages and 
also be used to determine whether this statement gets logged based on the current environment configuration.  These 
methods begin with C (e.g. `CLogInfo`).

```Objective-C
    CLogInfo(@"MyCustomTag", @"A simple informational message");
```

There are several trace levels for `LogTrace` that can be use. For example, here is a trace level 3 call.

```Objective-C
    LogTrace(3, @"A simple trace level message");
```

You can of course also pass a tag by using the CLog version of the call.

```Objective-C
    CLogTrace(3, @"MyCustomTag", @"A simple trace level message");
```

## Configuration

TraceLog is configured via the environment which is typically setup in Xcode by 
selecting "Edit Scheme" from the "Set the active scheme" menu at the top left.  
That brings up the menu below.

<img src=Docs/Xcode-environment-setup-screenshot.png width=597 height=361 />

Log output can be configured globally using the `LOG_ALL` environment variable,
by TAG name using the `LOG_TAG_<TAGNAME>` environment variable pattern,
and/or by a TAG prefix by using the `LOG_PREFIX_<TAGPREFIX>` environment
variable pattern.

Each environment variable set is set with a level as the value.  The following
levels are available in order of display priority.  Each level encompasses the
level below it with `TRACE4` including the output from every level.  The lowest
level setting, aside from no output or `OFF`, is `ERROR` which only outputs errors when
they occur.

Levels:
```Shell
    TRACE4
    TRACE3
    TRACE2
    TRACE1
    INFO
    WARNING
    ERROR
    OFF
```
Environment Variables and syntax:
```Shell
    LOG_TAG_<TAGNAME>=<LEVEL>
    LOG_PREFIX_<TAGPREFIX>=<LEVEL>
    LOG_ALL=<LEVEL>
```

Multiple Environment variables can be set at one time to get the desired level
of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of `TRACE` logging for the ClimateSecurity module
which has a class prefix of CS and you wanted to see only errors and warnings for
the rest of the application.  You would set the following:

```Shell
    LOG_ALL=WARNING
    LOG_PREFIX_CS=TRACE1
```

More specific settings override less specific so in the above example the less specific
setting is `LOG_ALL` which is set to `WARNING`.  The tag prefix is specifying a particular
collection of tags that start with the string CS so this is more specific and overrides
the `LOG_ALL`.  If you chose to name a specific tag, that would override the prefix settings.

For instance, in the example above, if we decided for one tag in the ClimateSecurity module,
we needed more output, we could set the following:
```Shell
    LOG_ALL=WARNING
    LOG_PREFIX_CS=TRACE1
    LOG_TAG_CSManager=TRACE4
```
This outputs the same as the previous example with the exception of the `CSManager` tag
which is set to `TRACE4` instead of using the less specific `TRACE1` setting in `LOG_PREFIX`.

## Runtime Overhead

The **Objective-C** implementation was designed to take advantage of the preprocessor and when compiled in a `RELEASE` build
when `DEBUG` is NOT defined, will incur **no overhead** in the application.

The **Swift** implantation was designed to take advantage of swift compiler optimizations and will incur **no overhead** when
compiled with optimization on (`-O`) and `DEBUG` is NOT defined.

Note: In both cases above, the default settings will be set correctly to enable TraceLog for the **Debug** configuration
      and optimized out for the **Release** configuration.

## Installation

TraceLog is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

### Swift

```ruby
pod "TraceLog/Swift"
```

### Objective-C

```ruby
pod "TraceLog/ObjC"
```

Currently Objective-C is the default so you can simply use the following.  We encourage you to use the former form
to ensure future compatibility.

```ruby
pod "TraceLog"
```

### Mixed Environments

TraceLog was designed to work in mixed environments so you can have **Swift** pod/modules using TraceLog as well as 
**Objective-C** pods/libraries in the same application. The configuration settings you set will set the values for both. 
If you have an application that contains mixed **Swift** and **Objective-C** code you can include both sub-modules 
into your application.  For example:

```ruby
pod "TraceLog/Swift"
pod "TraceLog/ObjC"
```

See the ["Using CocoaPods"](https://guides.cocoapods.org/using/using-cocoapods.html) guide for more information.

## Author

Tony Stone ([https://github.com/tonystone] (https://github.com/tonystone))

## License

TraceLog is released under the [Apache License, Version 2.0] (http://www.apache.org/licenses/LICENSE-2.0.html)

