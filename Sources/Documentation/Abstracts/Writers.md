Writers are used to write the log output to various endpoints.

Writers are installed using the TraceLog.`configure(writers:environment:)` and TraceLog.`configure(mode:writers:environment:)` functions.

> Note: Writers are not meant to be used directly other than creating one.  You create a writer and pass it to TraceLog through the configure function.  Once that is done, TraceLog will call the writer for you.
