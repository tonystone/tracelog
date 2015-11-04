//
//  TraceLogTests.swift
//  TraceLog
//
//  Created by Tony Stone on 11/1/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import XCTest
import TraceLog


class TraceLogTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testError() {
        logError("Swift: Error test");
    }
    
    func testWarning() {
        logWarning("Swift: Warning test");
    }

    func testInfo() {
        logInfo("Swift: Info test");
    }
    
    func testTrace() {
        logTrace("Swift: Trace1 test - no level");
    }
    
    func testTrace1() {
        logTrace("Swift: Trace1 test", level: 1);
    }

    func testTrace2() {
        logTrace("Swift: Trace2 test", level: 2);
    }
    
    func testTrace3() {
        logTrace("Swift: Trace3 test", level: 3);
    }
    
    func testTrace4() {
        logTrace("Swift: Trace4 test", level: 4);
    }
    
}
