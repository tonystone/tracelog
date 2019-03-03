Some use cases may require Writers or Formatters that are not already built-in so TraceLog allows you to write your own.

A custom endpoint writer can be created by implementing one of the writer protocols, `Writer` and `OutputStreamWriter`.  `Writer` is the lowest level writer type which is suitable for writing any kind of writer required.  The `OutputStreamWriter` is a higher level writer which inherits from `Writer` and is used to write to byte stream type endpoints.  `ConsoleWriter` and `FileWriter` are examples of `OutputStreamWriter`s.

The `OutputStreamWriter` protocol requires an `OutputStreamFormatter` which you can also create a custom implenentation of.  Two are supplied with TraceLog, the `TextFormat` and the `JSONFormat`.  Thee can be used as a reference for writing your own.
