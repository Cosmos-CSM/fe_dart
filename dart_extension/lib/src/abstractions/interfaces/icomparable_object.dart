import 'package:dart_extension/dart_extension.dart';

/// Represents an object capable of being compared with another same type object.
abstract interface class IComparableObject<TObject> {
  /// Compares the given [ref] with the current object values, considering the current one
  /// as the original values, and the given [ref] object values as the differences candidate.
  ///
  /// When [aggregator] is given, this method result with be appended to it, then return the whole
  /// acumulated result. This is usually used on nested objects as properties.
  ObjectDifferences compare(TObject ref, [ObjectDifferences? aggregator]);
}
