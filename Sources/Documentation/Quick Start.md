# Quick Start Guide

Using TraceLog is incredibly simple out of the box.  Although TraceLog is highly configurable, to get started all you have to do is add the pod to your project,
import TraceLog to the files that require logging and start adding log statements where you need them.  TraceLog initializes itself and does everything else for you.

## Add TraceLog to your project

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

## Import TraceLog and Start logging

Import TraceLog into you files and start logging.

```swift
    import TraceLog

    struct MyClass {

        func doSomething() {

            LogInfo { "A simple TraceLog Test message" }
        }
    }
```

## Log Functions

TraceLog has the following primary logging functions to log various levels of information.  The output of these can be controlled via the environment variables at runtime or programmatically at application startup via the `TraceLog.configure()` func.

```swift
    logError  (tag: String?, message: @escaping () -> String)
    logWarning(tag: String?, message: @escaping () -> String)
    logInfo   (tag: String?, message: @escaping () -> String)
    logTrace  (tag: String?, level: UInt, message: @escaping () -> String)
    logTrace  (level: UInt, @escaping message: () -> String)
```
> Note: hidden parameters and defaults were omitted for simplicity.

## Basic Configuration

Although not strictly require, calling the `TraceLog.configure()` command at startup will allow TraceLog to read the environment for configuration information.

Simply call configure with no parameters as early as possible in your startup code (preferably before ay log statements get called.)

```swift
    TraceLog.configure()
```
