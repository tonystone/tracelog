# TraceLog

[![CI Status](http://img.shields.io/travis/tonystone/TraceLog.svg?style=flat)](https://travis-ci.org/tonystone/TraceLog)
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
by CLASS name using the `LOG_CLASS_<CLASSNAME>` environment variable pattern,
and/or by a CLASS group by using the `CLASS_PREFIX_<CLASSPREFIX>` environment
variable pattern.

## Configuration

Each environment variable set is set with a level as the value.  The following
levels are available in order of display priority.  Each level encompasses the
level below it with TRACE4 including the output from every level.  The lowest
level setting, aside from no output or OFF, is ERROR which only output errors when
they occur.

Levels:

        `TRACE4`
        `TRACE3`
        `TRACE2`
        `TRACE1`
        `INFO`
        `WARNING`
        `ERROR`
        `OFF`

Environment Variables and syntax:

        `LOG_CLASS_<CLASSNAME>=<LEVEL>`
        `LOG_PREFIX_<CLASSPREFIX>=<LEVEL>`
        `LOG_ALL=<LEVEL>`


Multiple Environment variables can be set at one time to get the desired level
of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of TRACE logging for the ClimateSecurity module
which has a class prefix of CS and you wanted to see only errors and warnings for
the rest of the application.  You would set the following:

        `LOG_ALL=WARNING`
        `LOG_PREFIX_CS=TRACE1`

More specific settings override less specific so in the above example the less specific
setting is LOG_ALL which is set to WARNING.  The class prefix is specifying a particular
collection of classes that start with the string CS so this is more specific and overrides
the LOG_ALL.  If you chose to name a specific class, that would override the prefix settings.

For instance, in the example above, if we decided for one class in the ClimateSecurity module
we needed more output, we could set the following

        LOG_ALL=WARNING
        LOG_PREFIX_CS=TRACE1
        LOG_CLASS_CSManager=TRACE4

This outputs the same as the previous example with the exception of the CSManager class
which is set to TRACE4 instead of using the less specific TRACE1 setting in LOG_PREFIX.

## Configuring Xcode for logging

In Xcode select "Edit Scheme" from the "Set the active scheme" menu at the top left.  This will 
bring up the menu below.  Use the instructions above to set the enviroment variables you require 
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

