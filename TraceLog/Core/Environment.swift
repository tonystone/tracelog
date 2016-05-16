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

public class Environment : DictionaryLiteralConvertible {
    
    public typealias Key   = String
    public typealias Value = String
    
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        storage = [Key: Value]()
        
        for (key, value) in elements {
            storage[key] = value
        }
    }
    
    public init() {
        let process  = NSProcessInfo.processInfo()
        
        self.storage = process.environment
    }
    private var storage: [Key: Value]
}

extension Environment : CollectionType  {

    /**
     Always zero, which is the index of the first element when non-empty.
     */
    public var startIndex : DictionaryIndex<Key, Value> { return storage.startIndex }
    
    /**
     A "past-the-end" element index; the successor of the last valid subscript argument.
     */
    public var endIndex  : DictionaryIndex<Key, Value> { return storage.endIndex }
    
    public subscript(position : DictionaryIndex<Key, Value>) -> (key: Key, value: Value) {
        
        get {
            return storage[position]
        }
    }
}