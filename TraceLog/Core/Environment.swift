/**
 *   Environment.swift
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
 *   Created by Tony Stone on 4/26/16.
 */
import Foundation

public class Environment :  Collection, ExpressibleByDictionaryLiteral {
    
    public typealias Key   = String
    public typealias Value = String
    
    /// The element type of a Environment: a tuple containing an individual
    /// key-value pair.
    public typealias Element = (key: Key, value: Value)
    
    /// The index type of a dictionary.
    public typealias Index = DictionaryIndex<Key, Value>
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        storage = [Key: Value]()
        
        for (key, value) in elements {
            storage[key] = value
        }
    }

    public init<T : Collection>(_ elements: T) where T.Iterator.Element == Element {
        storage = [Key: Value]()
        
        for (key, value) in elements {
            storage[key] = value
        }
    }
    
    public init() {
        let process  = ProcessInfo.processInfo
        
        self.storage = process.environment
    }
    fileprivate var storage: [Key: Value]

    
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    public func index(after i: Index) -> Index {
        return storage.index(after: i)
    }

    ///
    /// Always zero, which is the index of the first element when non-empty.
    ///
    public var startIndex : Index {
        return storage.startIndex
    }
    
    ///
    /// A "past-the-end" element index; the successor of the last valid subscript argument.
    ///
    public var endIndex  : Index {
        return storage.endIndex
    }
    
    public subscript(position : Index) -> Element {
        return storage[position]
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return storage[key]
        }
        
        set {
            storage[key] = newValue
        }
    }
}
