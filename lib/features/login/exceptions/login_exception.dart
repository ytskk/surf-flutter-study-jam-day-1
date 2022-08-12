import 'package:flutter/foundation.dart';

/// Exception, that occurs in authorization process.
@immutable
class LoginException implements Exception {
  /// Message, describing exception's explanation.
  final String message;

  /// Constructor for [LoginException].
  const LoginException(this.message);

  @override
  String toString() => 'AuthException(message: $message)';
}
