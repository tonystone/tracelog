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
#import <XCTest/XCTest.h>

@import TraceLog;

@interface TraceLogTests_ObjC : XCTestCase
@end

@implementation TraceLogTests_ObjC

    //
    // Object level calls
    //
    - (void) testLogError_WithString {
        LogError(@"Objective-C Level Test - ERROR");
    }

    - (void) testLogError_WithFormatString {
        LogError(@"Objective-C Level Test - %@", @"ERROR");
    }

    - (void) testLogWarning_WithString {
        LogWarning(@"Objective-C Level Test - WARNING");
    }

    - (void) testLogInfo_WithString {
        LogInfo(@"Objective-C Level Test - INFO");
    }

    - (void) testLogInfo_WithFormatString {
        LogInfo(@"Objective-C Level Test - %@", @"INFO");
    }

    - (void) testLogTrace1_WithString {
        LogTrace(1,@"Objective-C Level Test - TRACE1");
    }

    - (void) testLogTrace1_WithFormatString {
        LogTrace(1,@"Objective-C Level Test - TRACE%u",1);
    }

    - (void) testLogTrace2_WithString {
        LogTrace(2,@"Objective-C Level Test - TRACE2");
    }

    - (void) testLogTrace2_WithFormatString {
        LogTrace(2,@"Objective-C Level Test - TRACE%u",2);
    }

    - (void) testLogTrace3_WithString {
        LogTrace(3,@"Objective-C Level Test - TRACE3");
    }

    - (void) testLogTrace3_WithFormatString {
        LogTrace(3,@"Objective-C Level Test - TRACE%u",3);
    }

    - (void) testLogTrace4_WithString {
        LogTrace(4,@"Objective-C Level Test - TRACE4");
    }

    - (void) testLogTrace4_WithFormatString {
        LogTrace(4,@"Objective-C Level Test - TRACE%u",4);
    }

    //
    // C-Level Call tests
    //
    - (void) testCLogError {
        CLogError(NSStringFromClass([self class]), @"C Level Test - ERROR");
    }

    - (void) testCLogWarning {
        CLogWarning(NSStringFromClass([self class]), @"C Level Test - WARNING");
    }

    - (void) testCLogInfo {
        CLogInfo(NSStringFromClass([self class]), @"C Level Test - INFO");
    }

    - (void) testCLogTrace1 {
        CLogTrace(1, NSStringFromClass([self class]), @"C Level Test - TRACE%u",1);
    }

    - (void) testCLogTrace2 {
        CLogTrace(2, NSStringFromClass([self class]), @"C Level Test - TRACE%u",2);
    }

    - (void) testCLogTrace3 {
        CLogTrace(3, NSStringFromClass([self class]), @"C Level Test - TRACE%u",3);
    }

    - (void) testCLogTrace4 {
        CLogTrace(4, NSStringFromClass([self class]), @"C Level Test - TRACE%u",4);
    }

@end
