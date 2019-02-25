///
///  String+InternalExtensions.swift
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
///  Created by Tony Stone on 12/30/18.
///
import Foundation

internal extension String {

    /// Escape any characters in the character set.
    ///
    /// - Parameter charactersIn: a CharacterSet containing the characters to escape.
    ///
    /// - Returns: a new string with all characters in `charactersIn` escaped ("\").
    ///
    func escaping(charactersIn characterSet: CharacterSet) -> String {

        return self.unicodeScalars.map({ (scalar) -> String in
            if characterSet.contains(scalar) {
                return scalar.escaped(asASCII: false)
            }
            return String(scalar)
        }).joined()
    }

    /// Strip (drop) any characters in the character set.
    ///
    /// - Parameter charactersIn: a CharacterSet containing the characters to strip.
    ///
    /// - Returns: a new string with all characters in `charactersIn` stripped.
    ///
    func stripping(charactersIn characterSet: CharacterSet) -> String {

        return self.unicodeScalars.compactMap({ (scalar) -> String? in
            guard !characterSet.contains(scalar)
                else { return nil }
            return String(scalar)
        }).joined()
    }

    /// Returns the ranges of the matches found in
    /// `self` based on the `pattern` supplied.
    ///
    /// Used for matching all occurrences of the pattern in `self`.
    ///
    /// - Parameters:
    ///     - pattern: The string pattern to locate in `self`.
    ///     - options: `String.CompareOptions` to use for the matching (e.g. .regularExpression)
    ///
    /// - Returns: an array of match ranges in the order they where found in `self`.
    ///
    /// - SeeAlso: `String.CompareOptions`
    ///
    func ranges(of pattern: String, options: CompareOptions = []) -> [Range<String.Index>] {

        var ranges: [Range<String.Index>] = []
        var searchStartIndex = self.startIndex

        while searchStartIndex < self.endIndex,
            let range = self.range(of: pattern, options: options, range: searchStartIndex..<self.endIndex), !range.isEmpty {

                ranges.append(range)
                searchStartIndex = range.upperBound
        }
        return ranges
    }

}
