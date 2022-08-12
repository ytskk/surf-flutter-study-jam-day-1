import 'dart:async';
import 'dart:developer';

import 'package:surf_practice_chat_flutter/features/features.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

class AuthRepository {
  AuthRepository(this._localDB);

  User? _user;
  final LocalDB _localDB;
  // TODO: DI
  StudyJamClient _studyJamClient = StudyJamClient();

  Future<User?> getUser() async {
    if (_user != null) {
      return _user!;
    }

    final String? userToken = await _localDB.getUserToken();
    if (userToken != null) {
      _user = User.fromTokenString(userToken);
      // TODO: replace with get user, not just token.
      _studyJamClient = _studyJamClient.getAuthorizedClient(_user!.token.token);
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
      // _studyJamClient = _studyJamClient.getAuthorizedClient(token);

      return TokenDto(token: token);
    } on Exception catch (e) {
      throw LoginException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _localDB.clearUserToken();

    log('sign out', name: 'AuthRepository::signOut');
    return authorizedStudyJamClient.logout();
  }

  StudyJamClient get authorizedStudyJamClient =>
      _studyJamClient.getAuthorizedClient(_user!.token.token);
}
