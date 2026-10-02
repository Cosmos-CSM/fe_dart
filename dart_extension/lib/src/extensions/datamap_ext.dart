import 'package:dart_extension/dart_extension.dart';

/// Represents a supported type in [DataMap] value calculations.
final class _SupportTypeConfig<T> {
  /// Target supported type.
  late Type type;

  /// Default value, used when no nullable is expected but was found no value.
  final T defaultValue;

  /// Callback to convert found [Object] to expected value [T].
  T Function(Object value) convertion;

  /// Creates a new instance.
  _SupportTypeConfig(this.defaultValue, this.convertion) {
    type = T;
  }
}

/// Extends [DataMap] type.
extension DatMmapExtension on DataMap {
  /// Stores the current supported [Type]'s to auto cast and run specific sanitization.
  static final List<_SupportTypeConfig<Object>> _supported = <_SupportTypeConfig<Object>>[
    /// --> [DateTime] supported configurations
    _SupportTypeConfig<DateTime>(DateTime(0), (Object value) => DateTime.parse(value.toString())),

    /// --> [String] supported configuration.
    _SupportTypeConfig<String>('', (Object value) => value.toString()),

    /// --> [int] supported configuration.
    _SupportTypeConfig<int>(0, (Object value) => int.parse(value.toString())),

    /// --> [BigInt] supported configuration.
    _SupportTypeConfig<BigInt>(BigInt.from(0), (Object value) => BigInt.parse(value.toString())),

    /// --> [DataMap] supported configuration.
    _SupportTypeConfig<DataMap>(<String, Object?>{}, (Object value) => value as DataMap),

    /// --> [bool] supported configuration.
    _SupportTypeConfig<bool>(false, (Object value) => bool.parse(value.toString())),

    /// --> [Object] supported configuration.
    _SupportTypeConfig<Object>(Object(), (Object value) => value),
  ];

  /// Gets the value of the given key from the [DataMap].
  ///
  /// [T] type expected for the value.
  ///
  /// [key] value key at the [DataMap].
  ///
  /// [strict] whether an exception should be thrown when the key is not found in the [DataMap].
  ///
  /// [caseSensitive] Specifies if the key searching in the object should consider the specific casing of the words.
  T get<T>(String key, [T? defaultValue, bool strict = false, bool caseSensitive = false]) {
    final bool isNullable = null is T;

    /// Getting target [Key] and its [Value].
    bool keyExist = false;
    Object? keyValue;
    if (caseSensitive) {
      keyExist = containsKey(key);
      keyValue = keyExist ? this[key] : null;
    } else {
      for (MapEntry<String, Object?> mapEntry in entries) {
        final String uncKey = mapEntry.key.toLowerCase();

        if (uncKey == key.toLowerCase()) {
          keyExist = true;
          keyValue = mapEntry.value;
          break;
        }
      }
    }

    /// Validations when the [key] is not found.
    if ((!keyExist)) {
      if (strict) {
        throw TracedError('The given key($key) is not present in the current [DataMap] instance');
      }
      if (isNullable) {
        return (null as T);
      }
      if (defaultValue == null && !isNullable) {
        throw TracedError('The given key ($key) was not found in the current [DataMap] instance, the expected type is not nullable and the default value given is nullable wrong configuration');
      }

      return defaultValue as T;
    }

    if (keyValue == null && isNullable) {
      return (null as T);
    }

    /// Getting the correct type configuration
    _SupportTypeConfig<T>? typeConfiguration;
    for (_SupportTypeConfig<Object> typeConfig in _supported) {
      if (!isNullable) {
        if (typeConfig.type == T) {
          typeConfiguration = typeConfig as _SupportTypeConfig<T>;
          break;
        }

        continue;
      }

      String bruteGeneric = T.toString();
      bruteGeneric = bruteGeneric.substring(0, bruteGeneric.length - 1);

      if (bruteGeneric == typeConfig.type.toString()) {
        typeConfiguration = typeConfig as _SupportTypeConfig<T>;
        break;
      }
    }

    if (typeConfiguration == null) {
      throw TracedError('Unsupported: This method doesn\'t allow binding for $T');
    }

    if (keyValue == null) {
      return typeConfiguration.defaultValue;
    }

    return typeConfiguration.convertion(keyValue);
  }

  /// Gets the list value of the given key from the [DataMap].
  ///
  ///
  /// [key] Specified [DataMap] key to trace and bind the property value.
  ///
  /// [strict] whether an exception should be thrown when the key is not found in the [DataMap].
  ///
  /// [caseSensitive] wheter the key matching must consider word casing.
  List<T> getList<T>(String key, [List<T>? defaultValue, bool strict = false, bool caseSensitive = false]) {
    late final List<T> cacheList;

    final Object? rawList = get(key, strict, caseSensitive);
    if (rawList == null) {
      if (defaultValue != null) {
        return defaultValue;
      }

      throw TracedError('Value is null and no defaultValue configured wrong configuration');
    }

    try {
      cacheList = (rawList as List<dynamic>).cast<T>();
      return cacheList;
    } catch (exception) {
      late final List<Object?> castedObjectList;

      try {
        castedObjectList = rawList as List<Object?>;
      } catch (exception) {
        throw TracedError('Unsupported data type casting for ($T)');
      }

      cacheList = <T>[];
      for (Object? value in castedObjectList) {
        try {
          T valueAsExpect = value as T;
          cacheList.add(valueAsExpect);
        } catch (x) {
          continue;
        }
      }
    }

    return cacheList;
  }
}
