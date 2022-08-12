part of 'login_bloc.dart';

class LoginState extends Equatable {
  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.exception,
  });

  final FormzStatus status;
  final Username username;
  final Password password;
  final LoginException? exception;

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    LoginException? exception,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      exception: exception ?? this.exception,
    );
  }

  @override
  List<Object> get props => [
        status,
        username,
        password,
        exception ?? 0,
      ];
}
