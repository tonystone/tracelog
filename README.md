> **Note** The latest release ([5.0.0-beta.2](https://github.com/tonystone/tracelog/tree/5.0.0-beta.2)) is in a **_pre-release_** state. There is active work going on that will result in API changes that can/will break code while things are finished.
>
>  For the latest stable production release, please use version [4.0.1](https://github.com/tonystone/tracelog/tree/4.0.1).

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

## Introduction

TraceLog's is designed to be a universal, flexible, portable, lightweight, and easy to use logging and trace facility.

### TraceLog Design Philosophy
1. **Universal**: With TraceLog you are not locked into one type of logging system, as a matter of fact, you can choose to use a combination of log writers to write to various endpoints and systems.
2. **Flexible**: With TraceLog you can filter messages dynamically at run time or statically at compile time.  Choose whatever combination of `Writers` and filters that work for your particular use case. Write your own custom `Writer`s to plug into TraceLog for customized use-cases.
3. **Portable**: At this writing, TraceLog is one of the few logging systems that was designed to run on all swift supported platforms (Linux, macOs, iOS, tvOS, and watchOS) and be used in multiple languages (Swift and Objective-C).
4. **Lightweight**: TraceLog's footprint is small and efficient.  It's designed and meant to be as efficient on resources as can be and also optimize itself out if required by the use case.
5. **Easy to use**: TraceLog can be used right out of the box with **No** setup or special dependencies.  That was designed in, and we've worked hard to maintain that over the years.  You can literally link to it and start adding `log` statements to your app and get useful output on any platform.

### Features

 - [x] Quick and easy to get started.
 - [x] Fully configurable.
 - [x] Message filtering.
 - [x] **Logging Levels** (error, warning, info, trace1, trace2, trace3, trace4).
 - [x] Custom **tag** support for message grouping and filtering.
 - [x] Dynamically configurable levels via the OS environment at run time or inline code compiled into the application.
 - [x] Installable log writers (multiple writers at a time)
 - [x] Create custom log writers for any use-case.
 - [x] Predefined log writers to write to various endpoints.
    * Built-in (`OutputStreamWriter`s)
        * **Stdout (ConsoleWriter)** - A simple standard out (stdout) writer for logging to the console or terminal.
        * **File (FileWriter)** - A file writer which writes log output to files on local disk managing rotation and archive of files as needed.
    * External
        * **Apple Unified Logging (AdaptiveWriter)** - On Apple platforms the AdaptiveWriter writes to the Unified Logging System (see [https://github.com/tonystone/tracelog-adaptive-writer](https://github.com/tonystone/tracelog-adaptive-writer)).
        * **Linux systemd Journal (AdaptiveWriter)** - On Linux platforms the AdaptiveWriter writes to the systemd journal (see [https://github.com/tonystone/tracelog-adaptive-writer](https://github.com/tonystone/tracelog-adaptive-writer))
 - [x] Output formatters for formatting the log entries in any format required.
    * **TextFormat** a customizable human readable text formatter useable with any `OutputStreamWriter`.
    * **JSONFormat** a customizable JSON string formatter usable with any `OutputStreamWriter`.
 - [x] Create custom output formatters for any use case.
 - [x] Multiple **concurrency modes** for writing to Writers. Settable globally or per Writer installed.
   * **direct** - straight through real-time logging.
   * **sync** - blocking queued logging.
   * **async** - background thread logging.
- [x] **Multi-language**: Swift and Objective-C support.
- [x] **Portable**: Linux, macOS, iOS, tvOS, WatchOS

## Documentation

* [User Guides & Reference](https://tonystone.io/tracelog) - Extensive user guides and reference documentation!  100% documented API, full examples and many hidden details.

## Quick Start Guide

Using TraceLog is incredibly simple out of the box.  Although TraceLog is highly configurable, to get started all you have to do is add the pod to your project,
import TraceLog to the files that require logging and start adding log statements where you need them.  TraceLog initializes itself and does everything else for you.

### Add TraceLog to your project

In your `Podfile` add TraceLog.

```ruby
    target 'MyApp'

    pod "TraceLog", '~>5.0'
```
If you have mixed Swift and Objective-C code, you must specify the subspec to enable Objective-C as follows:

```ruby
    target 'MyApp'

    pod "TraceLog", '~>5.0'
    pod "TraceLog/ObjC", '~>5.0'
```

### Import TraceLog and Start logging

Import TraceLog into you files and start logging.

```swift
    import TraceLog

    struct MyClass {

        func doSomething() {

            LogInfo { "A simple TraceLog Test message" }
        }
    }
```

### Log Functions

TraceLog has the following primary logging functions to log various levels of information.  The output of these can be controlled via the environment variables at runtime or programmatically at application startup via the `TraceLog.configure()` func.

```swift
    logError  (tag: String?, message: @escaping () -> String)
    logWarning(tag: String?, message: @escaping () -> String)
    logInfo   (tag: String?, message: @escaping () -> String)
    logTrace  (tag: String?, level: UInt, message: @escaping () -> String)
    logTrace  (level: UInt, @escaping message: () -> String)
```
> Note: hidden parameters and defaults were omitted for simplicity.

### Basic Configuration

Although not strictly require, calling the `TraceLog.configure()` command at startup will allow TraceLog to read the environment for configuration information.

Simply call configure with no parameters as early as possible in your startup code (preferably before ay log statements get called.)

```swift
    TraceLog.configure()
```

> For a complete documentation set including user guides, a 100% documented API reference and many more examples, please see [https://tonystone.io/tracelog](https://tonystone.io/tracelog).

## Runtime Overhead

The **Swift** implementation was designed to take advantage of swift compiler optimizations and will incur **no overhead** when compiled with optimization on (`-O`) and `TRACELOG_DISABLED` is defined.

The **Objective-C** implementation was designed to take advantage of the preprocessor and when compiled with `TRACELOG_DISABLED` defined, will incur **no overhead** in the application.

For XCode `TRACELOG_DISABLED` can be set in the project target. For **Swift Package Manager** pass a swiftc directive to `swift build` as in the following example.

`swift build -Xswiftc -DTRACELOG_DISABLED`

## Minimum Requirements

Build Environment

| Platform | Version                    | Swift | Swift Build |   Xcode    |
|:--------:|:--------------------------:|:-----:|:-----------:|:----------:|
| Linux    | Ubuntu 14.04, 16.04, 16.10 | 5.0   | &#x2714;    | &#x2718;   |
| OSX      | 10.13                      | 5.0   | &#x2714;    | Xcode 10.x |

Minimum Runtime Version

| iOS |  OS X | tvOS | watchOS | Linux                      |
|:---:|:-----:|:----:|:-------:|:--------------------------:|
| 9.0 | 10.13 | 9.0  |   2.0   | Ubuntu 14.04, 16.04, 16.10 |

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

TraceLog is available through [CocoaPods](http://cocoapods.org). See the [Quick Start Guide](#Quick&#32;Start&#32;Guide) for installing through CocoaPods.

See the ["Using CocoaPods"](https://guides.cocoapods.org/using/using-cocoapods.html) guide for more information on CocoaPods itself.

## Author

Tony Stone ([https://github.com/tonystone](https://github.com/tonystone))

## License

TraceLog is released under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html)
