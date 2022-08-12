part of 'message_bloc.dart';

class MessageState extends Equatable {
  const MessageState({
    this.message = const Message.pure(),
    this.status = FormzStatus.pure,
    this.exception,
  });

  final FormzStatus status;
  final Message message;
  final InvalidMessageException? exception;

  MessageState copyWith({
    FormzStatus? status,
    Message? message,
    InvalidMessageException? exception,
  }) =>
      MessageState(
        status: status ?? this.status,
        message: message ?? this.message,
        exception: exception ?? this.exception,
      );

  @override
  List<Object?> get props => [
        status,
        message,
        exception ?? 0,
      ];
}
