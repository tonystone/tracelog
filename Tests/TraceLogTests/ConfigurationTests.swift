///
///  ConfigurationTests.swift
///  TraceLog
///
///  Created by Tony Stone on 10/5/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///

import XCTest
@testable import TraceLog

class ConfigurationTests: XCTestCase {

    func testInit() {
        XCTAssertNotNil(Configuration())
    }

    func testLoad_Prefixes() {
        let configuration = Configuration(environment: ["LOG_PREFIX_NS": "TRACE4"])

        XCTAssertEqual(configuration.loggedPrefixes["NS"], LogLevel.trace4)
    }

    func testLoad_Tags() {
        let configuration = Configuration(environment: ["LOG_TAG_TestTag1": "TRACE4"])

        XCTAssertEqual(configuration.loggedTags["TestTag1"], LogLevel.trace4)
    }

    func testLogLevel_All_Default() {
        let configuration = Configuration()

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.info)
    }

    func testLogLevel_All_Set() {
        let configuration = Configuration(environment: ["LOG_ALL": "TRACE4"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace4)
    }

    func testLogLevel_All_Set_Off() {
        let configuration = Configuration(environment: ["LOG_ALL": "OFF"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.off)
    }

    func testLogLevel_All_Set_Error() {
        let configuration = Configuration(environment: ["LOG_ALL": "ERROR"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.error)
    }

    func testLogLevel_All_Set_Warning() {
        let configuration = Configuration(environment: ["LOG_ALL": "WARNING"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.warning)
    }

    func testLogLevel_All_Set_Info() {
        let configuration = Configuration(environment: ["LOG_ALL": "INFO"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.info)
    }

    func testLogLevel_All_Set_Trace1() {
        let configuration = Configuration(environment: ["LOG_ALL": "TRACE1"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace1)
    }

    func testLogLevel_All_Set_Trace2() {
        let configuration = Configuration(environment: ["LOG_ALL": "TRACE2"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace2)
    }

    func testLogLevel_All_Set_Trace3() {
        let configuration = Configuration(environment: ["LOG_ALL": "TRACE3"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace3)
    }

    func testLogLevel_All_Set_Trace4() {
        let configuration = Configuration(environment: ["LOG_ALL": "TRACE4"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace4)
    }

    func testLogLevel_All_Set_InvalidLevel() {
        let configuration = Configuration(environment: ["LOG_ALL": "INVALID"])

        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.info)
    }

    func testLogLevel_Prefix() {
        let configuration = Configuration(environment: ["LOG_PREFIX_NS": "TRACE4"])

        XCTAssertEqual(configuration.logLevel(for: "NSString"), LogLevel.trace4)
    }

    func testLogLevel_Tag() {
        let configuration = Configuration(environment: ["LOG_TAG_TestTag1": "TRACE4"])

        XCTAssertEqual(configuration.logLevel(for: "TestTag1"), LogLevel.trace4)
    }
}

extension ConfigurationTests {

   static var allTests: [(String, (ConfigurationTests) -> () throws -> Void)] {
      return [
                ("testInit", testInit),
                ("testLoad_Prefixes", testLoad_Prefixes),
                ("testLoad_Tags", testLoad_Tags),
                ("testLogLevel_All_Default", testLogLevel_All_Default),
                ("testLogLevel_All_Set", testLogLevel_All_Set),
                ("testLogLevel_All_Set_Off", testLogLevel_All_Set_Off),
                ("testLogLevel_All_Set_Error", testLogLevel_All_Set_Error),
                ("testLogLevel_All_Set_Warning", testLogLevel_All_Set_Warning),
                ("testLogLevel_All_Set_Info", testLogLevel_All_Set_Info),
                ("testLogLevel_All_Set_Trace1", testLogLevel_All_Set_Trace1),
                ("testLogLevel_All_Set_Trace2", testLogLevel_All_Set_Trace2),
                ("testLogLevel_All_Set_Trace3", testLogLevel_All_Set_Trace3),
                ("testLogLevel_All_Set_Trace4", testLogLevel_All_Set_Trace4),
                ("testLogLevel_All_Set_InvalidLevel", testLogLevel_All_Set_InvalidLevel),
                ("testLogLevel_Prefix", testLogLevel_Prefix),
                ("testLogLevel_Tag", testLogLevel_Tag)
           ]
   }
}
