///
///  ByteOutputWriter.swift
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

/// ByteOutputStreamWriter
///
/// A higher level Writer interface that specifically writes to
/// a `ByteOutputStream` and it's output format can be controlled
/// by a `ByteOutputFormatter`.
///
/// - SeeAlso: `ByteOutputFormatter`
///
public protocol ByteOutputWriter: Writer {

    /// ByteOutputFormatter being used for formating output.
    ///
    var format: ByteOutputFormatter { get }
}
