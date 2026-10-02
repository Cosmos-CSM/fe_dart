/// Represents a property information from a class, this is a way to handle "Reflection" as
/// .Net.
class PropertyInfo {
  /// Property name.
  final String name;

  /// Property runtime type.
  final Type type;

  /// Property value.
  final Object? value;

  /// Creates a new instance.
  const PropertyInfo(this.name, this.type, this.value);
}
