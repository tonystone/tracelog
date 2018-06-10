///
///  StaticContext.swift
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
///  Created by Tony Stone on 10/4/16.
///
import Swift

///
/// Static context captured at the time of the log statement
///
public protocol StaticContext {

    /// The file name with path component captured at the time the Log<level> func was called to log a message.
    var file: String { get }

    /// The function name of the calling func captured at the time the Log<level> func was called to log a message.
    var function: String { get }

    /// The line number captured at the time the Log<level> func was called to log a message.  Will be the line number of the log call.
    var line: Int { get }
}
