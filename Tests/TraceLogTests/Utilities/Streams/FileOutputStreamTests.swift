///
///  FileOutputStreamTests.swift
///
///  Copyright 2019 Tony Stone
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
///  Created by Tony Stone on 1/18/19.
///
import XCTest

@testable import TraceLog

class FileOutputStreamTests: XCTestCase {

    // MARK: - Initialization Tests

    /// Test that a FileOutputStream can be creates using a file descriptor.
    ///
    func testInitWithFileDescriptor() {
        XCTAssertNotNil(FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))
    }

    /// Test that a FileOutputStream can be creates using a URL.
    ///
    func testInitWithURL() throws {
        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        XCTAssertNoThrow(try FileOutputStream(url: inputURL, options: [.create]))
    }

    /// Test that a FileOutputStream fails when given a URL of a file that does not exist.
    ///
    func testInitWithURLFailsWithInvalidURL() {
        let inputURL = self.temporaryFileURL()

        XCTAssertThrowsError(try FileOutputStream(url: inputURL, options: []), "Should throw but did not.") { error in
            switch error {
            case FileOutputStreamError.invalidURL(_):
                break
            default:
                XCTFail()
            }
        }
    }

    // MARK: - position tests

    /// Test that a FileOutputStream.position returns the correct value after writing to a file.
    ///
    func testPositionReturnsCorrectValueOnNormalFile() throws {
        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let stream = try FileOutputStream(url: inputURL, options: [.create])

        switch stream.write(Array<UInt8>(repeating: 255, count: 10)) {
        case .success(let written):
            XCTAssertEqual(written, 10)
        default:
            XCTFail()
        }

        XCTAssertEqual(stream.position, 10)
    }

    /// Test that a FileOutputStream.position returns 0 when given an invalid file descriptor.
    ///
    func testPositionReturnsZeroWhenGivenAnInvalidFD() {
        XCTAssertEqual(FileOutputStream(fileDescriptor: -1, closeFd: false).position, 0)
    }

    func testtestPositionReturnsZeroWhenAppliedToStandardOut() {
        XCTAssertEqual(FileOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false).position, 0)
    }

    func testtestPositionReturnsZeroWhenAppliedToStandardError() {
        XCTAssertEqual(FileOutputStream(fileDescriptor: STDERR_FILENO, closeFd: false).position, 0)
    }

    // MARK: write tests

    /// Test that a FileOutputStream.position returns the correct value after writing to a file.
    ///
    func testWriteToFile() throws {
        let inputBytes = Array<UInt8>(repeating: 128, count: 10)

        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let stream = try FileOutputStream(url: inputURL, options: [.create])

        switch stream.write(inputBytes) {
        case .success(let written):
            XCTAssertEqual(written, 10)
            XCTAssertEqual(try Data(contentsOf: inputURL), Data(inputBytes))
        default:
            XCTFail()
        }
    }

    func testWriteToFileWithFailedWriteOnClosedFile() throws {
        let inputBytes = Array<UInt8>(repeating: 128, count: 10)

        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let stream = try FileOutputStream(url: inputURL, options: [.create])

        /// Close the file so the write fails.
        stream.close()

        switch stream.write(inputBytes) {
        case .failure(.disconnected(let message)):
            XCTAssertEqual(message, "Bad file descriptor")
        default:
            XCTFail()
        }
    }

    // MARK: - Test helper functions

    private func temporaryFileURL() -> URL {

        let directory = NSTemporaryDirectory()
        let filename = "test-\(UUID().uuidString).bin"
        let fileURL = URL(fileURLWithPath: directory).appendingPathComponent(filename)

        // Return the temporary file URL for use in a test method.
        return fileURL
    }

    private func removeFileIfExists(url: URL) {
            do {
                let fileManager = FileManager.default
                // Check that the file exists before trying to delete it.
                if fileManager.fileExists(atPath: url.path) {
                    // Perform the deletion.
                    try fileManager.removeItem(at: url)
                    // Verify that the file no longer exists after the deletion.
                    XCTAssertFalse(fileManager.fileExists(atPath: url.path))
                }
            } catch {
                // Treat any errors during file deletion as a test failure.
                XCTFail("Error while deleting temporary file: \(error)")
            }
    }

    func testWritePerformance() throws {
        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let inputBytes = Array<UInt8>(repeating: 128, count: 128)

        let stream = try FileOutputStream(url: inputURL, options: [.create])

        self.measure {
            for _ in 0..<1000000 {

                switch stream.write(inputBytes) {
                case .success(_):
                    break
                default:
                    XCTFail()
                }
            }
        }
    }


}

