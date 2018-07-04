///
///  FileWriter+InternalsTests.swift
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
///  Created by Tony Stone on 6/27/18.
///
import XCTest
import TraceLogTestHarness

@testable import TraceLog

///
/// Direct Logging to the Logger
///
class FileWriterInternalsTests: XCTestCase {

    func testOpen() {
        let input = open(fileURL: URL(fileURLWithPath: "./test.log"), fallbackHandle: FileHandle.standardOutput)

        XCTAssertNotEqual(input, FileHandle.standardOutput)

        close(fileHandle: input)
    }

    func testOpenForcingFallback() {
        XCTAssertEqual(open(fileURL: URL(fileURLWithPath: "NonExistentDirectory/test.log"), fallbackHandle: FileHandle.standardOutput), FileHandle.standardOutput)
    }

    func testRotate() throws {
        let handle = open(fileURL: URL(fileURLWithPath: "./test.log"), fallbackHandle: FileHandle.standardOutput)

        let logFile: FileWriter.LogFile = (handle: handle, config: FileWriter.FileConfiguration(name: "test.log", directory: "./"))

        XCTAssertNotEqual(rotate(file: logFile, fallbackHandle: FileHandle.standardOutput, dateFormatter: DateFormatter()).handle, FileHandle.standardOutput)
    }

    func testRotateForcingFallback() throws {
        let handle = open(fileURL: URL(fileURLWithPath: "./test.log"), fallbackHandle: FileHandle.standardOutput)

        let logFile: FileWriter.LogFile = (handle: handle, config: FileWriter.FileConfiguration(name: "test.log", directory: "NoExistentDirectory"))

        XCTAssertEqual(rotate(file: logFile, fallbackHandle: FileHandle.standardOutput, dateFormatter: DateFormatter()).handle, FileHandle.standardOutput)
    }
}

extension FileWriterInternalsTests {
    static var allTests: [(String, (FileWriterInternalsTests) -> () throws -> Void)] {
        return [
            ("testOpen", testOpen),
            ("testOpenForcingFallback", testOpenForcingFallback),
            ("testRotateForcingFallback", testRotateForcingFallback)
        ]
    }
}
