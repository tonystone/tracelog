/**
 *   Tests.m
 *
 *   Copyright 2015 The Climate Corporation
 *   Copyright 2015 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 3/4/15.
 */
#import <TraceLog/TraceLog.h>
#import <XCTest/XCTest.h>

@interface TraceLogTests : XCTestCase
@end

@implementation TraceLogTests

    //
    // Object level calls
    //
    - (void) testLogError {
        LogError(@"Objective-C Level Test - ERROR");
    }

    - (void) testLogWarning {
        LogWarning(@"Objective-C Level Test - WARNING");
    }

    - (void) testLogInfo {
        LogInfo(@"Objective-C Level Test - INFO");
    }

    - (void) testLogTrace1 {
        LogTrace(1,@"Objective-C Level Test - TRACE%u",1);
    }

    - (void) testLogTrace2 {
        LogTrace(2,@"Objective-C Level Test - TRACE%u",2);
    }

    - (void) testLogTrace3 {
        LogTrace(3,@"Objective-C Level Test - TRACE%u",3);
    }

    - (void) testLogTrace4 {
        LogTrace(4,@"Objective-C Level Test - TRACE%u",4);
    }

    //
    // C-Level Call tests
    //
    - (void) testCLogError {
        CLogError([self class], @selector(testCLogError), nil, @"C Level Test - ERROR");
    }

    - (void) testCLogWarning {
        CLogWarning([self class], @selector(testCLogWarning), nil,@"C Level Test - WARNING");
    }

    - (void) testCLogInfo {
        CLogInfo([self class], @selector(testCLogInfo), nil,@"C Level Test - INFO");
    }

    - (void) testCLogTrace1 {
        CLogTrace([self class], @selector(testCLogTrace1), nil,1,@"C Level Test - TRACE%u",1);
    }

    - (void) testCLogTrace2 {
        CLogTrace([self class], @selector(testCLogTrace2), nil,2,@"C Level Test - TRACE%u",2);
    }

    - (void) testCLogTrace3 {
        CLogTrace([self class], @selector(testCLogTrace3), nil,3,@"C Level Test - TRACE%u",3);
    }

    - (void) testCLogTrace4 {
        CLogTrace([self class], @selector(testCLogTrace4), nil,4,@"C Level Test - TRACE%u",4);
    }

@end
