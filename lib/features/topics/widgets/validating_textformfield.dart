import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/new_topic_bloc.dart';

typedef ValidatingBuildWhenCallback = bool Function(
    NewTopicState, NewTopicState);

class ValidatingTextField extends StatelessWidget {
  const ValidatingTextField({
    Key? key,
    this.buildWhen,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.placeholder,
    this.obscureText = false,
    this.textInputAction,
    this.maxLines = 1,
  }) : super(key: key);

  final ValidatingBuildWhenCallback? buildWhen;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator? validator;
  final String? placeholder;
  final int? maxLines;

  /// Hide text in the field.
  final bool obscureText;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    // TODO: make builder more generic :_)
    return BlocBuilder<NewTopicBloc, NewTopicState>(
      buildWhen: buildWhen,
      builder: (context, state) {
        log('rebuilding $placeholder field');
        return TextFormField(
          onChanged: onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            label: placeholder != null ? Text(placeholder!) : null,
          ),
          obscureText: obscureText,
          maxLines: maxLines,
          textInputAction: textInputAction,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
        );
      },
    );
  }
}
