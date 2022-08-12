import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/features.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(const AuthState.unknown()) {
    on<AuthPreload>(_onAuthPreload);
    on<AuthStatusChanged>(_onAuthStatusChanged);
  }

  final AuthRepository _authRepository;

  Future<void> _onAuthStatusChanged(
      AuthStatusChanged event, Emitter<AuthState> emit) async {
    log('auth status changed: ${event.status}');
    switch (event.status) {
      case AuthStatus.unauthenticated:
        return emit(const AuthState.unauthenticated());
      case AuthStatus.authenticated:
        // TODO: get user from repository
        final user = await _tryGetUser();
        return emit(
          user != null
              ? AuthState.authenticated(user)
              : const AuthState.unauthenticated(),
        );
      case AuthStatus.unknown:
        return emit(const AuthState.unknown());
    }
  }

  Future _tryGetUser() async {
    try {
      final User? user = await _authRepository.getUser();
      log('user token: ${user}');
      return user;
    } catch (e) {
      log('error: $e');
      return null;
    }
  }

  Future _onAuthPreload(AuthPreload event, Emitter<AuthState> emit) async {
    final user = await _tryGetUser();
    log('user: $user');
    if (user != null) {
      return emit(AuthState.authenticated(user));
    }
    return emit(const AuthState.unauthenticated());
  }
}
