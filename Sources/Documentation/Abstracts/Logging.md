For Swift TraceLog comes with the following basic Logging functions (Note: hidden
parameters and defaults were omitted for simplicity).

```swift
    logError  (tag: String?, message: @escaping () -> String)
    logWarning(tag: String?, message: @escaping () -> String)
    logInfo   (tag: String?, message: @escaping () -> String)
    logTrace  (tag: String?, level: UInt, message: @escaping () -> String)
    logTrace  (level: UInt, @escaping message: () -> String)
```

Using it is as simple as calling one of the methods depending on the current type of message you want to log, for instance, to log a simple informational message.

```swift
    logInfo { "A simple informational message" }
```

Since the message parameter is a closure that evaluates to a String, any expression that results in a string message can be used.

```swift
   logInfo {
        "A simple informational message: " +
        " Another expression or constant that evaluates to a string"
   }
```

We used closures for several reasons; one is that the closure will not be evaluated (and you won't incur the overhead) if logging is disabled or if the log level for this call is higher than the current log level set. And two, more complex expressions can be put into the closure to make decisions on the message to be printed based on the current context of the call.  Again, these complex closures will not get executed in the cases mentioned above.  For instance:

```swift
    logInfo {
         if let unwrappedOptionalString = optionalString {
            return "Executing with \(unwrappedOptionalString)..."
         } else {
            return "Executing..."
         }
    }
```

Log methods take an optional tag that you can use to group related messages and also be used to determine whether this statement gets logged based on the current environment configuration.  It no tag is set, the file name of the calling method is used as the tag.

```swift
   logInfo("MyCustomTag") {
        "A simple informational message"
   }
```

There are several trace levels for `logTrace` that can be used.  If you don't pass a level, you get level 3, otherwise, specify a level when making the `logTrace` call.   For example, here is a trace level 1 and a level 3 call.

```swift
   logTrace {
        "A simple trace level 1 message"
   }

   logTrace(3) {
        "A simple trace level 3 message"
   }
```

You can of course also pass a tag like the rest of the log calls.

```swift
    logTrace("MyCustomTag", level: 3) {
         "A simple trace level message"
    }
```

That is all there is to adding logging to your **Swift** application!
