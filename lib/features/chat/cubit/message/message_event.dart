part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class MessageChanged extends MessageEvent {
  const MessageChanged({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}

class MessageSend extends MessageEvent {
  const MessageSend();
}
