part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoadInProgress extends ChatState {}

class ChatLoadSuccess extends ChatState {
  const ChatLoadSuccess({
    required this.messages,
    required this.chat,
  });

  final List<ChatMessageDto> messages;
  final ChatTopicDto chat;

  @override
  List<Object> get props => [
        messages,
        chat,
      ];
}

class ChatLoadFailure extends ChatState {
  const ChatLoadFailure({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
