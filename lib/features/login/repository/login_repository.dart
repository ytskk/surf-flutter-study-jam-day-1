import 'package:surf_practice_chat_flutter/features/features.dart';
import 'package:surf_study_jam/surf_study_jam.dart';

/// Basic interface of authorization logic.
///
/// Has 2 methods: [signIn] & [signOut].
abstract class ILoginRepository {
  /// Signs the user in via [login] & [password].
  ///
  /// [login] is a `String` representation of login,
  /// that was used in registration.
  ///
  /// [password] is a `String` representation of a password,
  /// that was used in registration.
  ///
  /// [TokenDto] is a model, containing its' value, that should be
  /// retrieved in the end of authorization process.
  ///
  /// May throw an [LoginException].
  Future<TokenDto> signIn({
    required String login,
    required String password,
  });

  /// Signs the user out, clearing all unneeded credentials.
  Future<void> signOut();
}

/// Simple implementation of [ILoginRepository], using [StudyJamClient].
class LoginRepository implements ILoginRepository {
  final StudyJamClient _studyJamClient;

  /// Constructor for [LoginRepository].
  LoginRepository(this._studyJamClient);

  @override
  Future<TokenDto> signIn({
    required String login,
    required String password,
  }) async {
    try {
      final token = await _studyJamClient.signin(login, password);

      return TokenDto(token: token);
    } on Exception catch (e) {
      throw LoginException(e.toString());
    }
  }

  @override
  Future<void> signOut() {
    return _studyJamClient.logout();
  }
}
