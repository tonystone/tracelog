//
//  ConfigurationTests.swift
//  TraceLog
//
//  Created by Tony Stone on 10/5/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//

import XCTest
@testable import TraceLog

class ConfigurationTests: XCTestCase {

    func testInit() {
        XCTAssertNotNil(Configuration())   
    }
    
    func testLoad_Prefixes() {
        let configuration = Configuration()
        
        let _ = configuration.load([], environment: ["LOG_PREFIX_NS" : "TRACE4"])

        XCTAssertEqual(configuration.loggedPrefixes["NS"], LogLevel.trace4)
    }
    
    func testLoad_Tags() {
        let configuration = Configuration()
        
        let _ = configuration.load([], environment: ["LOG_TAG_TestTag1" : "TRACE4"])
        
        XCTAssertEqual(configuration.loggedTags["TestTag1"], LogLevel.trace4)
    }
    
    func testLogLevel_All_Default() {
        let configuration = Configuration()
        
        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.info)
    }
    
    func testLogLevel_All_Set() {
        let configuration = Configuration()
        
        let _ = configuration.load([], environment: ["LOG_ALL" : "TRACE4"])
        
        XCTAssertEqual(configuration.logLevel(for: "AnyString"), LogLevel.trace4)
    }
    
    func testLogLevel_Prefix() {
        let configuration = Configuration()
        
        let _ = configuration.load([], environment: ["LOG_PREFIX_NS" : "TRACE4"])
        
        XCTAssertEqual(configuration.logLevel(for: "NSString"), LogLevel.trace4)
    }

    func testLogLevel_Tag() {
        let configuration = Configuration()
        
        let _ = configuration.load([], environment: ["LOG_TAG_TestTag1" : "TRACE4"])
        
        XCTAssertEqual(configuration.logLevel(for: "TestTag1"), LogLevel.trace4)
    }
    
}
