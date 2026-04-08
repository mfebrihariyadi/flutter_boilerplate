import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger();

  static final Logger _logger = Logger(
    // filter: _DebugOnlyFilter(),
    // printer: PrettyPrinter(
    //   methodCount: 0,
    //   errorMethodCount: 8,
    //   lineLength: 100,
    //   colors: false,
    //   printEmojis: false,
    // ),
  );

  static void d(String message, {String tag = 'APP', Object? data}) {
    _logger.d(_formatMessage(tag: tag, message: message, data: data));
  }

  static void i(String message, {String tag = 'APP', Object? data}) {
    _logger.i(_formatMessage(tag: tag, message: message, data: data));
  }

  static void w(String message, {String tag = 'APP', Object? data}) {
    _logger.w(_formatMessage(tag: tag, message: message, data: data));
  }

  static void e(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    _logger.e(
      _formatMessage(tag: tag, message: message, data: data),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static String mask(String? value, {int visibleStart = 4, int visibleEnd = 2}) {
    if (value == null) {
      return 'null';
    }

    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return '<empty>';
    }

    if (trimmedValue.length <= visibleStart + visibleEnd) {
      return '${trimmedValue.substring(0, 1)}***';
    }

    final start = trimmedValue.substring(0, visibleStart);
    final end = trimmedValue.substring(trimmedValue.length - visibleEnd);
    return '$start...$end';
  }

  static String tokenState(String? token) {
    if (token == null) {
      return 'missing';
    }

    if (token.isEmpty) {
      return 'empty';
    }

    return 'available(${mask(token)})';
  }

  static Object? sanitizeValue(Object? value, {String? key}) {
    if (_isSensitiveKey(key)) {
      return _redact(value);
    }

    if (value is Map) {
      return <String, Object?>{
        for (final entry in value.entries)
          entry.key.toString(): sanitizeValue(
            entry.value,
            key: entry.key.toString(),
          ),
      };
    }

    if (value is Iterable) {
      return value.map((item) => sanitizeValue(item)).toList(growable: false);
    }

    return value;
  }

  static String _formatMessage({
    required String tag,
    required String message,
    Object? data,
  }) {
    final buffer = StringBuffer('[$tag] $message');

    if (data != null) {
      buffer.write(' | data=${sanitizeValue(data)}');
    }

    return buffer.toString();
  }

  static bool _isSensitiveKey(String? key) {
    if (key == null || key.isEmpty) {
      return false;
    }

    final normalizedKey = key.toLowerCase();
    return normalizedKey.contains('password') ||
        normalizedKey.contains('token') ||
        normalizedKey.contains('authorization') ||
        normalizedKey.contains('secret') ||
        normalizedKey.contains('cookie');
  }

  static String _redact(Object? value) {
    final text = value?.toString();
    return '<redacted:${mask(text)}>';
  }
}

class _DebugOnlyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => kDebugMode;
}
