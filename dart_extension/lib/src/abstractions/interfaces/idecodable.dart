import 'package:dart_extension/dart_extension.dart';

/// Represents a decodable object.
abstract interface class IDecodable {
  /// Loads the current object content from the given [dataMap] object.
  ///
  /// [dataMap] - object that contains encoded content.
  void decode(DataMap dataMap);
}
