# TraceLog

[![Build Status](https://travis-ci.org/tonystone/tracelog.svg?branch=master)](https://travis-ci.org/tonystone/tracelog)
[![Version](https://img.shields.io/cocoapods/v/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)
[![License](https://img.shields.io/cocoapods/l/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)
[![Platform](https://img.shields.io/cocoapods/p/TraceLog.svg?style=flat)](http://cocoadocs.org/docsets/TraceLog)


## Introduction
    
TraceLog is a runtime configurable debug logging system.  It allows flexible
configuration via environment variables at run time which allows each developer
to configure log output per session based on the debugging needs of that session.

When compiled in a RELEASE build, TraceLog is compiled out and has no overhead at
all in the application.

Log output can be configured globally using the `LOG_ALL` environment variable,
by TAG name using the `LOG_TAG_<TAGNAME>` environment variable pattern,
and/or by a TAG prefix by using the `LOG_PREFIX_<TAGPREFIX>` environment
variable pattern.

## Usage (Swift)

Using TraceLog is extremely simple out of the box.  Although TraceLog is highly 
configurable, to get started all you have to do is add the pod to your project 
and start adding log statements where you need them.  TraceLog initializes and 
does everything else for you. 


For Swift Tracelog comes with the following basic Logging functions (Note: hidden 
parameters and defaults where omitted for simplicity).

```Swift
    logError  (tag: String? , message: () -> String)
    logWarning(tag: String?, message: () -> String)
    logInfo   (tag: String?, message: () -> String)
    logTrace  (tag: String?, level: UInt, message: () -> String)
    logTrace  (level: UInt, message: () -> String)
```

Using it is as simple as calling one of the methods depending on the current type of 
message you want to log, for instance to log a simple informational message.

```Swift
   logInfo { "A simple informational message" }
```

Since the message parameter is a closure that evaluates to a String any expression 
that results in a string message can be use.

```Swift
   logInfo { 
        "A simple informational message" + 
        " and another expression or constant that evaluates to a string" 
   }
```

We used closures for several reasons, one is that the closure will not be evaluated (and you wont incur the overhead) 
if logging is disabled or if the log level for this call is higher then the current log level set. And two, more complex
expressions can be put into the closure to make decisions on the message to be printed based on the current context of
of the call.  Again, these complex closures will not get executes in the cases mentioned above.  For instance.

```Swift
    logInfo { 
         
         if unwrappedOptionalString = optionalString {
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
   logInfo("MyCustomTag") { "A simple informational message" }
```

## Configuration

Each environment variable set is set with a level as the value.  The following
levels are available in order of display priority.  Each level encompasses the
level below it with `TRACE4` including the output from every level.  The lowest
level setting, aside from no output or `OFF`, is `ERROR` which only output errors when
they occur.

Levels:
```
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
```
    LOG_TAG_<TAGNAME>=<LEVEL>
    LOG_PREFIX_<TAGPREFIX>=<LEVEL>
    LOG_ALL=<LEVEL>
```

Multiple Environment variables can be set at one time to get the desired level
of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of `TRACE` logging for the ClimateSecurity module
which has a class prefix of CS and you wanted to see only errors and warnings for
the rest of the application.  You would set the following:

```
    LOG_ALL=WARNING
    LOG_PREFIX_CS=TRACE1
```

More specific settings override less specific so in the above example the less specific
setting is `LOG_ALL` which is set to `WARNING`.  The class prefix is specifying a particular
collection of classes that start with the string CS so this is more specific and overrides
the `LOG_ALL`.  If you chose to name a specific class, that would override the prefix settings.

For instance, in the example above, if we decided for one class in the ClimateSecurity module
we needed more output, we could set the following
```
    LOG_ALL=WARNING
    LOG_PREFIX_CS=TRACE1
    LOG_TAG_CSManager=TRACE4
```
This outputs the same as the previous example with the exception of the `CSManager` class
which is set to `TRACE4` instead of using the less specific `TRACE1` setting in `LOG_PREFIX`.

## Configuring Xcode for logging

In Xcode select "Edit Scheme" from the "Set the active scheme" menu at the top left.  This will 
bring up the menu below.  Use the instructions above to set the environment variables you require 
for your debugging session.

<img src=Docs/Xcode-environment-setup-screenshot.png width=597 height=361 />

## Installation

TraceLog is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "TraceLog"
```

See the ["Using CocoaPods"](https://guides.cocoapods.org/using/using-cocoapods.html) guide for more information.

## Author

Tony Stone ([https://github.com/tonystone] (https://github.com/tonystone))

## License

TraceLog is released under the [Apache License, Version 2.0] (http://www.apache.org/licenses/LICENSE-2.0.html)

