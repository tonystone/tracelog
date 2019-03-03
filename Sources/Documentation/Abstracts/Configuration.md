TraceLog can be configured via the environment either manually using `export` or via Xcode.
For TraceLog to read the environment on startup, you must call its configure method at the beginning of your application.

```swift
   TraceLog.configure()
```

## Log Writers

TraceLog can be configured with multiple custom log writers who do the job of outputting the log statements to the desired location.  By default, it configures itself with a `ConsoleWriter`
which outputs to `stdout`.  You can change the writers at any time and chain multiple of them to output to different locations such as to a remote logging servers, syslog, etc.

Writers must implement the `Writer` protocol.  To install them, simply call configure with an array of `Writers`.

```swift
    let networkWriter = NetworkWriter(url: URL("http://mydomain.com/log"))

    TraceLog.configure(writers: [ConsoleWriter(), networkWriter])
```

Since writers are instantiated before the call, you are free to initialize them with whatever makes sense for the writer type to be created.  For instance in the case of the network writer the URL of
the logging endpoint.

## Concurrency Modes

TraceLog can be configured to run in 3 main concurrency modes, `.direct`, `.sync`, or `.async`.  These modes determine how TraceLog will invoke each writer as it logs your logging statements.

* `.direct` - Direct, as the name implies, will directly call the writer from the calling thread with no indirection. It will block until the writer(s) in this mode have completed the write to the endpoint. Useful for scripting applications and other applications where it is required for the call not to return until the message is printed.

* `.sync` - Synchronous blocking mode is similar to direct in that it blocks but this mode also uses a queue for all writes.  The benefits of that is that all threads writing to the log will be serialized through before calling the writer (one call to the writer at a time).

* `.async` - Asynchronous non-blocking mode.  A general mode used for most application which queues all messages before being evaluated or logged. This ensures minimal delays in application execution due to logging.

Modes can be configured globally for all writers including the default writer by simply setting the mode in the configuration step as in the example below.
```swift
    TraceLog.configure(mode: .direct)
```
This will set TraceLog's default writer to `.direct` mode.

You can also configure each writer individually by wrapping the writer in a mode as in the example below.

```swift
    TraceLog.configure(writers: [.direct(ConsoleWriter()), .async(FileWriter())])
```
This will set the ConsoleWriter to write directly (synchronously) when you log but will queue the FileWriter calls to write in the background asynchronously.

You can also set all writers to the same mode by setting the default mode and passing the writer as normal as in the following statement.

```swift
    TraceLog.configure(mode: .direct, writers: [ConsoleWriter(), FileWriter()])
```
This sets both the ConsoleWriter and the FileWriter to `.direct` mode.

# Setting up your debug environment

TraceLog's current logging output is controlled by variables that are either set in the runtime environment or passed on startup of the application (in the `TraceLog.Configure(environment:)` method).

These variables consist of the following:

```shell
    LOG_ALL=<LEVEL>
    LOG_TAG_<TAGNAME>=<LEVEL>
    LOG_PREFIX_<TAGPREFIX>=<LEVEL>
```
Log output can be set globally using the `LOG_ALL`  variable, by TAG name
using the `LOG_TAG_<TAGNAME>` variable pattern, and/or by a TAG prefix by using
the `LOG_PREFIX_<TAGPREFIX>` variable pattern.

Each environment variable set is set with a level as the value.  The following levels are available in order of display priority.  Each level encompasses the level below it with `TRACE4` including the output from every level.  The lowest level setting is `OFF` which turns logging off for the level set.

Levels:
```shell
    TRACE4
    TRACE3
    TRACE2
    TRACE1
    INFO
    WARNING
    ERROR
    OFF
```
> Note: Log level `OFF` does not disable **TraceLog** completely, it only suppresses log messages for the time it is set in the environment during your debug session.  To completely disable **TraceLog** please see [Runtime Overhead](#runtime-overhead) for more information.

Multiple Environment variables can be set at one time to get the desired level of visibility into the workings of the app.  Here are some examples.

Suppose you wanted the first level of `TRACE` logging for your Networking module which has a class prefix of NT and you wanted to see only errors and warnings for the rest of the application.  You would set the following:

```shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
```

More specific settings override less specific so in the above example, the less specific setting is `LOG_ALL` which is set to `WARNING`.  The tag prefix is specifying a particular collection of tags that start with the string CS, so this is more specific and overrides
the `LOG_ALL`.  If you choose to name a particular tag, that will override the prefix settings.

For instance, in the example above, if we decided for one tag in the Networking module, we needed more output, we could set the following:
```shell
    LOG_ALL=WARNING
    LOG_PREFIX_NT=TRACE1
    LOG_TAG_NTSerializer=TRACE4
```
This outputs the same as the previous example except for the `NTSerializer` tag which is set to `TRACE4` instead of using the less specific `TRACE1` setting in `LOG_PREFIX`.


### Environment Setup (Xcode)

To set up the environment using Xcode, select "Edit Scheme" from the "Set the active scheme" menu at the top left.  That brings up the menu below.

<img src=img/Xcode-environment-setup-screenshot.png width=597 height=361 />

### Environment Setup (Statically in code)

TraceLog.configure() accepts an optional parameter called environment which you can pass the environment.  This allows you to set the configuration options at startup time (note: this ignores any variables passed in the environment).

Here is an example of setting the configuration via `TraceLog.configure()`.
```swift
    TraceLog.configure(environment: ["LOG_ALL": "TRACE4",
                                    "LOG_PREFIX_NS" : "ERROR",
                                    "LOG_TAG_TraceLog" : "TRACE4"])
```

Note: Although the environment is typically set once at the beginning of the application, `TraceLog.configure`
can be called anywhere in your code as often as required to reconfigured the logging levels.

- SeeAlso: `ConcurrencyMode` for global concurrency modes.
- SeeAlso: `WriterConcurrencyMode` for modes that can be set per writer.
- SeeAlso: `Environment` for environment details.
