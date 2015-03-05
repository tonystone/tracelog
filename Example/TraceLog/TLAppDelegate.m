//
//  TLAppDelegate.m
//  TraceLog
//
//  Created by CocoaPods on 03/04/2015.
//  Copyright (c) 2014 Tony Stone. All rights reserved.
//

#import "TLAppDelegate.h"
#import <TraceLog/TraceLog.h>

//
// Static constructor
//
static __attribute__((constructor(101),used,visibility("internal"))) void staticConstructor (void) {

    // Testing C level macros

    CLogError([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil, @"C Level Test - ERROR output");
    CLogWarning([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,@"C Level Test - WARNING output");
    CLogInfo([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,@"C Level Test - INFO output");
    CLogTrace([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,1,@"C Level Test - TRACE%u output",1);
    CLogTrace([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,2,@"C Level Test - TRACE%u output",2);
    CLogTrace([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,3,@"C Level Test - TRACE%u output",3);
    CLogTrace([TLAppDelegate class], @selector(application:didFinishLaunchingWithOptions:), nil,4,@"C Level Test - TRACE%u output",4);
}

@implementation TLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    LogError(@"Objective-C Level Test - ERROR output");
    LogWarning(@"Objective-C Level Test - WARNING output");
    LogInfo(@"Objective-C Level Test - INFO output");
    LogTrace(1,@"Objective-C Level Test - TRACE%u output",1);
    LogTrace(2,@"Objective-C Level Test - TRACE%u output",2);
    LogTrace(3,@"Objective-C Level Test - TRACE%u output",3);
    LogTrace(4,@"Objective-C Level Test - TRACE%u output",4);

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
