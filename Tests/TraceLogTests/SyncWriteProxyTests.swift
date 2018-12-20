///
///  SyncWriterProxyTests.swift
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
///  Created by Tony Stone on 12/17/18.
///
import XCTest
import TraceLogTestHarness

@testable import TraceLog

///
/// Test the SyncWriterProxy functionality.
///
class SyncWriterProxyTests: XCTestCase {

    func testAvailable() {

        class TestWriter: Writer {
            var available: Bool = true
            func log(_ timestamp: Double, level: LogLevel, tag: String, message: String, runtimeContext: RuntimeContext, staticContext: StaticContext) {}
        }

        let testWriter = TestWriter()

        // Test the default of the TestWriter which is `true`
        XCTAssertEqual(SyncWriterProxy(writer: testWriter).available, true)

        // Now set it to false to ensure it flows through
        testWriter.available = false
        XCTAssertEqual(SyncWriterProxy(writer: testWriter).available, false)
    }
}
