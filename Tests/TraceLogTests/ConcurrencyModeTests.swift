///
///  ConcurrencyMode.swift
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
///  Created by Tony Stone on 1/25/19.
///
import XCTest

@testable import TraceLog

class ConcurrencyModeTests: XCTestCase {

    class TestWriter: Writer {
        func write(_ entry: Writer.LogEntry) -> Result<Int, FailureReason> {
            return .success(0)
        }
    }

    // MARK: - Public Interface Compatibility Tests

    /// Note: These tests failing to compile or return the correct values
    ///       indicates that a change has been made to the interface that
    ///       is not backward compatible.  This test is meant to raise
    ///       that awareness of that so that proper documentation is
    ///       created for the users of the library.

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testConcurrencyModeDirectDefaultParameters() {
        guard case ConcurrencyMode.direct = ConcurrencyMode.direct
            else { XCTFail(); return }
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testConcurrencyModeSyncDefaultParameters() {
        guard case ConcurrencyMode.sync = ConcurrencyMode.sync
            else { XCTFail(); return }
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testConcurrencyModeAsyncDefaultParameters() {
        guard case ConcurrencyMode._async(options: []) = ConcurrencyMode.async()
            else { XCTFail(); return }
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testWriterConcurrencyModeDirectDefaultParameters() {
        guard case WriterConcurrencyMode.direct(let writer) = WriterConcurrencyMode.direct(TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(writer is TestWriter)
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testWriterConcurrencyModeSyncDefaultParameters() {
        guard case WriterConcurrencyMode.sync(let writer) = WriterConcurrencyMode.sync(TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(writer is TestWriter)
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testWriterConcurrencyModeAsyncDefaultParameters() {
        guard case WriterConcurrencyMode._async(let writer, options: []) = WriterConcurrencyMode.async(TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(writer is TestWriter)
    }

    /// Simulate the user creating an instance without passing parameters
    /// expecting to get the default parameters and behavior.
    ///
    func testAsyncConcurrencyModeOptionBufferDefaultParameters() {
        guard case AsyncConcurrencyModeOption._buffer(writeInterval: .seconds(60), .dropTail(at: 1000)) = AsyncConcurrencyModeOption.buffer()
            else { XCTFail(); return }
    }

    // MARK: - Test AsyncConcurrencyModeOption equals

    func testAsyncConcurrencyModeOptionEquals() {
        XCTAssertEqual(AsyncConcurrencyModeOption.buffer(writeInterval: .seconds(1), strategy: .expand), AsyncConcurrencyModeOption.buffer(writeInterval: .milliseconds(23), strategy: .dropHead(at: 1)))
    }

    // MARK: - ConcurrencyMode.writerMode tests

    func testWriterModeDirect() {
        guard case WriterConcurrencyMode.direct(let result) = ConcurrencyMode.direct.writerMode(for: TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(result is TestWriter)
    }

    func testWriterModeSync() {
        guard case WriterConcurrencyMode.sync(let result) = ConcurrencyMode.sync.writerMode(for: TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(result is TestWriter)
    }

    func testWriterModeAsync() {
        let input: Set<AsyncConcurrencyModeOption> = [.buffer(writeInterval: .seconds(1), strategy: .expand)]

        guard case WriterConcurrencyMode._async(let result, let options) = ConcurrencyMode.async(options: input).writerMode(for:  TestWriter())
            else { XCTFail(); return }

        XCTAssertTrue(result is TestWriter)
        XCTAssertEqual(options, input)
    }

    // MARK: WriterConcurrencyMode.proxy tests

    func testWriterConcurrencyModeProxyDirect() {
        XCTAssertTrue(WriterConcurrencyMode.direct(TestWriter()).proxy() is DirectWriterProxy)
    }

    func testWriterConcurrencyModeProxySync() {
        XCTAssertTrue(WriterConcurrencyMode.sync(TestWriter()).proxy() is SyncWriterProxy)
    }

    func testWriterConcurrencyModeProxyAsync() {
        XCTAssertTrue(WriterConcurrencyMode.async(TestWriter(), options: [.buffer(writeInterval: .seconds(1), strategy: .expand)]).proxy() is AsyncWriterProxy)

    }
}
