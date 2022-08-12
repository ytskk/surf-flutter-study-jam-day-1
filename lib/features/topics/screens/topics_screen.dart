import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:surf_practice_chat_flutter/features/auth/auth.dart';
import 'package:surf_practice_chat_flutter/features/auth/repository/auth_repository.dart';
import 'package:surf_practice_chat_flutter/features/chat/cubit/chat/chat_cubit.dart';
import 'package:surf_practice_chat_flutter/features/chat/screens/chat_screen.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/features/topics/topics.dart';
import 'package:surf_practice_chat_flutter/features/topics/repository/chat_topics_repository.dart';

/// Screen with different chat topics to go to.
class TopicsScreen extends StatelessWidget {
  /// Constructor for [TopicsScreen].
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IChatTopicsRepository>(
      create: (context) => ChatTopicsRepository(
        context.read<AuthRepository>().authorizedStudyJamClient,
      ),
      child: BlocProvider<TopicsCubit>(
        create: (context) =>
            TopicsCubit(context.read<IChatTopicsRepository>())..getTopics(),
        child: BlocBuilder<TopicsCubit, TopicsState>(
          builder: (context, state) {
            if (state is TopicsLoadInProgress) {
              return const _TopicsLoading();
            }

            if (state is TopicsLoadSuccess) {
              final topics = state.topics;
              return _TopicsLoaded(topics: topics);
            }

            if (state is TopicsLoadFailure) {
              return _TopicsLoadFailure(
                message: state.message,
              );
            }

            throw Error();
          },
        ),
      ),
    );
  }
}

class _TopicsLoading extends StatelessWidget {
  const _TopicsLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _TopicsLoaded extends StatelessWidget {
  const _TopicsLoaded({
    Key? key,
    required this.topics,
  }) : super(key: key);

  final List<ChatTopicDto> topics;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(Icons.logout),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text(
                        'Are you sure you want to logout?',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You will be logged out of the app.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    CupertinoButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthLogoutRequested());
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: const Text('Topics'),
      ),
      body: ListView.builder(
        itemCount: topics.length,
        itemBuilder: (BuildContext context, int index) {
          final ChatTopicDto topic = topics.elementAt(index);
          return ListTile(
            title: Hero(
              tag: 'topic_name-${topic.id}',
              flightShuttleBuilder: _flightShuttleBuilder,
              child: Text(topic.name ?? 'undefined'),
            ),
            subtitle:
                topic.description != null ? Text(topic.description!) : null,
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(builder: (BuildContext context) {
                  return ChatScreen(topic: topic);
                }),
              );
            },
          );
        },
      ),
    );
  }

  /// Default text style for hero tag.
  ///
  /// Prevents Hero red text.
  ///
  /// See also:
  /// - https://github.com/flutter/flutter/issues/30647
  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }
}

class _TopicsLoadFailure extends StatelessWidget {
  const _TopicsLoadFailure({
    Key? key,
    required this.message,
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Ук'),
    );
  }
}
