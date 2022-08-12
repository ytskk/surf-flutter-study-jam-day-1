import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/auth/auth.dart';
import 'package:surf_practice_chat_flutter/features/chat/cubit/chat/chat_cubit.dart';
import 'package:surf_practice_chat_flutter/features/chat/cubit/message/message_bloc.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_location_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_user_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';
import 'package:surf_practice_chat_flutter/shared/shared.dart';
import 'package:timeago/timeago.dart' as timeago;

/// Main screen of chat app, containing messages.
class ChatScreen extends StatefulWidget {
  // /// Repository for chat functionality.
  // final IChatRepository chatRepository;

  /// Constructor for [ChatScreen].
  const ChatScreen({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final ChatTopicDto topic;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepositoryProvider<IChatRepository>(
      create: (context) => ChatRepository(
        context.read<AuthRepository>().authorizedStudyJamClient,
      ),
      child: BlocProvider<ChatCubit>(
        create: (context) =>
            ChatCubit(context.read<IChatRepository>())..loadTopic(widget.topic),
        child: BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(context.read<ChatCubit>()),
          child: Scaffold(
            backgroundColor: colorScheme.background,
            appBar: _ChatAppBar(
              topic: widget.topic,
            ),
            body: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoadSuccess) {
                  final List<ChatMessageDto> messages = state.messages;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _ChatBody(
                          messages: messages,
                        ),
                      ),
                      const _ChatTextField(),
                    ],
                  );
                }

                return Text('loading');
              },
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _onUpdatePressed() async {
  //   final messages = await widget.chatRepository.getMessages();
  //   setState(() {
  //     _currentMessages = messages;
  //   });
  // }
  //
  // Future<void> _onSendPressed(String messageText) async {
  //   final messages = await widget.chatRepository.sendMessage(messageText);
  //   setState(() {
  //     _currentMessages = messages;
  //   });
  // }
}

class _ChatBody extends StatelessWidget {
  final Iterable<ChatMessageDto> messages;

  const _ChatBody({
    required this.messages,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet'),
      );
    }
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final ChatMessageDto message = messages.elementAt(index);
        return _ChatMessage(
          chatData: message,
        );
      },
    );
  }
}

class _ChatTextField extends StatelessWidget {
  const _ChatTextField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    final TextEditingController controller = TextEditingController();

    return Material(
      color: colorScheme.surface,
      elevation: 12,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.padding.bottom + 8,
          left: 16,
        ),
        child: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    onChanged: (newValue) {
                      context.read<MessageBloc>().add(
                            MessageChanged(message: newValue),
                          );
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) => context
                        .read<MessageBloc>()
                        .state
                        .message
                        .error
                        ?.message,
                    decoration: const InputDecoration(
                      hintText: 'Сообщение',
                    ),
                  ),
                ),
                CupertinoButton(
                  // TODO: disable if text is empty and validate.
                  onPressed:
                      state.message.value.isEmpty || state.status.isInvalid
                          ? null
                          : () {
                              context.read<MessageBloc>().add(
                                    const MessageSend(),
                                  );
                              controller.clear();
                            },
                  padding: EdgeInsets.zero,
                  child: const Icon(
                    CupertinoIcons.arrow_up_circle_fill,
                    size: 32,
                  ),
                  // color: colorScheme.onSurface,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ChatAppBar extends StatelessWidget with PreferredSizeWidget {
  const _ChatAppBar({
    Key? key,
    // required this.onUpdatePressed,
    // required this.controller,
    required this.topic,
  }) : super(key: key);

  // final VoidCallback onUpdatePressed;
  final ChatTopicDto topic;

  // final TextEditingController controller;

  static const double appBarHeight = 48.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: topic.name != null
          ? Hero(
              tag: 'topic_name-${topic.id}',
              child: Text(topic.name!),
            )
          : null,
      actions: [
        IconButton(
          onPressed: () {
            context.read<ChatCubit>().loadTopic(topic);
          },
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class _ChatMessage extends StatelessWidget {
  const _ChatMessage({
    required this.chatData,
    Key? key,
  }) : super(key: key);

  final ChatMessageDto chatData;

  @override
  Widget build(BuildContext context) {
    return _ChatMessageItem(chatData: chatData);
  }
}

class _ChatMessageItem extends StatelessWidget {
  const _ChatMessageItem({
    Key? key,
    required this.chatData,
  }) : super(key: key);

  final ChatMessageDto chatData;

  @override
  Widget build(BuildContext context) {
    final isMessageEmpty =
        chatData.message == null || chatData.message!.isEmpty;
    print(chatData.runtimeType);

    return ListTile(
      leading: _ChatAvatar(userData: chatData.chatUserDto),
      subtitle: Text(timeago.format(chatData.createdDateTime)),
      title: Text(
        isMessageEmpty ? 'Сообщение отсутствует' : chatData.message!,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: chatData.runtimeType == ChatMessageGeolocationDto
          ? IconButton(
              icon: const Icon(CupertinoIcons.map_fill),
              onPressed: () {
                final location = chatData as ChatMessageGeolocationDto;
                MapLauncher.launch(location.location);
                // launch(mapUrl);
              },
            )
          : null,
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  static const double _size = 32;

  final ChatUserDto userData;

  const _ChatAvatar({
    required this.userData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String? username = _getInitials(userData.name);

    return SizedBox(
      width: _size,
      height: _size,
      child: Material(
        shape: const CircleBorder(),
        color: username != null ? _getAvatarColor(username) : Colors.red,
        // color: username != null
        //     ? Color()
        //     : Colors.red,
        child: username != null
            ? Center(
                child: Text(
                  username,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  String? _getInitials(String? name) {
    if (name == null) {
      return null;
    }

    if (!name.trim().contains(' ')) {
      return name.substring(0, 2);
    }

    final splitedName = name.split(' ');

    final initials = splitedName.reduce((value, element) => value + element[0]);

    return initials;
  }

  /// TODO: refactor this method.
  _getAvatarColor(String name) {
    final int hash = name.hashCode;
    var r = (hash & 0xFF0000) >> 16;
    var g = (hash & 0x00FF00) >> 8;
    var b = hash & 0x0000FF;

    return Color.fromRGBO(r, g, b, 1);
  }
}
