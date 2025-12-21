import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart';

enum LogLevel { trace, debug, info, warning, error, fatal, none }

class AppLogger {
  static LogLevel logLevel = LogLevel.debug;
  static final _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          printTime: false
      ),
    ),
  );

  static void t(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.trace, message, error: error, stackTrace: stackTrace);
  }

  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  static void f(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.fatal, message, error: error, stackTrace: stackTrace);
  }


  static void _log(LogLevel level, String message,
      {Object? error, StackTrace? stackTrace}) {
    if (level.index >= logLevel.index) {
      final logMessage = '[$level]: $message';
      if (kDebugMode) {
        switch (level) {
          case LogLevel.trace:
            _logger.t(message);
            break;
          case LogLevel.debug:
            _logger.d(message);
            break;
          case LogLevel.info:
            _logger.i(message);
            break;
          case LogLevel.warning:
            _logger.w(message);
            break;
          case LogLevel.error:
            _logger.e(message, error: error, stackTrace: stackTrace);
            break;
          case LogLevel.fatal:
            _logger.f(message, error: error, stackTrace: stackTrace);
            break;
          default:
            _logger.d(logMessage);
        }
      }

    }
  }


  static void setLogLevel(LogLevel level) {
    logLevel = level;
  }
}