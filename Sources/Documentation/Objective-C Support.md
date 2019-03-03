
# Using TraceLog with Objective-C

As with Swift using TraceLog with Objective-C is extremely simple out of the box.  The Objective-C implementation consists of the following primary logging methods. Each has a format specifier (like `NSLog`) and an optional variable number of arguments that represent your placeholder replacement values.

```objc
    LogError  (format,...)
    LogWarning(format,...)
    LogInfo   (format,...)
    LogTrace  (level,format,...)
```

Using it is as simple as calling one of the methods depending on the current type of message you want to log, for instance, to log a simple informational message.

```objc
    LogInfo(@"A simple informational message");
```

You can also call it as you would `NSlog` by using the format specifier and parameters for placeholder replacement.

```objc
    LogInfo(@"A simple informational message: %@", @"Another NSString or expression that evaluates to an NSString");
```

More complex expressions can be put into the placeholder values by using Objective-C blocks that return a printable NSObject. These can be used to make decisions on the message to be printed based on the current context of the call.  These complex blocks will not get executed (and you won't incur the overhead) if logging is disabled or if the log level for this call is higher than the current log level set.  For instance:

```objc
    LogInfo(@"Executing%@...",
        ^() {
            if (optionalString != nil) {
                return [NSString stringWithFormat: @" with %@", optionalString];
            } else {
                return @"";
            }
        }()
    );
```

There is a special version of Log methods take an optional tag that you can use to group related messages and also be used to determine whether this statement gets logged based on the current environment configuration.  These methods begin with C (e.g. `CLogInfo`).

```objc
    CLogInfo(@"MyCustomTag", @"A simple informational message");
```

There are several trace levels for `LogTrace` that can be used. For example, here is a trace level 3 call.

```objc
    LogTrace(3, @"A simple trace level message");
```

You can of course also pass a tag by using the CLog version of the call.

```objc
    CLogTrace(3, @"MyCustomTag", @"A simple trace level message");
```
