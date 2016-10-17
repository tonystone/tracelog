# Change Log
All significant changes to this project will be documented in this file.

## [2.0.1](https://github.com/tonystone/tracelog/tree/2.0.1)
Released on 2016-10-16. 

#### Added
- The `OS_ACTIVITY_MODE` environment variable to iOS and OSX Example.
- CHANGELOG.md

#### Updated
- Inline documentation for all public classes and functions.
- Combined TraceLog.configure func's into one with the same symantics as the 3 previous funcs.

#### Fixed
- Cocoadocs documentation creation.

## [2.0.0](https://github.com/tonystone/tracelog/tree/2.0.0)
Released on 2016-10-15.

#### Added

- Installable Writers to allow custom writers to be used to write to various output devices/end points such as HTTP services, sys log, files, etc
- Ability to configure the environment statically at the beginning of the application
- **Swift 3** Compatibility
- **Swift Package Manager** support
- **Linux** support
- Now written in Swift 3
