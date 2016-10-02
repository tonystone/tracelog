//
//  TraceLogPerformanceTests.m
//  TraceLog
//
//  Created by Tony Stone on 10/1/16.
//  Copyright © 2016 Tony Stone. All rights reserved.
//

@import XCTest;
@import TraceLog;

/// Test iteration count for all performance tests in this file
static const int testIterations = 10000;

@interface TraceLogPerformanceTests_ObjC : XCTestCase
@end

@implementation TraceLogPerformanceTests_ObjC

    - (void) testLogError_Performance {
        
        // Reset the logger to the default before testing
        [TLLogger setWriters: @[ [[TLConsoleWriter alloc] init] ]];
        
        [self measureBlock:^{
        
            for (int i = 0; i < testIterations; i++) {
                LogError(@"ObjC: %s", __FUNCTION__);
            }
        }];
    }

    - (void) testLogTrace4_Performance {
        
        // Reset the logger to the default before testing
        [TLLogger setWriters: @[ [[TLConsoleWriter alloc] init] ]];
        
        [self measureBlock:^{
        
            for (int i = 0; i < testIterations; i++) {
                LogTrace(4,@"ObjC: %s", __FUNCTION__);
            }
        }];
    }

    - (void) testLogError_Performance_NullWriter {
    
        // Remove the log writers for this test so we see the time it takes to process internally without io
        [TLLogger setWriters: [[NSArray alloc] init]];
        
        [self measureBlock:^{

            for (int i = 0; i < testIterations; i++) {
                LogError(@"ObjC: %s", __FUNCTION__);
            }
        }];
    }

    - (void) testLogTrace4_Performance_NullWriter {
    
        // Remove the log writers for this test so we see the time it takes to process internally without io
        [TLLogger setWriters: [[NSArray alloc] init]];
        
        [self measureBlock:^{
        
            for (int i = 0; i < testIterations; i++) {
                LogTrace(4,@"ObjC: %s", __FUNCTION__);
            }
        }];
    }

@end


