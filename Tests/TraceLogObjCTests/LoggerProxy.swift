///
///  TraceLogTestsObjCSwiftBridge.swift
///  TraceLog
///
///  Created by Tony Stone on 10/1/16.
///  Copyright © 2016 Tony Stone. All rights reserved.
///

import Foundation
import TraceLog

@objc
open class LoggerProxy: NSObject {

    @objc
    open class func configure(environment: [String: String], withConsoleWriter: Bool) {

        var writers: [Writer] = []

        if withConsoleWriter {
            writers.append(ConsoleWriter())
        }

        TraceLog.configure(writers: writers, environment: Environment(environment))
    }
}
