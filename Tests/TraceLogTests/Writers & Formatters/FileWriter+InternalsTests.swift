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

@testable import TraceLog

private var testDirectory: URL = {
    return URL(fileURLWithPath: FileManager.default.currentDirectoryPath).appendingPathComponent("FileWriterInternalsTestsTmp")
}()

let referenceFormatter = { () -> DateFormatter in
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyymmdd"

    return formatter
}()

let referenceDate = referenceFormatter.date(from: "20190101")!

///
/// Direct Logging to the Logger
///
class FileWriterInternalsTests: XCTestCase {

    let fileManager = FileManager.default

    override func setUp() {
        do {
            /// Create the test directory
            try FileManager.default.createDirectory(at: testDirectory, withIntermediateDirectories: false)
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    override func tearDown() {
        do {
            if FileManager.default.fileExists(atPath: testDirectory.path) {
                try FileManager.default.removeItem(at: testDirectory)
            }
        } catch {
            XCTFail("Failed to cleanup log files before test: \(error).")
        }
    }

    // MARK: - newUniqueFileURL tests

    func testNewFileURL() {
        let testFileStreamManager = FileStreamManager(directory: testDirectory, template: "'test-'yyyymmdd'.log'")

        /// Note: This test may fail on the unlikely event that it is run at exactly midnight.
        XCTAssertEqual(testFileStreamManager.newFileURL().path, testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: Date())).log").path)
    }

    // MARK: - latestFileURL tests

    func testLatestFileURLWhenFileExists() throws {
        let testFileStreamManager = FileStreamManager(directory: testDirectory, template: "'test-'yyyymmdd-hhmm-ss.SSSS'.log'")
        let url: URL

        /// Use a block that will go out of scope.
        do {
            let stream = try testFileStreamManager.openNewFileStream()
            url = stream.url

            stream.close()
        }
        XCTAssertEqual(testFileStreamManager.latestFileURL(), url)
    }

    func testLatestFileURLWhenMultipleFilesExists() throws {
        let testFileStreamManager = FileStreamManager(directory: testDirectory, template: "'test-'yyyymmdd-hhmm-ss.SSSS'.log'")
        var lastURL: URL = URL(fileURLWithPath: "//dev/null")

        for _ in 1...10 {
            let stream = try testFileStreamManager.openNewFileStream()
            lastURL = stream.url

            /// Sleep for a short period to allow creation time to change.
            usleep(10000)
        }
        XCTAssertEqual(testFileStreamManager.latestFileURL(), lastURL)
    }

    func testLatestFileURLWhenNoFileExists() {
        let testFileStreamManager = FileStreamManager(directory: testDirectory, template: "'test-'yyyymmdd'.log'")

        /// Note: This test may fail on the unlikely event that it is run at exactly midnight.
        XCTAssertEqual(testFileStreamManager.latestFileURL(), testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: Date())).log"))
    }
}
