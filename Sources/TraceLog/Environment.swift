///
///  Environment.swift
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
///  Created by Tony Stone on 4/26/16.
///
import Swift
import Foundation

///
/// A class that is used to capture and represent the os environment variables.
/// 
/// This class can be passed to TraceLog.configure to configure it using the 
/// current Environment settings.
///
/// Environment is also like a Swift Dictionary<String,String> so it can be used just
/// like a dictionary including subscripting.
///
public class Environment :  Collection, ExpressibleByDictionaryLiteral {
    
    public typealias Key   = String
    public typealias Value = String
    
    /// The element type of a Environment: a tuple containing an individual
    /// key-value pair.
    public typealias Element = (key: Key, value: Value)
    
    /// The index type of an Environment.
    public typealias Index = DictionaryIndex<Key, Value>
    
    ///
    /// Creates a new Environment instance from a dictionary literal
    ///
    /// - Parameter dictionaryLiteral:
    ///
    /// The following example creates an Environment instance with the
    /// the elements of the dictionary literal:
    ///
    ///     let environment: Environment = ["LOG_ALL": "ERROR", "LOG_TAG_MyTag": "TRACE1"]
    ///
    public required init(dictionaryLiteral elements: (Key, Value)...) {
        storage = [Key: Value]()
        
        for (key, value) in elements {
            storage[key] = value
        }
    }

    ///
    /// Creates a new Environment instance with any collection type with an
    /// element type of `(key: String, value: String)`.
    ///
    /// The following example creates an Environment instance with the
    /// contents of the dictionary type values:
    ///
    ///     let values: [String : String] = ["LOG_ALL": "ERROR", "LOG_TAG_MyTag": "TRACE1"]
    ///
    ///     let environment =  Environment(values)
    ///
    public init<T : Collection>(_ elements: T) where T.Iterator.Element == Element {
        storage = [Key: Value]()
        
        for (key, value) in elements {
            storage[key] = value
        }
    }
    
    ///
    /// Creates a new Environment instance and fills it with the variable
    //  set in the current OS envirnment
    ///
    /// The following example creates an Environment instance with the 
    /// current contents of the OS environment:
    ///
    ///     let environment =  Environment()
    ///
    public init() {
        let process  = ProcessInfo.processInfo
        
        self.storage = process.environment
    }
    
    ///
    /// Returns the position immediately after the given index.
    ///
    /// - Parameter i: A valid index of the collection. `i` must be less than
    ///   `endIndex`.
    /// - Returns: The index value immediately after `i`.
    ///
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
    
    ///
    /// Accesses the element at the specified position.
    ///
    /// The following example accesses an element of an Environment through its
    /// subscript to print its value:
    ///
    ///     let environment: Environment = ["LOG_ALL": "ERROR", "LOG_TAG_MyTag": "TRACE1"]
    ///     print(environment[1])
    ///     // Prints "TRACE1"
    ///
    /// - Parameter position: The position of the element to access. `position`
    ///   must be a valid index of the Environment that is not equal to the
    ///   `endIndex` property.
    ///
    public subscript(position : Index) -> Element {
        return storage[position]
    }
    
    ///
    /// Set or get the element with the specified key.
    ///
    /// The following example accesses an element of an Environment through its
    /// subscript to get and print its value:
    ///
    ///     let environment: Environment = ["LOG_ALL": "ERROR", "LOG_TAG_MyTag": "TRACE1"]
    ///
    ///     print(environment["LOG_ALL"]) // Prints "ERROR"
    ///
    /// The following example accesses an element of an Environment through its
    /// subscript to set and print its value:
    ///
    ///     environment["LOG_TAG_AnotherTag"] = "INFO"
    ///
    ///     print(environment["LOG_TAG_AnotherTag"]) // Prints "INFO"
    ///
    /// - Parameter key: The key of the element to access.
    ///
    public subscript(key: Key) -> Value? {
        get {
            return storage[key]
        }
        
        set {
            storage[key] = newValue
        }
    }
    
    fileprivate var storage: [Key: Value]
}
