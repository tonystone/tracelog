/**
 *   Configuration.swift
 *
 *   Copyright 2016 Tony Stone
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
 *   Created by Tony Stone on 4/28/16.
 */
import Foundation

internal let ModuleLogName  = "TraceLog"

private let LogTag    = "LOG_TAG_"
private let LogPrefix = "LOG_PREFIX_"
private let LogAll    = "LOG_ALL"

internal enum ConfigurationError : ErrorType {
    case InvalidLogLevel(String)
}

//
// Internal data
//
internal class Configuration  {
    
    var globalLogLevel = LogLevel.Info
    
    var loggedPrefixes = [String : LogLevel]()
    var loggedTags     = [String : LogLevel]()
    var logWriters     = [Writer]()
    
    init () {}
    
    func load <T : CollectionType where T.Generator.Element == (String, String)>(writers: [Writer], environment: T) -> [ConfigurationError] {
        
        var errors = [ConfigurationError]()
        
        self.globalLogLevel = LogLevel.Info
        
        self.logWriters.removeAll()
        self.loggedPrefixes.removeAll()
        self.loggedTags.removeAll()

        // Initialize the writers first
        self.logWriters.appendContentsOf(writers)
        
        for (variable, value) in environment {
            //
            // All variables and log level strings are converted
            // to upper case for comparison.
            //
            let upperCaseVariable        = variable.uppercaseString
            let upperCaselogLevelString  = value.uppercaseString
            
            if upperCaseVariable.hasPrefix(LogAll) {
                
                if let level = upperCaselogLevelString.asLogLevel() {
                    self.globalLogLevel = level
                } else {
                    errors.append(.InvalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(LogAll)' will be set to \(self.globalLogLevel)."))
                }
                
            } else if upperCaseVariable.hasPrefix(LogPrefix) {
                
                if let level = upperCaselogLevelString.asLogLevel() {
                    //
                    // Note: in order to allow for case sensitive tag prefix names, we use the variable instead of the uppercase version.
                    //
                    if let logLevelScopeRange = variable.rangeOfString(LogPrefix) {
                        let logLevelScope = variable.substringFromIndex(logLevelScopeRange.endIndex)
                        
                        self.loggedPrefixes[logLevelScope] =  level
                    }
                } else {
                    errors.append(.InvalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(upperCaseVariable)' will NOT be set."))
                }
                
            } else if upperCaseVariable.hasPrefix(LogTag) {
                
                if let level = upperCaselogLevelString.asLogLevel() {
                    //
                    // Note: in order to allow for case sensitive tag names, we use the variable instead of the uppercase version.
                    //
                    if let logLevelScopeRange = variable.rangeOfString(LogTag) {
                        let logLevelScope      = variable.substringFromIndex(logLevelScopeRange.endIndex)
                        
                        self.loggedTags[logLevelScope] =  level
                    }
                } else {
                    errors.append(.InvalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(upperCaseVariable)' will NOT be set."))
                }
            }
        }
        return errors
    }
    
    func logLevel(tag: String) -> LogLevel {
        
        // Set to the default global level first
        var level = self.globalLogLevel
        
        // Determine if there is a class log level first
        if let tagLogLevel = self.loggedTags[tag] {
            level = tagLogLevel
        } else {
            
            // Determine the prefixes log level if available
            if let prefixLogLevel = prefixLogLevelForTag(tag) {
                level = prefixLogLevel
            }
        }
        return level;
    }
    
    private func prefixLogLevelForTag(tag: String) -> LogLevel? {
        
        for (prefix, logLevel) in self.loggedPrefixes {
            if prefix.hasPrefix(prefix) {
                return logLevel
            }
        }
        return nil;
    }
}


extension Configuration : CustomStringConvertible {
    
    var description: String {
        
        var loggedString = "{"
        
        if self.loggedTags.count > 0 {
            
            loggedString += "\n\ttags: {\n"
            
            for (tag, level) in self.loggedTags {
                
                loggedString += String(format: "\n\t\t%@ = \(level)", tag)
            }
            loggedString += "\n\t}"
        }
        
        if self.loggedPrefixes.count > 0 {
            
            loggedString += "\n\tprefixes: {\n"
            
            for (prefix, level) in self.loggedPrefixes {
                
                loggedString += String(format: "\n\t\t%@ = \(level)", prefix)
            }
            loggedString += "\n\t}"
        }
        loggedString += String(format: "\n\tglobal: {\n\n\t\t%@ = \(self.globalLogLevel)\n\t}\n}", "ALL")
        
        return loggedString
    }
}