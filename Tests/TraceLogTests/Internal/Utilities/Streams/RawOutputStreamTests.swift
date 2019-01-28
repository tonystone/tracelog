///
///  RawOutputStreamTests.swift
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
///  Created by Tony Stone on 1/27/19.
///
import XCTest

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    import Darwin
#elseif os(Linux) || CYGWIN
    import Glibc
#endif


@testable import TraceLog

class RawOutputStreamTests: XCTestCase {

    // MARK: - Init tests
    
    /// Test that a FileOutputStream can be creates using a file descriptor.
    ///
    func testInitWithFileDescriptor() {
        XCTAssertNotNil(RawOutputStream(fileDescriptor: STDOUT_FILENO, closeFd: false))
    }

    // MARK: write tests

    func testWriteToFile() throws {
        let inputBytes = Array<UInt8>(repeating: 128, count: 10)

        try self._testWrite(with: inputBytes)
    }

    func testWriteWithSystemPageSizes() throws {

        let pageSizes = [1024, 4 * 1024, Int(PIPE_BUF)]

        for size in pageSizes {
            try self._testWrite(with: Array<UInt8>(repeating: 128, count: size))
        }
    }

    func testWriteWithJustOverSystemPageSizes() throws {

        let pageSizes = [1024, 4 * 1024, Int(PIPE_BUF)]

        for size in pageSizes {
            try self._testWrite(with: Array<UInt8>(repeating: 128, count: size + 1))
        }
    }

    func testWriteWithLargeWrites() throws {

        try self._testWrite(with: Array<UInt8>(repeating: 128, count: 1024 * 1024 + 1))
    }

    private func _testWrite(with bytes: [UInt8], file: StaticString = #file, line: UInt = #line) throws {

        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let fd = inputURL.path.withCString { open($0, O_WRONLY | O_APPEND | O_CREAT, (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) }
        guard fd > 0
            else { XCTFail("Failed to open input file \(inputURL.path) for test."); return }

        let stream = RawOutputStream(fileDescriptor: fd, closeFd: true)

        switch stream.write(bytes) {
        case .success(let written):
            XCTAssertEqual(written, bytes.count, file: file, line: line)
            XCTAssertEqual(try Data(contentsOf: inputURL), Data(bytes), file: file, line: line)
        default:
            XCTFail(file: file, line: line)
        }
    }

    func testThatConcurrentMultipleWritesDontProducePartialWrites() throws {
        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let fd = inputURL.path.withCString { open($0, O_WRONLY | O_APPEND | O_CREAT, (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) }
        guard fd > 0
            else { XCTFail("Failed to open input file \(inputURL.path) for test."); return }

        let stream = RawOutputStream(fileDescriptor: fd, closeFd: true)

        /// Note: 10 iterations seems to be the amount of concurrent
        ///       runs Dispatch will give us so we limit it to that and
        ///       instead have each block write many times.
        ///
        DispatchQueue.concurrentPerform(iterations: 10) { (iteration) in

            for writeNumber in 0..<5000 {

                /// Random delay between writes
                usleep(UInt32.random(in: 1...1000))

                let iterationMessage = "Iteration \(iteration), write \(writeNumber)"

                let bytes = Array("\(iterationMessage).".utf8)

                switch stream.write(bytes) {
                case .success(let written):
                    XCTAssertEqual(written, bytes.count, "\(iterationMessage): failed byte count test.")
                default:
                    XCTFail("\(iterationMessage): failed.")
                }
            }
        }
    }

    func testThatConcurrentMultipleWritesDontProduceInterleaving() throws {

        try self._testInterleaving(inputString: "This text string should not be interleaved and should have a newline at the end.")
    }

    func testThatConcurrentMultipleWritesDontProduceInterleavingWithLargeWrites() throws {

        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let length  = 1024 * 1024 + 1

        let input = String((0...length).compactMap{ _ in letters.randomElement() })

        try self._testInterleaving(inputString: input, writes: 10)
    }

    func _testInterleaving(inputString: String, workers: Int = 10, writes: Int = 5000, file: StaticString = #file, line: UInt = #line) throws {

        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let fd = inputURL.path.withCString { open($0, O_WRONLY | O_APPEND | O_CREAT, (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) }
        guard fd > 0
            else { XCTFail("Failed to open input file \(inputURL.path) for test."); return }

        let stream = RawOutputStream(fileDescriptor: fd, closeFd: true)

        /// Note: 10 iterations seems to be the amount of concurrent
        ///       runs Dispatch will give us so we limit it to that and
        ///       instead have each block write many times.
        ///
        DispatchQueue.concurrentPerform(iterations: workers) { (iteration) in
            for _ in 0..<writes {
                /// Random delay between writes
                usleep(UInt32.random(in: 1...1000))

                _ = stream.write(Array("\(inputString)\n".utf8))
            }
        }

        let reader = try TextFileLineReader(url: inputURL, encoding: .utf8)

        var interleaved = 0
        var lineCount   = 0

        /// Loop through each line looking for interleaved lines.
        while let line = reader.next() {
            if line.count > 0 {
                lineCount += 1
                if line != inputString {
                    interleaved += 1
                }
            }
        }
        XCTAssertEqual(lineCount, workers * writes, file: file, line: line)
        XCTAssertEqual(interleaved, 0, "File contains \(interleaved) lines.", file: file, line: line)
    }

    func testWriteThrowsOnAClosedFileDescriptor() throws {
        let inputBytes = Array<UInt8>(repeating: 128, count: 10)

        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let fd = inputURL.path.withCString { open($0, O_WRONLY | O_APPEND | O_CREAT, (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) }
        guard fd > 0
            else { XCTFail("Failed to open input file \(inputURL.path) for test."); return }

        let stream = RawOutputStream(fileDescriptor: fd, closeFd: true)

        /// Close the file so the write fails.
        stream.close()

        switch stream.write(inputBytes) {
        case .failure(.disconnected(let message)):
            XCTAssertEqual(message, "Bad file descriptor")
        default:
            XCTFail()
        }
    }

    func testWritePerformance() throws {
        let inputURL = self.temporaryFileURL()
        defer { self.removeFileIfExists(url: inputURL) }

        let inputBytes = Array<UInt8>(repeating: 128, count: 128)

        let fd = inputURL.path.withCString { open($0, O_WRONLY | O_APPEND | O_CREAT, (S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)) }
        guard fd > 0
            else { XCTFail("Failed to open input file \(inputURL.path) for test."); return }

        let stream = RawOutputStream(fileDescriptor: fd, closeFd: true)

        self.measure {
            for _ in 0..<100000 {

                switch stream.write(inputBytes) {
                case .success(_):
                    break
                default:
                    XCTFail()
                }
            }
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
}
