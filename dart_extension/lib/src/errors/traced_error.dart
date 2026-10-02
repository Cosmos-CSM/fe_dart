/// Represents an error with [StackTrace] information.
final class TracedError implements Exception {
  /// Exception data object.
  final Object data;

  /// Exception stack tracing information.
  late StackTrace stackTrace;

  /// Creates a new [TracedError] instance.
  TracedError(this.data, [StackTrace? stackTrace]) {
    stackTrace = StackTrace.current;
  }

  @override
  String toString() => data.toString();
}
