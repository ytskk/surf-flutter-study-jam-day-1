import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/features.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._authRepository) : super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  final AuthRepository _authRepository;

  void _onUsernameChanged(
      LoginUsernameChanged event, Emitter<LoginState> emit) {
    final Username username = Username.dirty(event.username);

    emit(
      state.copyWith(
        username: username,
        status: Formz.validate(
          [
            username,
            state.password,
          ],
        ),
      ),
    );
  }

  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final Password password = Password.dirty(event.password);

    emit(
      state.copyWith(
        password: password,
        status: Formz.validate(
          [
            state.username,
            password,
          ],
        ),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event, Emitter<LoginState> emit) async {
    if (state.status.isValidated) {
      emit(
        state.copyWith(
          status: FormzStatus.submissionInProgress,
        ),
      );
      try {
        final TokenDto token = await _authRepository.signIn(
          login: state.username.value,
          password: state.password.value,
        );

        // TODO: save token.

        emit(
          state.copyWith(
            status: FormzStatus.submissionSuccess,
          ),
        );
      } on LoginException catch (e) {
        emit(
          state.copyWith(
            status: FormzStatus.submissionFailure,
            exception: e,
          ),
        );
      }
    }
  }
}
