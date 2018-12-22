# TraceLog ![license: Apache 2.0](https://img.shields.io/badge/license-Apache%202.0-lightgray.svg?style=flat)

<a href="https://github.com/tonystone/tracelog/" target="_blank">
    <img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux%20-lightgray.svg?style=flat" alt="Platforms: iOS | macOS | watchOS | tvOS | Linux" />
</a>
<a href="https://github.com/tonystone/tracelog/" target="_blank">
   <img src="https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat" alt="Swift 5.0"/>
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
<a href="https://github.com/tonystone/tracelog/" target="_blank">
    <img src="https://img.shields.io/cocoapods/dt/TraceLog.svg?style=flat" alt="Downloads">
</a>

## Introduction

TraceLog's is designed to be a universal, flexible, portable, lightweight, and easy to use logging and trace facility.

### TraceLog Design Philosophy
1) **Universal**: With TraceLog you are not locked into one type of logging system, as a matter of fact, you can choose to use a combination of log writers to write to various endpoints and systems.
2) **Flexible**: With TraceLog you can filter messages dynamically at run time or statically at compile time.  Choose whatever combination of `Writers` and filters that work for your particular use case. Write your own custom `Writer`s to plug into TraceLog for customized use-cases.
3) **Portable**: At this writing, TraceLog is one of the few logging systems that was designed to run on all swift supported platforms (Linux, macOs, iOS, tvOS, and watchOS) and be used in multiple languages (Swift and Objective-C).
4) **Lightweight**: TraceLog's footprint is small and efficient.  It's designed and meant to be as efficient on resources as can be and also optimize itself out if required by the use case.
5) **Easy to use**: TraceLog can be used right out of the box with **No** setup or special dependencies.  That was designed in, and we've worked hard to maintain that over the years.  You can literally link to it and start adding `log` statements to your app and get useful output on any platform.

### Features

 - [x] Quick and easy to get started.
 - [x] Fully configurable.
 - [x] Message filtering.
 - [x] **Logging Levels** (error, warning, info, trace1, trace2, trace3, trace4).
 - [x] Custom **tag** support for message grouping and filtering.
 - [x] Dynamically configurable levels via the OS environment at run time or inline code compiled into the application.
 - [x] Installable Log Writers (multiple writers at a time)
 - [x] Create custom Log writers for any use-case.
 - [x] Predefined log writers to write to various endpoints.
    * Built-in
        * **Stdout (ConsoleWriter)** - A simple standard out (stdout) writer for logging to the console or terminal.
        * **File (FileWriter)** - A file writer which writes log output to files on local disk managing rotation and archive of files as needed.
    * External
        * **Apple Unified Logging (AdaptiveWriter)** - On Apple platforms the AdaptiveWriter writes to the Unified Logging System (see [https://github.com/tonystone/tracelog-adaptive-writer](https://github.com/tonystone/tracelog-adaptive-writer)).
        * **Linux systemd Journal (AdaptiveWriter)** - On Linux platforms the AdaptiveWriter writes to the systemd journal (see [https://github.com/tonystone/tracelog-adaptive-writer](https://github.com/tonystone/tracelog-adaptive-writer))
 - [x] Multiple **concurrency modes** for writing to Writers. Settable globally or per Writer installed.
   * **direct** - straight through real-time logging.
   * **sync** - blocking queued logging.
   * **async** - background thread logging.
- [x] **Multi-language**: Swift and Objective-C support.
- [x] **Portable**: Linux, macOS, iOS, tvOS, WatchOS

## Usage

Using TraceLog is incredibly simple out of the box.  Although TraceLog is highly configurable, to get started all you have to do is add the pod to your project,
import TraceLog to the files that require logging and start adding log statements where you need them.  TraceLog initializes itself and does everything else for you.

### Swift

For Swift TraceLog comes with the following basic Logging functions (Note: hidden
parameters and defaults were omitted for simplicity).

```swift
    logError  (tag: String?, message: @escaping () -> String)
    logWarning(tag: String?, message: @escaping () -> String)
    logInfo   (tag: String?, message: @escaping () -> String)
    logTrace  (tag: String?, level: UInt, message: @escaping () -> String)
    logTrace  (level: UInt, @escaping message: () -> String)
```

Using it is as simple as calling one of the methods depending on the current type of message you want to log, for instance, to log a simple informational message.

```swift
    logInfo { "A simple informational message" }
```

Since the message parameter is a closure that evaluates to a String, any expression that results in a string message can be used.

```swift
   logInfo {
        "A simple informational message: " +
        " Another expression or constant that evaluates to a string"
   }
```

We used closures for several reasons; one is that the closure will not be evaluated (and you won't incur the overhead) if logging is disabled or if the log level for this call is higher than the current log level set. And two, more complex expressions can be put into the closure to make decisions on the message to be printed based on the current context of the call.  Again, these complex closures will not get executed in the cases mentioned above.  For instance:

```swift
    logInfo {
         if let unwrappedOptionalString = optionalString {
            return "Executing with \(unwrappedOptionalString)..."
         } else {
            return "Executing..."
         }
    }
```

Log methods take an optional tag that you can use to group related messages and also be used to determine whether this statement gets logged based on the current environment configuration.  It no tag is set, the file name of the calling method is used as the tag.

```swift
   logInfo("MyCustomTag") {
        "A simple informational message"
   }
```

There are several trace levels for `logTrace` that can be used.  If you don't pass a level, you get level 3, otherwise, specify a level when making the `logTrace` call.   For example, here is a trace level 1 and a level 3 call.

```swift
   logTrace {
        "A simple trace level 1 message"
   }

   logTrace(3) {
        "A simple trace level 3 message"
   }
```

You can of course also pass a tag like the rest of the log calls.

```swift
    logTrace("MyCustomTag", level: 3) {
         "A simple trace level message"
    }
```

That is all there is to adding logging to your **Swift** application!

### Objective-C

As with Swift using TraceLog with Objective-C is extremely simple out of the box.  The Objective-C implementation consists of the following primary logging methods. Each has a format specifier (like `NSLog`) and an optional variable number of arguments that represent your placeholder replacement values.

```objc
    LogError  (format,...)
    LogWarning(format,...)
    LogInfo   (format,...)
    LogTrace  (level,format,...)
```

Using it is as simple as calling one of the methods depending on the current type of message you want to log, for instance, to log a simple informational message.

```objc
    LogInfo(@"A simple informational message");
```

You can also call it as you would `NSlog` by using the format specifier and parameters for placeholder replacement.

```objc
    LogInfo(@"A simple informational message: %@", @"Another NSString or expression that evaluates to an NSString");
```

More complex expressions can be put into the placeholder values by using Objective-C blocks that return a printable NSObject. These can be used to make decisions on the message to be printed based on the current context of the call.  These complex blocks will not get executed (and you won't incur the overhead) if logging is disabled or if the log level for this call is higher than the current log level set.  For instance:

```objc
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

There is a special version of Log methods take an optional tag that you can use to group related messages and also be used to determine whether this statement gets logged based on the current environment configuration.  These methods begin with C (e.g. `CLogInfo`).

```objc
    CLogInfo(@"MyCustomTag", @"A simple informational message");
```

There are several trace levels for `LogTrace` that can be used. For example, here is a trace level 3 call.

```objc
    LogTrace(3, @"A simple trace level message");
```

You can of course also pass a tag by using the CLog version of the call.

```objc
    CLogTrace(3, @"MyCustomTag", @"A simple trace level message");
```

## Configuration

TraceLog can be configured via the environment either manually using `export` or via Xcode.
For TraceLog to read the environment on startup, you must call its configure method at the beginning of your application.

```swift
   TraceLog.configure()
```

### Log Writers

TraceLog can be configured with multiple custom log writers who do the job of outputting the log statements to the desired location.  By default, it configures itself with a `ConsoleWriter`
which outputs to `stdout`.  You can change the writers at any time and chain multiple of them to output to different locations such as to a remote logging servers, syslog, etc.

Writers must implement the `Writer` protocol.  To install them, simply call configure with an array of `Writers`.

```swift
    let networkWriter = NetworkWriter(url: URL("http://mydomain.com/log"))

    TraceLog.configure(writers: [ConsoleWriter(), networkWriter])
```

Since writers are instantiated before the call, you are free to initialize them with whatever makes sense for the writer type to be created.  For instance in the case of the network writer the URL of
the logging endpoint.

### Concurrency Modes

TraceLog can be configured to run in 3 main concurrency modes, `.direct`, `.sync`, or `.async`.  These modes determine how TraceLog will invoke each writer as it logs your logging statements.

* `.direct` - Direct, as the name implies, will directly call the writer from the calling thread with no indirection. It will block until the writer(s) in this mode have completed the write to the endpoint. Useful for scripting applications and other applications where it is required for the call not to return until the message is printed.

* `.sync` - Synchronous blocking mode is similar to direct in that it blocks but this mode also uses a queue for all writes.  The benefits of that is that all threads writing to the log will be serialized through before calling the writer (one call to the writer at a time).

* `.async` - Asynchronous non-blocking mode.  A general mode used for most application which queues all messages before being evaluated or logged. This ensures minimal delays in application execution due to logging.

Modes can be configured globally for all writers including the default writer by simply setting the mode in the configuration step as in the example below.
```swift
    TraceLog.configure(mode: .direct)
```
This will set TraceLog's default writer to `.direct` mode.

You can also configure each writer individually by wrapping the writer in a mode as in the example below.

```swift
    TraceLog.configure(writers: [.direct(ConsoleWriter()), .async(FileWriter())])
```
This will set the ConsoleWriter to write directly (synchronously) when you log but will queue the FileWriter calls to write in the background asynchronously.

You can also set all writers to the same mode by setting the default mode and passing the writer as normal as in the following statement.

```swift
    TraceLog.configure(mode: .direct, writers: [ConsoleWriter(), FileWriter()])
```
This sets both the ConsoleWriter and the FileWriter to `.direct` mode.

## Setting up your debug environment

TraceLog's current logging output is controlled by variables that are either set in the runtime environment or passed on startup of the application (in the `TraceLog.Configure(environment:)` method).

These variables consist of the following:

```shell
    LOG_ALL=<LEVEL>
    LOG_TAG_<TAGNAME>=<LEVEL>
    LOG_PREFIX_<TAGPREFIX>=<LEVEL>
```
Log output can be set globally using the `LOG_ALL`  variable, by TAG name
using the `LOG_TAG_<TAGNAME>` variable pattern, and/or by a TAG prefix by using
the `LOG_PREFIX_<TAGPREFIX>` variable pattern.

Each environment variable set is set with a level as the value.  The following levels are available in order of display priority.  Each level encompasses the level below it with `TRACE4` including the output from every level.  The lowest level setting is `OFF` which turns logging off for the level set.

Levels:
```shell
    TRACE4
    TRACE3
    TRACE2
    TRACE1
    INFO
    WARNING
    ERROR
    OFF
```
> Note: Log level `OFF` does not disable **TraceLog** completely, it only suppresses log messages for the time it is set in the environment during your debug session.  To completely disable **TraceLog** please see [Runtime Overhead](#runtime-overhead) for more information.

Multiple Environment variables can be set at one time to get the desired level of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of `TRACE` logging for your Networking module which has a class prefix of NT and you wanted to see only errors and warnings for the rest of the application.  You would set the following:

```shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
```

More specific settings override less specific so in the above example, the less specific setting is `LOG_ALL` which is set to `WARNING`.  The tag prefix is specifying a particular collection of tags that start with the string CS, so this is more specific and overrides
the `LOG_ALL`.  If you choose to name a particular tag, that will override the prefix settings.

For instance, in the example above, if we decided for one tag in the Networking module, we needed more output, we could set the following:
```shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
    LOG_TAG_NTSerializer=TRACE4
```
This outputs the same as the previous example except for the `NTSerializer` tag which is set to `TRACE4` instead of using the less specific `TRACE1` setting in `LOG_PREFIX`.

#### Environment Setup (Xcode)

To set up the environment using Xcode, select "Edit Scheme" from the "Set the active scheme" menu at the top left.  That brings up the menu below.

<img src=Docs/Xcode-environment-setup-screenshot.png width=597 height=361 />

#### Environment Setup (Statically in code)

TraceLog.configure() accepts an optional parameter called environment which you can pass the environment.  This allows you to set the configuration options at startup time (note: this ignores any variables passed in the environment).

Here is an example of setting the configuration via `TraceLog.configure()`.
```swift
    TraceLog.configure(environment: ["LOG_ALL": "TRACE4",
                                    "LOG_PREFIX_NS" : "ERROR",
                                    "LOG_TAG_TraceLog" : "TRACE4"])
```

Note: Although the environment is typically set once at the beginning of the application, `TraceLog.configure`
can be called anywhere in your code as often as required to reconfigured the logging levels.

## Runtime Overhead

The **Swift** implementation was designed to take advantage of swift compiler optimizations and will incur **no overhead** when compiled with optimization on (`-O`) and `TRACELOG_DISABLED` is defined.

The **Objective-C** implementation was designed to take advantage of the preprocessor and when compiled with `TRACELOG_DISABLED` defined, will incur **no overhead** in the application.

For XCode `TRACELOG_DISABLED` can be set in the project target. For **Swift Package Manager** pass a swiftc directive to `swift build` as in the following example.

`swift build -Xswiftc -DTRACELOG_DISABLED`

## Minimum Requirements

Build Environment

| Platform | Swift | Swift Build | Xcode |
|:--------:|:-----:|:----------:|:------:|
| Linux    | 5.0 | &#x2714; | &#x2718; |
| OSX      | 5.0 | &#x2714; | Xcode 10 |

Minimum Runtime Version

| iOS |  OS X | tvOS | watchOS | Linux |
|:---:|:-----:|:----:|:-------:|:------------:|
| 9.0 | 10.10 | 9.0  |   2.0   | Ubuntu 14.04, 16.04, 16.10 |

> **Note:**
>
> To build and run on **Linux** we have a a pre-configured **Vagrant** file located at [https://github.com/tonystone/vagrant-swift](https://github.com/tonystone/vagrant-swift)
>
> See the [README](https://github.com/tonystone/vagrant-swift/blob/master/README.md) for instructions.
>

## Installation (Swift Package Manager)

TraceLog now supports dependency management via Swift Package Manager on All Apple OS variants as well as Linux.

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

Tony Stone ([https://github.com/tonystone](https://github.com/tonystone))

## License

TraceLog is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
