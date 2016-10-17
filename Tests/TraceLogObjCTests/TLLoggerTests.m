//
//  TLLoggerTests.m
//  TraceLog
//
//  Created by Tony Stone on 10/17/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//

@import XCTest;
@import TraceLog;

@interface TLLoggerTests : XCTestCase

@end

@implementation TLLoggerTests

    /// Warning: This method is deprecated.  Its only referenced here for testing.
    - (void) testConfigure_NoArgs  {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [TLLogger configure];
#pragma clang diagnostic pop
    }

    /// Warning: This method is deprecated.  Its only referenced here for testing.
    - (void) testConfigureWithEnvironment {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [TLLogger configureWithEnvironment: @{@"LOG_ALL": @"TRACE4"}];
#pragma clang diagnostic pop
    }

@end
