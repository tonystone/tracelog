///
///  Configuration.swift
///
///  Copyright 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 4/28/16.
///
import Foundation

extension Configuration {

    enum ConfigurationError: Error, CustomStringConvertible {
        case invalidLogLevel(String)

        var description: String {
            switch self {
            case .invalidLogLevel(let value):
                return value
            }
        }
    }

    private static let logTag    = "LOG_TAG_"
    private static let logPrefix = "LOG_PREFIX_"
    private static let logAll    = "LOG_ALL"
}

///
/// Internal Configuration data
///
internal class Configuration {

    var globalLogLevel: LogLevel             = .info
    var loggedPrefixes: [String: LogLevel]   = [:]
    var loggedTags:     [String: LogLevel]   = [:]
    var writers:        [WriterProxy]        = []
    var errors:         [ConfigurationError] = []

    init(writers: [WriterConcurrencyMode] = [.async(ConsoleWriter(), options: [])], environment: Environment = Environment()) {
        self.writers = writers.map( { $0.proxy() } )

        self.errors = self.parse(environment: environment)
    }

    ///
    /// (Re)Load this structure with the values for the environment variables
    ///
    private func parse(environment: Environment) -> [ConfigurationError] {

        var errors = [ConfigurationError]()

        self.globalLogLevel = LogLevel.info

        self.loggedPrefixes.removeAll()
        self.loggedTags.removeAll()

        for (variable, value) in environment {
            ///
            /// All variables and log level strings are converted
            /// to upper case for comparison.
            ///
            let upperCaseVariable        = variable.uppercased()
            let upperCaselogLevelString  = value.uppercased()

            if upperCaseVariable.hasPrefix(Configuration.logAll) {

                if let level = upperCaselogLevelString.asLogLevel() {
                    self.globalLogLevel = level
                } else {
                    errors.append(.invalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(upperCaseVariable)' will be set to \(String(describing: self.globalLogLevel).uppercased())."))
                }

            } else if upperCaseVariable.hasPrefix(Configuration.logPrefix) {

                if let level = upperCaselogLevelString.asLogLevel() {
                    ///
                    /// Note: in order to allow for case sensitive tag prefix names, we use the variable instead of the uppercase version.
                    ///
                    if let logLevelScopeRange = variable.range(of: Configuration.logPrefix) {
                        let logLevelScope = String(variable[logLevelScopeRange.upperBound...])

                        self.loggedPrefixes[logLevelScope] =  level
                    }
                } else {
                    errors.append(.invalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(upperCaseVariable)' will NOT be set."))
                }

            } else if upperCaseVariable.hasPrefix(Configuration.logTag) {

                if let level = upperCaselogLevelString.asLogLevel() {
                    ///
                    /// Note: in order to allow for case sensitive tag names, we use the variable instead of the uppercase version.
                    ///
                    if let logLevelScopeRange = variable.range(of: Configuration.logTag) {
                        let logLevelScope      = String(variable[logLevelScopeRange.upperBound...])

                        self.loggedTags[logLevelScope] =  level
                    }
                } else {
                    errors.append(.invalidLogLevel("Variable '\(upperCaseVariable)' has an invalid logLevel of '\(upperCaselogLevelString)'. '\(upperCaseVariable)' will NOT be set."))
                }
            }
        }
        return errors
    }

    ///
    /// Determine the LogLevel for this tag based on the configuration
    ///
    func logLevel(for tag: String) -> LogLevel {

        /// Set to the default global level first
        var level = self.globalLogLevel

        /// Determine if there is a class log level first
        if let tagLogLevel = self.loggedTags[tag] {
            level = tagLogLevel
        } else {

            /// Determine the prefixes log level if available
            for (prefix, logLevel) in self.loggedPrefixes.reversed() {
                if tag.hasPrefix(prefix) {
                    level = logLevel
                    break
                }
            }
        }
        return level
    }
}

///
/// Allow the configuration to be printed
///
extension Configuration: CustomStringConvertible {

    /// FIXME: Add printing of the Writers installed.

    var description: String {

        var loggedString = "{"

        if self.loggedTags.count > 0 {

            loggedString += "\n\ttags: {\n"

            for (tag, level) in self.loggedTags {

                loggedString += "\n\t\t\(tag) = \(String(describing: level).uppercased())"
            }
            loggedString += "\n\t}"
        }

        if self.loggedPrefixes.count > 0 {

            loggedString += "\n\tprefixes: {\n"

            for (prefix, level) in self.loggedPrefixes {

                loggedString += "\n\t\t\(prefix) = \(String(describing: level).uppercased())"
            }
            loggedString += "\n\t}"
        }
        loggedString += "\n\tglobal: {\n\n\t\tALL = \(String(describing: self.globalLogLevel).uppercased())\n\t}\n}"

        return loggedString
    }
}
