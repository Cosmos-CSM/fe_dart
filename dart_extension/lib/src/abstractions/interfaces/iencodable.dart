import 'package:dart_extension/dart_extension.dart';

/// Represents an encodable object.
abstract interface class IEncodable {
  /// Encodes current object data into a [DataMap].
  DataMap encode();
}
