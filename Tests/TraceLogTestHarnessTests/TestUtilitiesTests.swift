///
///  TestUtilitiesTests.swift
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
///  Created by Tony Stone on 6/26/18.
///
import XCTest
import TraceLog

@testable import TraceLogTestHarness

@available(OSX 10.13, *)
final class TestUtilitiesTests: XCTestCase {

    func testShell() throws {

        #if !os(iOS) && !os(tvOS) && !os(watchOS)

            let testString = "Random test String."
            let testFile   = "TestFile.txt"
            let testURL    = URL(fileURLWithPath: testFile)

            try testString.write(to: testURL, atomically: true, encoding: .utf8)

            /// Read the file using shell
            let data = try shell("cat \(testFile)")

            XCTAssertEqual(String(data: data, encoding: .utf8), testString)

            try FileManager.default.removeItem(at: testURL)

        #endif
    }
}
