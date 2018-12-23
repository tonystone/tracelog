///
///  BufferReader.swift
///
///  Copyright 2018 Tony Stone
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
///  Created by Tony Stone on 6/25/18.
///
import TraceLog

///
/// A test `Reader` implementation that reads the `BufferWriter`s buffer for validating results.
///
public class BufferReader: Reader {

    /// Initialize an intance of `self` to its initial empty state.
    ///
    public init() {}

    public func logEntry(for writer: BufferWriter, timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) -> LogEntry? {

        guard let logEntry = writer.buffer[message]
            else { return nil }

        return LogEntry(timestamp: logEntry.timestamp,
                            level: logEntry.level,
                          message: logEntry.message,
                              tag: logEntry.tag,
                             file: logEntry.staticContext.file,
                         function: logEntry.staticContext.function,
                             line: logEntry.staticContext.line,
                      processName: logEntry.runtimeContext.processName,
                processIdentifier: logEntry.runtimeContext.processIdentifier,
                 threadIdentifier: Int(logEntry.runtimeContext.threadIdentifier))
   }
}
