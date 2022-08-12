import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/features.dart';

class User extends Equatable {
  const User(this.token);

  final TokenDto token;

  factory User.fromTokenString(String token) {
    return User(TokenDto(token: token));
  }

  @override
  List<Object?> get props => [token];

  static const empty = User(TokenDto.empty());
}
