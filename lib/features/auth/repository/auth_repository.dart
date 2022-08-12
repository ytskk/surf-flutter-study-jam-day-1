import 'dart:async';
import 'dart:developer';

import 'package:surf_practice_chat_flutter/features/features.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class AuthRepository {
  AuthRepository(this._localDB);

  final _controller = StreamController<AuthStatus>();
  User? _user;
  final LocalDB _localDB;
  // TODO: DI
  final _studyJamClient = StudyJamClient();

  Future<User?> getUser() async {
    if (_user != null) {
      return _user!;
    }

    final String? userToken = await _localDB.getUserToken();
    if (userToken != null) {
      _user = User.fromTokenString(userToken);
      // TODO: replace with get user, not just token.
      return _user!;
    }

    return null;
  }

  Future<TokenDto> signIn({
    required String login,
    required String password,
  }) async {
    try {
      final token = await _studyJamClient.signin(login, password);
      _localDB.setUserToken(token);
      _controller.add(AuthStatus.authenticated);

      return TokenDto(token: token);
    } on Exception catch (e) {
      throw LoginException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _localDB.clearUserToken();

    // return _studyJamClient.logout();
  }
}
