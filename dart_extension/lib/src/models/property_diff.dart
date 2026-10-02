import 'package:dart_extension/dart_extension.dart';

/// Represents a property values difference, commonly used to track wich differences
/// are found on two objects comparisson.
class PropertyDiff {
  /// Object property difference.
  final PropertyInfo property;

  /// Difference original value.
  final Object? originalValue;

  /// Difference updated value.
  final Object? differenceValue;

  /// Whether the current property is an inner [IComparableObject] and starts a new sub-tree.
  final List<PropertyDiff>? innerDifferences;

  /// Creates a new instance.
  const PropertyDiff(
    this.property,
    this.originalValue,
    this.differenceValue,
    this.innerDifferences,
  ) : assert(
        // If it's a leaf: both values must be provided and no innerDifferences
        (originalValue != null && differenceValue != null && innerDifferences == null) ||
            // If it's a branch: innerDifferences must be provided and both values must be null
            (innerDifferences != null && originalValue == null && differenceValue == null),

        'Provide EITHER (originalValue + differenceValue) OR innerDifferences, but not both.',
      );
}
