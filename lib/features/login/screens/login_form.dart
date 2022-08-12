import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:surf_practice_chat_flutter/features/features.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              ErrorSnackBar.build(context, state.exception!.message),
            );

          return;
        }

        // if (state.status.isSubmissionSuccess) {}
      },
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValidatingTextField(
              placeholder: 'Login',
              buildWhen: (prev, curr) => prev.username != curr.username,
              onChanged: (newValue) => context.read<LoginBloc>().add(
                    LoginUsernameChanged(username: newValue),
                  ),
              validator: (_) =>
                  context.read<LoginBloc>().state.username.error?.message,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            ValidatingTextField(
              placeholder: 'Password',
              buildWhen: (prev, curr) => prev.password != curr.password,
              onChanged: (newValue) => context.read<LoginBloc>().add(
                    LoginPasswordChanged(password: newValue),
                  ),
              validator: (_) =>
                  context.read<LoginBloc>().state.password.error?.message,
              onFieldSubmitted: (_) => log(
                  'password: ${context.read<LoginBloc>().state.password.value}'),
              obscureText: true,
            ),
            const SizedBox(height: 32),
            const _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  const _LoginButton({Key? key}) : super(key: key);

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  late final RoundedLoadingButtonController _controller;

  @override
  void initState() {
    super.initState();

    _controller = RoundedLoadingButtonController();
    _controller.stateStream.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) async {
        if (state.status.isSubmissionFailure) {
          _controller.error();
        } else if (state.status.isSubmissionSuccess) {
          _controller.success();
        }

        Future.delayed(const Duration(seconds: 2), () {
          _controller.reset();
        });
      },
      buildWhen: (prev, curr) => prev.status != curr.status,
      builder: (context, state) {
        return RoundedLoadingButton(
          controller: _controller,
          onPressed: state.status.isValidated
              ? () {
                  context.read<LoginBloc>().add(const LoginSubmitted());
                }
              : null,
          child: const Text('Login'),
        );
      },
    );
  }
}
