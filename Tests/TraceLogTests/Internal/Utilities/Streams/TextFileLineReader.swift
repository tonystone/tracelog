///
///  TextStreamReader.swift
///
///  Copyright 2018 Tony Stone
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
///  Created by Tony Stone on 1/26/19.
///
import Foundation

class TextFileLineReader {

    var lineBuffer: [String]
    var index: Int

    init(url: URL, encoding: String.Encoding = .utf8) throws {
        let contents = try String(contentsOf: url, encoding: encoding)

        self.lineBuffer = contents.components(separatedBy: .newlines)
        self.index = 0
    }

    func next() -> String? {
        guard lineBuffer.count > 0
            else { return nil }

        guard self.index < self.lineBuffer.count
            else { return nil }

        defer { self.index += 1 }

        return lineBuffer[index]
    }
}
