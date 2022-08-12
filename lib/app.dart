import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'features/features.dart';
import 'shared/shared.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<LocalDB>(
      create: (_) => LocalDB(),
      child: RepositoryProvider<AuthRepository>(
        create: (context) => AuthRepository(context.read<LocalDB>()),
        child: BlocProvider<AuthBloc>(
          create: (context) =>
              AuthBloc(context.read<AuthRepository>())..add(AuthPreload()),
          child: AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          log('state status: ${state.status}');
          if (state.status == AuthStatus.unauthenticated) {
            return const LoginScreen();
          }
          if (state.status == AuthStatus.authenticated) {
            return const TopicsScreen();
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
