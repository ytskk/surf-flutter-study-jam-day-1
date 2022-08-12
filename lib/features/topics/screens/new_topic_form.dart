import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/new_topic_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/widgets/validating_textformfield.dart';

class NewTopicForm extends StatelessWidget {
  const NewTopicForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create Topic',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Create a new topic for your study jam.\nBe reasonable when creating a new topic!',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge!.copyWith(
              fontSize: 17,
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 64.0),
          ValidatingTextField(
            placeholder: 'Name',
            buildWhen: (prev, curr) => prev.name != curr.name,
            onChanged: (newValue) => context.read<NewTopicBloc>().add(
                  NameChanged(name: newValue),
                ),
            validator: (_) =>
                context.read<NewTopicBloc>().state.name.error?.message,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: 16),
          ValidatingTextField(
            placeholder: 'Description',
            buildWhen: (prev, curr) => prev.description != curr.description,
            onChanged: (newValue) => context.read<NewTopicBloc>().add(
                  DescriptionChanged(description: newValue),
                ),
            validator: (_) =>
                context.read<NewTopicBloc>().state.description.error?.message,
            onFieldSubmitted: (_) => log(
                'password: ${context.read<NewTopicBloc>().state.description.value}'),
            maxLines: null,
          ),
          const SizedBox(height: 32),
          _CreateButton(),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewTopicBloc, NewTopicState>(
      listener: (context, state) {
        if (state.newTopic != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Success'),
                  actions: [
                    CupertinoButton(
                      child: const Text('Go to New topic'),
                      onPressed: () {
                        log('navigation');
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(builder: (BuildContext context) {
                            return ChatScreen(topic: state.newTopic!);
                          }),
                        );
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Close'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        }
      },
      builder: (context, state) {
        return CupertinoButton.filled(
          child: const Text('Create'),
          onPressed:
              state.status.isValid && !state.status.isSubmissionInProgress
                  ? () => context.read<NewTopicBloc>().add(
                        NewTopicSubmitted(),
                      )
                  : null,
        );
      },
    );
  }
}
