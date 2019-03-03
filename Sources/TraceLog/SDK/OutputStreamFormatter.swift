///
///  OutputStreamFormatter.swift
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
///  Created by Tony Stone on 12/26/18.
///
import Foundation

/// A formatter type for formating the output of a `OutputStreamWriter` type.
///
/// OutputStreamFormatter have one purpose in life, to convert a `Writer.LogEntry` into a formatted collection of bytes.
///
/// - SeeAlso: `TextFormat` for concrete implementation of an `OutputStreamFormatter`.
/// - SeeAlso: `JSONFormat` for concrete implementation of an `OutputStreamFormatter`.
///
public protocol OutputStreamFormatter {

    // MARK: Properties

    /// The encoding that will be used to encode the `message` attribute of the `Writer.LogEntry` and the entire message if this is a String type output.
    ///
    var encoding: String.Encoding { get }

    // MARK: Formatting Input

    /// Accepts traceLogs standard LogEntry and outputs an Array of bytes
    /// containing the formatted output.
    ///
    /// - Parameter entry: A `Writer.LogEntry` to format and convert to a byte collection.
    ///
    /// - Returns: A `Result<[UInt8], OutputStreamFormatterError>` with a success value of the formatted byte collection and on error an `OutputStreamFormatterError` value.
    ///
    /// - SeeAlso: `OutputStreamFormatterError` for error values that can be returned.
    ///
    func bytes(from entry: Writer.LogEntry) -> Result<[UInt8], OutputStreamFormatterError>
}

/// Allowable Errors returned from `OutputStreamFormatter`.`bytes(from:)` methods.
///
public enum OutputStreamFormatterError: Error {

    /// There was a failure attempting to encode the `Writer.LogEntry` to the `encoding`.
    ///
    case encodingFailure(String)
}
