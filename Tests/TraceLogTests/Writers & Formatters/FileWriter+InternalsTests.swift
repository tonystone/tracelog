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

    let testConfig = FileConfiguration(directory: testDirectory, template: "'test-'yyyymmdd'.log'")

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
        /// Note: This test may fail on the unlikely event that it is run at exactly midnight.
        XCTAssertEqual(testConfig.newFileURL().path, testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: Date())).log").path)
    }

    // MARK: - latestFileURL tests

    func testLatestFileURLWhenFileExists() {
        fileManager.createFile(atPath: testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: referenceDate)).log").path, contents: Data())

        XCTAssertEqual(testConfig.latestFileURL(), testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: referenceDate)).log"))
    }

    func testLatestFileURLWhenMultipleFilesExists() {

        for n in 0..<10 {
            let fileDate = referenceDate.addingTimeInterval(TimeInterval(n * 86400))

            /// Sleep for a short period to allow creation time to change.
            //usleep(10000)
            sleep(1)

            fileManager.createFile(atPath: testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: fileDate)).log").path, contents: Data())
        }

        XCTAssertEqual(testConfig.latestFileURL(), testDirectory.appendingPathComponent("test-20190110.log"))
    }

    func testLatestFileURLWhenMultipleFilesExistsReversed() {

        for n in (0..<10).reversed() {
            let fileDate = referenceDate.addingTimeInterval(TimeInterval(n * 86400))

            /// Sleep for a short period to allow creation time to change.
            usleep(10000)

            fileManager.createFile(atPath: testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: fileDate)).log").path, contents: Data())
        }

        /// Note: The return value should be the latest by creation date not file name so since
        ///       we reversed the order above, test-20190101.log should be returned and not 20190110.
        ///
        XCTAssertEqual(testConfig.latestFileURL(), testDirectory.appendingPathComponent("test-20190101.log"))
    }

    func testLatestFileURLWhenNoFileExists() {
        /// Note: This test may fail on the unlikely event that it is run at exactly midnight.
        XCTAssertEqual(testConfig.latestFileURL(), testDirectory.appendingPathComponent("test-\(referenceFormatter.string(from: Date())).log"))
    }
}
