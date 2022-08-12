import 'package:flutter/foundation.dart';

/// DTO, containing auth token.
///
/// May be scaled, to implement token's duration & toJson() fromJson() methods.
@immutable
class TokenDto {
  /// Token's value.
  final String token;

  /// Constructor for [TokenDto].
  const TokenDto({
    required this.token,
  });

  const TokenDto.empty() : this(token: '');

  factory TokenDto.fromJson(Map<String, dynamic> json) {
    return TokenDto(
      token: json['token'] as String,
    );
  }

  @override
  String toString() {
    return 'TokenDto(token: $token)';
  }
}
