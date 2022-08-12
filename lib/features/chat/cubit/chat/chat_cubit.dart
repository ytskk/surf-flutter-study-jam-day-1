import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/chat_message_dto.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';
import 'package:surf_practice_chat_flutter/features/topics/models/chat_topic_dto.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit(
    this._chatRepository,
  ) : super(ChatInitial());

  final IChatRepository _chatRepository;

  void loadTopic(ChatTopicDto chat) async {
    final response = await _chatRepository.getMessages(chatId: chat.id);

    log('loading topic: ${chat.id}');
    final List<ChatMessageDto> messages = response.toList();

    emit(
      ChatLoadSuccess(
        messages: messages,
        chat: chat,
      ),
    );
  }

  // void getMessages(ChatTopicDto chat) async {
  //   final response = await _chatRepository.getMessages(chatId: chat.id);
  //
  //   log('loading topic: ${chat.id}');
  //   final List<ChatMessageDto> messages = response.toList();
  //
  //   emit(
  //     ChatLoadSuccess(
  //       messages: messages,
  //       chat: chat,
  //     ),
  //   );
  // }

  Future<void> sendMessage(String message) async {
    final s = state as ChatLoadSuccess;
    log('sending: ${message} to chat: ${s.chat.id}, ${s.chat.name}');
    final res = await _chatRepository.sendMessage(message, chatId: s.chat.id);
    emit(
      ChatLoadSuccess(
        messages: res.toList(),
        chat: s.chat,
      ),
    );
  }
}
