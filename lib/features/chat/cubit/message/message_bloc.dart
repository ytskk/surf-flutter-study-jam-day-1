import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/chat/cubit/chat/chat_cubit.dart';
import 'package:surf_practice_chat_flutter/features/chat/exceptions/invalid_message_exception.dart';
import 'package:surf_practice_chat_flutter/features/chat/models/message.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc(this._chatCubit) : super(const MessageState()) {
    on<MessageChanged>(_onMessageChanged);
    on<MessageSend>(_onMessageSend);
  }

  // BAD, but for now it's ok)
  final ChatCubit _chatCubit;

  void _onMessageChanged(MessageChanged event, Emitter<MessageState> emit) {
    final Message message = Message.dirty(event.message);

    emit(
      state.copyWith(
        message: message,
        status: Formz.validate([
          message,
        ]),
      ),
    );
  }

  Future<void> _onMessageSend(
      MessageSend event, Emitter<MessageState> emit) async {
    await _chatCubit.sendMessage(state.message.value);
    log('sending: ${state.message.value}');
    emit(
      state.copyWith(
        message: const Message.pure(),
      ),
    );
  }
}
