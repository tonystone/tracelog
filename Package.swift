// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.
///
///  Package.swift
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
///  Created by Tony Stone on 10/1/16.
///
import PackageDescription

let package = Package(
    name: "TraceLog",
    platforms: [.iOS(.v9), .macOS(.v10_13), .tvOS(.v9), .watchOS(.v2)],
    products: [
      .library(
        name: "TraceLog",
        type: .dynamic,
        targets: ["TraceLog"]
      ),
      .library(
        name: "TraceLogObjC",
        type: .dynamic,
        targets: ["TraceLogObjC"]
      )],
    targets: [
        /// Module targets
        .target(name: "TraceLog",
                dependencies: [],
                path: "Sources/TraceLog"),
        .target(name: "TraceLogObjC",
                dependencies: ["TraceLog"],
                path: "Sources/TraceLogObjC",
                publicHeadersPath: "include",
                cSettings: [
                  .headerSearchPath("../.."),
                ]),

        /// Tests
        .testTarget(name: "TraceLogTests",
                    dependencies: ["TraceLog"],
                    path: "Tests/TraceLogTests",
                    exclude: ["Internal/Utilities/Streams/FileOutputStreamError+PosixTests.swift.gyb",
                              "Internal/Utilities/Streams/OutputStreamError+PosixTests.swift.gyb",
                              "Writers & Formatters/Textformat+EncodingTests.swift.gyb",
                              "Writers & Formatters/TextFormat+InternationalLanguagesTests.swift.gyb",
                              "Writers & Formatters/FileStrategyManager+FailureReasonTests.swift.gyb"]),
        .testTarget(name: "TraceLogObjCTests",
                    dependencies: ["TraceLogObjC"],
                    path: "Tests/TraceLogObjCTests",
                    exclude: [])
    ],
    swiftLanguageVersions: [.version("5")]
)
