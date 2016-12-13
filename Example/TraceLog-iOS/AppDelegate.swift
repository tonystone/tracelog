///
///  AppDelegate.swift
///  TraceLog-iOS
///
///  Created by Tony Stone on 10/16/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///

import UIKit
import TraceLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let test = true
    var moduleName = "MyCustomTag"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        ///
        /// Configure the TraceLog environment.
        ///
        TraceLog.configure()

        ///
        /// Log an Info level message using a trailing closure.
        ///
        logInfo {
            "A string expression to log."
        }

        ///
        /// Log an Info level message using a trailing closure and a specific tag to use to group this call.
        ///
        logInfo(moduleName) {
            "A string expression to log."
        }

        ///
        /// Log an Info level message using a trailing closure style.
        ///
        logInfo {

            /// You can create complex closures that ultimately
            /// return the String that will be logged to the
            /// log Writers
            ///
            /// Note: This closure is not evaluated unless this
            ///       messsage is logged.
            ///
            if self.test {
                return "A string produced as a result of a () -> String closure being evaluated."
            } else {
                return ""
            }
        }

        ///
        /// Log a Trace level 1 message using a trailing closure
        ///
        logTrace {
            "A string produced as a result of a () -> String closure being evaluated."
        }

        ///
        /// Log a Trace level 1 message using a trailing closure and a specific tag.
        ///
        logTrace(moduleName) {
            "A string produced as a result of a () -> String closure being evaluated."
        }

        ///
        /// Log a Trace level 2 message using a trailing closure and a specific tag.
        ///
        logTrace(moduleName, level: 2) {
            "A string produced as a result of a () -> String closure being evaluated."
        }

        ///
        /// Log a Trace level 2 message using a trailing closure.
        ///
        logTrace(2) {
            "A string produced as a result of a () -> String closure being evaluated."
        }

        return true
    }
}
