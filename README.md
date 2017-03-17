# TraceLog ![License: Apache 2.0](https://img.shields.io/badge/License-Apache%202.0-lightgray.svg?style=flat)

<a href="https://github.com/tonystone/tracelog/" target="_blank">
    <img src="https://img.shields.io/badge/Platforms-ios%20%7C%20osx%20%7C%20watchos%20%7C%20tvos%20%7C%20linux%20-lightgray.svg?style=flat" alt="Platforms: ios | osx | watchos | tvos | Linux" />
</a>
<a href="https://github.com/tonystone/tracelog/" target="_blank">
    <img src="https://img.shields.io/badge/Compatible-CocoaPods%20%7C%20Swift%20PM-lightgray.svg?style=flat" alt="Compatible: CocoaPods | Swift PM" />
</a>
<a href="https://github.com/tonystone/tracelog/" target="_blank">
   <img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift 3.0"/>
</a>
<a href="http://cocoadocs.org/docsets/TraceLog" target="_blank">
   <img src="https://img.shields.io/cocoapods/v/TraceLog.svg?style=flat" alt="Version"/>
</a>
<a href="https://travis-ci.org/tonystone/tracelog" target="_blank">
   <img src="https://travis-ci.org/tonystone/tracelog.svg?branch=master" alt="Build Status"/>
</a>
<a href="https://codecov.io/gh/tonystone/tracelog">
  <img src="https://codecov.io/gh/tonystone/tracelog/branch/master/graph/badge.svg" alt="Codecov" />
</a>

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

### Swift

For Swift TraceLog comes with the following basic Logging functions (Note: hidden 
parameters and defaults where omitted for simplicity).

```Swift
    logError  (tag: String?, message: @escaping () -> String)
    logWarning(tag: String?, message: @escaping () -> String)
    logInfo   (tag: String?, message: @escaping () -> String)
    logTrace  (tag: String?, level: UInt, message: @escaping () -> String)
    logTrace  (level: UInt, @escaping message: () -> String)
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

TraceLog is configured via variables that are either set in the runtime environment
or passed on startup of the application.

These variables consist of the following:

```Shell
    LOG_ALL=<LEVEL>
    LOG_TAG_<TAGNAME>=<LEVEL>
    LOG_PREFIX_<TAGPREFIX>=<LEVEL>
```
Log output can be configured globally using the `LOG_ALL`  variable, by TAG name 
using the `LOG_TAG_<TAGNAME>` variable pattern, and/or by a TAG prefix by using 
the `LOG_PREFIX_<TAGPREFIX>` variable pattern.

Each environment variable set is set with a level as the value.  The following
levels are available in order of display priority.  Each level encompasses the
level below it with `TRACE4` including the output from every level.  The lowest
level setting is `ERROR` which only outputs errors when they occur.

Levels:
```Shell
    TRACE4
    TRACE3
    TRACE2
    TRACE1
    INFO
    WARNING
    ERROR
```

Multiple Environment variables can be set at one time to get the desired level
of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of `TRACE` logging for your Networking module
which has a class prefix of NT and you wanted to see only errors and warnings for
the rest of the application.  You would set the following:

```Shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
```

More specific settings override less specific so in the above example the less specific
setting is `LOG_ALL` which is set to `WARNING`.  The tag prefix is specifying a particular
collection of tags that start with the string CS so this is more specific and overrides
the `LOG_ALL`.  If you chose to name a specific tag, that would override the prefix settings.

For instance, in the example above, if we decided for one tag in the Networking module,
we needed more output, we could set the following:
```Shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
    LOG_TAG_NTSerializer=TRACE4
```
This outputs the same as the previous example with the exception of the `NTSerializer` tag
which is set to `TRACE4` instead of using the less specific `TRACE1` setting in `LOG_PREFIX`.

#### Configuration (Environment)

TraceLog can be configured via the environment either manually using `export` or via Xcode. 
In order for TraceLog to read the environment on startup you must call its configure method at 
the beginning of your application.

```
   TraceLog.configure()
```

To setup the environment using Xcode, select "Edit Scheme" from the "Set the active scheme" menu 
at the top left.  That brings up the menu below.

<img src=Docs/Xcode-environment-setup-screenshot.png width=597 height=361 />

#### Configuration (In code)

TraceLog.configure() accepts an optional parameter called environment which you can 
pass the environment.  This allows you to set the configuration options at startup
time (note: this ignores any variables passed in the environment).

Here is an example of setting the configuration via `TraceLog.configure()`.
```
TraceLog.configure(environment: ["LOG_ALL": "TRACE4",
                                 "LOG_PREFIX_NS" : "ERROR",
                                 "LOG_TAG_TraceLog" : "TRACE4"])
```

Note: Although the environment is typically set once at the beginning of the application, `TraceLog.configure`
can be called anywhere in your code as often as required to reconfigured the logging levels.

## Configuring Log Writers

TraceLog can be configured with multiple custom log writers which do the job of outputting the 
log statements to the desired location.  By default it configures itself with a `ConsoleWriter`
which outputs to `stdout`.  You can change the writers at any time and chain multiple of them to 
output to different locations such as to a remote logging servers, syslog, etc.

Writers must implement the `Writer` protocol and to install, simply call configure with an array 
of `Writers`.

```
let networkWriter = NetworkWriter(url: URL("http://mydomain.com/log"))

TraceLog.configure(writers: [ConsoleWriter(), networkWriter])
```

Since writers are instantiated before the call, you are free to initialize them with whatever makes sense
for the writer type be created.  For instance in the case of the network writer the URL of 
the logging endpoint.

## Runtime Overhead

The **Swift** implementation was designed to take advantage of swift compiler optimizations and will 
incur **no overhead** when compiled with optimization on (`-O`) and `TRACELOG_DISABLED` is defined.  

The **Objective-C** implementation was designed to take advantage of the preprocessor and when 
compiled with `TRACELOG_DISABLED` defined, will incur **no overhead** in the application.

For XCode `TRACELOG_DISABLED` can be set in the project target. For **Swift Package Manager** pass a swiftc directive 
to `swift build` as in the following example.

`swift build -Xswiftc -DTRACELOG_DISABLED`

## Compatibility

TraceLog has been tested on macOS, iOS, and Ubuntu.

## Requirements

### Swift 3.0

TraceLog requires **Swift 3.0** or higher to compile.

#### Linux (Ubuntu)

After you have installed a **Swift 3.0** toolchain from Swift.org, open up a terminal window and type

`swift --version`

It will produce a message similar to this one:

`Apple Swift version 3.0 (swiftlang-800.0.33.1 clang-800.0.31)
Target: x86_64-apple-macosx10.9`

Make sure you are running the latest version of **Swift 3.0**. TraceLog will not compile successfully if you are running a version of Swift that is lower than 3.0.

Note:  If you are running **Ubuntu 14.04**, this version requires **clang 3.8** and **lldb 3.8** on the system.  To install them on the target build system run:

```
sudo apt-get -y install clang-3.8 lldb-3.8 libicu-dev
```

Compiling TraceLog on OSX requires **XCode 8.0** or above as well as specfic minimum deployment targets for each language.  These are listed below.

| OS X  | iOS | tvOS | watchOS | 
|:-----:|:---:|:----:|:-------:|
| 10.10 | 8.0 | 9.0  |   2.0   |


## Installation (Swift Package Manager)

TraceLog now supports dependency management via Swift Package Manager on All Apple OS variants as well as Linux.  To add TraceLog as a dependency to your project add the following to your `Package.swift` file in the project root.

Please see [Swift Package Manager](https://swift.org/package-manager/#conceptual-overview) for further information.

## Installation (CocoaPods)

TraceLog is available through [CocoaPods](http://cocoapods.org). Currently Swift is the default so to install it, simply add the following line to your Podfile:

### Swift

```ruby
pod "TraceLog"
```
Please note that this is a change from the 1.x versions of TraceLog in where Objective-C was the default.  Now to use Objective-C, you must specify the subspec as follows:

### Objective-C

```ruby
pod "TraceLog/ObjC"
```
### Mixed Environments

TraceLog was designed to work in mixed environments so you can have **Swift** pod/modules using TraceLog as well as 
**Objective-C** pods/libraries in the same application. The configuration settings you set will set the values for both. 
If you have an application that contains mixed **Swift** and **Objective-C** code you can include both into your application.  

For example:

```ruby
pod "TraceLog"
pod "TraceLog/ObjC"
```

See the ["Using CocoaPods"](https://guides.cocoapods.org/using/using-cocoapods.html) guide for more information.

## Author

Tony Stone ([https://github.com/tonystone] (https://github.com/tonystone))

## License

TraceLog is released under the [Apache License, Version 2.0] (http://www.apache.org/licenses/LICENSE-2.0.html)

