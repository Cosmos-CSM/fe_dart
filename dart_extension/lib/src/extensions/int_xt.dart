/// Extends [int] type.
extension IntExtension on int {
  /// Gets a [Duration] object with current value as seconds.
  Duration get s => Duration(seconds: this);

  /// Gets a [Duration] object with current value as miliseconds.
  Duration get ms => Duration(milliseconds: this);
}
