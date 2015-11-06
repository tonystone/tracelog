//
//  AppDelegate.swift
//  TraceLog-OSX
//
//  Created by Tony Stone on 11/5/15.
//  Copyright © 2015 Tony Stone. All rights reserved.
//

import Cocoa
import TraceLog

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        logInfo("applicationDidFinishLaunching called.", tag: "TraceLog OSX - Test App");
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        
        logInfo("applicationWillTerminate called.", tag: "TraceLog OSX - Test App");
    }


}

