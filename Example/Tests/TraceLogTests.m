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
@import XCTest;
@import TraceLog;

@interface TraceLogTests_ObjC : XCTestCase
@end

@implementation TraceLogTests_ObjC

    //
    // Object level calls
    //
    - (void) testLogError {
        LogError(@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogWarning {
        LogWarning(@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogInfo {
        LogInfo(@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogTrace1{
        LogTrace(1,@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogTrace2_WithString {
        LogTrace(2,@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogTrace3 {
        LogTrace(3,@"ObjC: %s", __FUNCTION__);
    }

    - (void) testLogTrace4 {
        LogTrace(4,@"ObjC: %s", __FUNCTION__);
    }

    //
    // C-Level Call tests
    //
    - (void) testCLogError {
        CLogError(NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogWarning {
        CLogWarning(NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogInfo {
        CLogInfo(NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogTrace1 {
        CLogTrace(1, NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogTrace2 {
        CLogTrace(2, NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogTrace3 {
        CLogTrace(3, NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }

    - (void) testCLogTrace4 {
        CLogTrace(4, NSStringFromClass([self class]), @"C: %s", __FUNCTION__);
    }


@end
