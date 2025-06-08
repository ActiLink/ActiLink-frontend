/// {@template utils}
/// Utilities and helpers package
/// {@endtemplate}
class Utils {
  /// {@macro utils}
  const Utils();
}

/// JSON utility functions for handling data conversion
class JsonUtils {
  /// Converts a JSON id field to a string, handling both string and int types
  /// Returns the provided [defaultValue] if the id is null
  static String idToString(dynamic id, [String defaultValue = '']) {
    if (id == null) return defaultValue;
    if (id is String) return id;
    return id.toString();
  }
}
