/*
 *   Package.swift
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
 *   Created by Tony Stone on 10/1/16.
 */
import PackageDescription

let package = Package(
    name: "TraceLog",
    
    targets: [
        /// The `TraceLog` is the main target in this file
        Target(
            /// The main TraceLog package
            name: "TraceLog",
            dependencies: [])],
    
    exclude: ["_Pods.xcodeproj", "Docs", "Example", "Scripts", "Sources/TraceLogObjC", "Tests/TraceLogObjCTests", "TraceLog.podspec"]
)

/// Added the modules to a framework module
let dylib = Product(name: "TraceLog", type: .Library(.Dynamic), modules: "TraceLog")

products.append(dylib)
