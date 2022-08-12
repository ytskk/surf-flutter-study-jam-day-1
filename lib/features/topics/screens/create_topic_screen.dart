import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/auth/auth.dart';
import 'package:surf_practice_chat_flutter/features/topics/bloc/new_topic_bloc.dart';
import 'package:surf_practice_chat_flutter/features/topics/cubit/topics_cubit.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chat_topics_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/screens/new_topic_form.dart';

/// Screen, that is used for creating new chat topics.
class CreateTopicScreen extends StatelessWidget {
  /// Constructor for [CreateTopicScreen].
  const CreateTopicScreen(
    BuildContext context, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IChatTopicsRepository>(
      create: (context) => ChatTopicsRepository(
        context.read<AuthRepository>().authorizedStudyJamClient,
      ),
      child: BlocProvider<NewTopicBloc>(
        create: (context) =>
            NewTopicBloc(context.read<IChatTopicsRepository>()),
        child: Scaffold(
          appBar: AppBar(),
          body: ListView(
            children: [
              NewTopicForm(),
            ],
          ),
        ),
      ),
    );
  }
}
