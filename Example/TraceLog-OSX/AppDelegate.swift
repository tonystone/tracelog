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
    
    let test = true;
    var moduleName = "MyCustomTag"
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
//        //
//        // Log an Info level message using a trailing closure.
//        //
//        logInfo {
//            "A string expression to log."
//        }
//        
//        //
//        // Log an Info level message using a trailing closure and a specific tag to use to group this call.
//        //
//        logInfo(moduleName) {
//            "A string expression to log."
//        }
//        
//        //
//        // Log an Info level message using a trailing closure style.
//        //
//        logInfo {
//            
//            // You can create complex closures that ultimately
//            // return the String that will be logged to the
//            // log Writers
//            //
//            // Note: This closure is not evaluated unless this
//            //       messsage is logged.
//            //
//            if self.test {
//                return "A string produced as a result of a () -> String closure being evaluated."
//            } else {
//                return ""
//            }
//        }
//        
//        //
//        // Log a Trace level 1 message using a trailing closure
//        //
//        logTrace {
//            "A string produced as a result of a () -> String closure being evaluated."
//        }
//        
//        //
//        // Log a Trace level 1 message using a trailing closure and a specific tag.
//        //
//        logTrace(moduleName) {
//            "A string produced as a result of a () -> String closure being evaluated."
//        }
//        
//        //
//        // Log a Trace level 2 message using a trailing closure and a specific tag.
//        //
//        logTrace(moduleName, level: 2) {
//           "A string produced as a result of a () -> String closure being evaluated."
//        }
//        
//        //
//        // Log a Trace level 2 message using a trailing closure.
//        //
//        logTrace(2) {
//            "A string produced as a result of a () -> String closure being evaluated."
//        }
    }

}

