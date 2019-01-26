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

private let testDirectory = "FileWriterInternalsTestsTmp"

///
/// Direct Logging to the Logger
///
class FileWriterInternalsTests: XCTestCase {

    override func setUp() {
        do {
            /// Create the test directory
            try FileManager.default.createDirectory(atPath: testDirectory, withIntermediateDirectories: false)
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    override func tearDown() {
        do {
            if FileManager.default.fileExists(atPath: testDirectory) {
                try FileManager.default.removeItem(atPath: testDirectory)
            }
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    func testOpen() {
        let input = open(fileURL: URL(fileURLWithPath: "\(testDirectory)/test.log"), fallbackStream: FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))

        XCTAssertNotEqual(input, FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))

        close(fileStream: input)
    }

    func testOpenCreatingDirectory() throws {
        let fileManager = FileManager.default

        if fileManager.fileExists(atPath: testDirectory) {
            try fileManager.removeItem(atPath: testDirectory)
        }

        /// It should not fallback to the fallback stream:
        XCTAssertNotEqual(open(fileURL: URL(fileURLWithPath: "\(testDirectory)/test.log"), fallbackStream: FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false)), FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))
        XCTAssertTrue(fileManager.fileExists(atPath: "\(testDirectory)/test.log"))
    }

    func testOpenFailure() throws {

        /// It should be the fallback file stream:
        XCTAssertEqual(open(fileURL: URL(fileURLWithPath: "file://dev/null"), fallbackStream: FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false)), FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))
    }

    ///
    /// Test rotation of a file.
    ///
    func testRotate() throws {
        let stream = open(fileURL: URL(fileURLWithPath: "\(testDirectory)/test.log"), fallbackStream: FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))

        let logFile: FileWriter.LogFile = (stream: stream, config: FileWriter.FileConfiguration(name: "test.log", directory: testDirectory))

        ///
        /// Note: This tests ensures it does not fallback to the fallback stream:r.
        ///
        XCTAssertNotEqual(rotate(file: logFile, fallbackStream: FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false), dateFormatter: FileWriter.Default.fileNameDateFormatter).stream, FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))

       /// And of course we make sure the file was created.
        XCTAssertTrue(try archiveExists(fileName: "test", fileExt: "log", directory: testDirectory))
    }

    ///
    /// Test failing rotation behavior.
    ///
    func testRotateFailure() throws {
        let fallbackPath = "\(testDirectory)/fallbackFile.log"

        let fallbackStream = try { () throws -> FileOutputStream in
            _ = FileManager.default.createFile(atPath: fallbackPath, contents: Data(), attributes: nil)
            return try FileOutputStream(url: URL(fileURLWithPath: fallbackPath))
        }()

        let logFile: FileWriter.LogFile = (stream: try open(fileURL: URL(fileURLWithPath: "\(testDirectory)/test.log")), config: FileWriter.FileConfiguration(name: "test.log", directory: testDirectory))

        /// Remove the test file so the next step (rotation) fails to find it.
        try FileManager.default.removeItem(atPath: "\(testDirectory)/test.log")

        XCTAssertNotEqual(rotate(file: logFile, fallbackStream: fallbackStream, dateFormatter: DateFormatter()).stream, fallbackStream)

        fallbackStream.close()

        let message = try String(contentsOf: URL(fileURLWithPath: fallbackPath))

        XCTAssertNotNil(message.range(of: "^Failed to archive, file does not exist: .*\(testDirectory)/test.log$", options: [.regularExpression, .anchored]))
    }
}
