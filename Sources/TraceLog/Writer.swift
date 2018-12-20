///
///  Writer.swift
///
///  Copyright 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 4/23/16.
///
import Swift

///
/// The Writer protocol defines the interface required when writing
/// a log writer for the **TraceLog** system. Log writers are used
/// to output all log<level> messages to an output device like
/// stdout, http endpoint, tcp/ip sockets, etc.
///
/// There are no constructor/init requirements so any init method can be defined
/// in your writer to initialize it prior to passing it to TraceLog.
///
/// ConsoleWriter is a concrete implementation of the Writer protocol and
/// can be used as a basic example of creating custom writers.
///
/// - seealso: ConsoleWriter
///
public protocol Writer {

    ///
    /// Called when the logger needs to log an event to this logger.
    ///
    /// - Parameters:
    ///     - timestamp:             Timestamp of the log event (number of seconds from 1970).
    ///     - level:                 The LogLevel of this logging event. Note: log will not be called if the LegLevel is not set to above this calls log level
    ///     - tag:                   The tag associated with the log event.
    ///     - message:               The message string (already formatted) for this logging event.
    ///     - file:                  The source file (of the calling program) of this logging event.
    ///     - runtimeContext:        An object containing information about the state of the runtime such as thread ID (seealso: RuntimeContext)
    ///     - staticContext:         An object containing the static information at the time of the func call such as function name and line number (seealso: StaticContext)
    ///
    /// - Seealso: LogLevel
    /// - Seealso: RuntimeContext
    /// - Seealso: StaticContext
    ///
    func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext)

    ///
    /// Is this Writer available for writing to its endpoint.
    ///
    /// - Example:
    ///     If you are a file type `Writer`, is the file open and accessible.
    ///     If a network endpoint, has the socket been established and is it writable.
    ///
    ///
    var available: Bool { get }
}

public extension Writer {

    ///
    /// Default implementation of available always assumes
    /// the Writer is available.
    ///
    var available: Bool { return true }
}
