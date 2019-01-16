///
///  OutputStream.swift
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
///  Created by Tony Stone on 12/29/18.
///
import Swift
import Foundation

///
/// Protocol defining a type which can write
/// a stream of bytes to its output.
///
internal protocol OutputStream {

    /// The current write position or number of bytes
    /// written to the stream.
    ///
    var position: UInt64 { get }

    /// Write the byte block to the output.
    ///
    /// - Parameter bytes: An array of UInt8 byes to output to the stream.
    ///
    /// - Returns: A Result<Int, OutputStreamError> value holding the number of bytes written if .successful or an OutputStreamError if failed.
    ///
    func write(_ bytes: [UInt8]) -> Result<Int, OutputStreamError>
}

/// Errors returned by OutputStreams
///
internal enum OutputStreamError: Error {

    /// The write failed for the reason given in Code and String.
    ///
    case writeFailed(Int32, String)
}
