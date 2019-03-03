# Change Log
All significant changes to this project will be documented in this file.

## [5.0.0-beta.2](https://github.com/tonystone/tracelog/tree/5.0.0-beta.2)

#### Changed
- Renamed `AsyncOption` to `AsyncConcurrencyModeOption`.
- Changed `OutputStreamFormatter`, it now requires `var encoding: String.Encoding { get }`.
- Renamed `FileWriter.FileStrategy` to `FileWriter.Strategy`.
- Renamed `FileWriter.Strategy.RotateOption` to `FileWriter.Strategy.RotationOption`.

#### Updated
- `TextFormat` to add `var encoding: String.Encoding { get }` requirement.
- `JSONFormat` to add `var encoding: String.Encoding { get }` requirement.

## [5.0.0-beta.1](https://github.com/tonystone/tracelog/tree/5.0.0-beta.1)

#### Added
- Added `OutputStreamFormatter` protocol to define formatters for use with byte output stream type Writers.
- Added `TextFormat`, an implementation of a OutputStreamFormatter that formats its output based on a supplied template (this is the default formatter for Console and File output).
- Added `JSONFormat`, an implementation of a OutputStreamFormatter that formats its output in standard JSON format.
- Added `OutputStreamWriter` protocol to define types that write byte streams to their output and accept `OutputStreamFormatter` types to format the output.
- Added `LogEntry` tuple type to `Writer` defining the formal types that a Writer writes.
- Added `.buffer` option for `.async` concurrency modes to allow for buffering when the writer is not available to write to its endpoint.

#### Changed
- Requires Swift 5 for compilation.
- Changed parameters to `.async` to include options for configuration of the mode (`.async(options: Set<AsyncConcurrencyModeOption>)` and  `.async(Writer, options: Set<AsyncConcurrencyModeOption>)`).
- Changed `Writer` protocol `log()` method to `write(_ entry: Writer.LogEntry)` to make it easier to process messages by writers and formatters.
- Changed `Writer` return to `Swift.Result<Int, FailedReason>` to return instructions for TraceLog for buffering and error recovery.
- Changed `ConsoleWriter` to accept new `OutputStreamFormatter` instances allowing you to customize the output log format (default is `TextFormat`.)
- Changed `FileWriter` public interface
    * `FileWriter` now requires the log directory be passed in, removing default value of `./`.
    * Removed the `fileConfiguration` parameter replacing with new `strategy` enum.
    * It now accepts the new `OutputStreamFormatter` instances allowing you to customize the output log format (default is `TextFormat`.)
- Changed `FileWriter` archive file name date format to "yyyyMMdd-HHmm-ss-SSS" (This was done for maximum compatibility between platforms and can be overridden in the FileConfiguration object passed at init.)

#### Removed
- Removed  `TraceLogTestHarness`  module.

#### Fixed
- Fixed `logTrace` when no trace level is passed.  It's now the correct default value of 1 instead of 4 (issue #58).

## [4.0.1](https://github.com/tonystone/tracelog/tree/4.0.1)

#### Fixed
- Adding missing newline to `ConsoleWriter` output (issue #55).

## [4.0.0](https://github.com/tonystone/tracelog/tree/4.0.0)

#### Added
- Added mode to TraceLog.configuration to allow direct, async, or sync mode of operation. Sync & direct mode are useful for use cases that have short-lived processes (scripts) or require real-time logging.
- Added ability to set the concurrency mode individually for each Writer.
- Added `FileWriter` class for writing to local log files.
- Added `TestHarness` to assist developers in testing their own `Writer` types.
- Added `shell` utility to assist in testing `Writer` types.
- Added TraceLogTestTools module/library to allow use of new `TestHarness` and other Utilities.

#### Removed
- Removed all Xcode projects, Xcode projects are now generated using Swift Package Manager.
- Dropped iOS 8 support.

## [3.0.0](https://github.com/tonystone/tracelog/tree/3.0.0)

#### Updated
- Xcode projects to be swift 4.1 compatible.

#### Removed
- Removed deprecated `TLLogger.configure()`. Use TraceLog.configure in swift instead.
- Removed deprecated `TLLogger.configureWithEnvironment`.  Use TraceLog.configure in swift instead.


## [2.2.0](https://github.com/tonystone/tracelog/tree/2.2.0)

#### Updated
- Change build environment requirements to xcode9.2 / Swift 4.0.3 (note: this is just the build, targets are still the same).

## [2.1.0](https://github.com/tonystone/tracelog/tree/2.1.0)

#### Added
- Log level `OFF` to allow turning off logging for a specific level (global, prefix, tag).

## [2.0.2](https://github.com/tonystone/tracelog/tree/2.0.2)

#### Added
- Added required tests to bring coverage back to 100%.

#### Updated
- Deprecated TLLogger.configure and TLLogger.configureWithEnvironment.  Use TraceLog.configure in swift instead.
- Changed Vagrant file to include libpython2.7 required for Swift REPL.

#### Fixed
- Removed unnecessary String with formatters call that can result in a crash if the interpolated string includes formatter options that the String(format:) function will never have matching parameters for.

## [2.0.1](https://github.com/tonystone/tracelog/tree/2.0.1)
Released on 2016-10-16.

#### Added
- The `OS_ACTIVITY_MODE` environment variable to iOS and OSX Example.
- CHANGELOG.md

#### Updated
- Inline documentation for all public classes and functions.
- Combined TraceLog.configure func's into one with the same semantics as the 3 previous funcs.
- iOS example application converting it to Swift.

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
