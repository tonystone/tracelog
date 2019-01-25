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

public enum OutputStreamFormatterError: Error {
    
    case encodingFailure(String)
}

/// A formatter type for formating the output of a `Writer` type.
///
public protocol OutputStreamFormatter {

    /// Accepts traceLogs standard LogEntry and outputs an Array of bytes
    /// containing the formatted output.
    ///
    func bytes(from entry: Writer.LogEntry) -> Result<[UInt8], OutputStreamFormatterError>
}
