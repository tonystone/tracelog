///
///  BufferWriter.swift
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
/// A test `Writer` implementation that writes all logged messages to a buffer which can then be queried to analyze the results.
///
public class BufferWriter: Writer {

    ///
    /// A buffer to hold the values written to this writer.
    ///
    public var buffer: [String: Writer.LogEntry] = [:]

    /// Initialize an instance of `self` to its initial empty state.
    ///
    public init() {}

    ///
    /// Required write function for the `Writer`.
    ///
    public func write(_ entry: Writer.LogEntry) -> Result<Int,FailureReason> {
        self.buffer[entry.message] = entry

        return .success(0)
    }
}
