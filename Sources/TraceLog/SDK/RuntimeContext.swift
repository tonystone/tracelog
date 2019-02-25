///
///  RuntimeContext.swift
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
/// Runtime context captured at the time of the log statement
///
public protocol RuntimeContext: CustomStringConvertible {

    /// The name of the current process.
    var processName: String { get }

    /// The identifier of the  current process (often called process ID).
    var processIdentifier: Int { get }

    /// The current threads identifier.
    var threadIdentifier: UInt64 { get }
}

public extension RuntimeContext {

    var description: String {
        return "RuntimeContext {processName: \"\(self.processName)\", processIdentifier: \(self.processIdentifier), threadIdentifier: \(self.threadIdentifier)}"
    }
}
