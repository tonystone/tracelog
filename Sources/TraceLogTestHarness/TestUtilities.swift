///
///  TestUtilities.swift
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
///  Created by Tony Stone on 6/16/18.
///
import Foundation
import XCTest

#if os(macOS) || os(Linux)

///
/// Helper to run the shell and return the output
///
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public func shell(_ command: String) -> Data {
    let task = Process()
    task.launchPath = "/bin/bash"
    task.arguments = ["-c", command]

    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()

    return pipe.fileHandleForReading.readDataToEndOfFile()
}

#endif
