import 'package:formz/formz.dart';
import 'package:surf_practice_chat_flutter/features/chat/repository/chat_repository.dart';

enum MessageValidationError {
  tooLong(MessageValidationErrorConstants.tooLong);

  final String message;
  const MessageValidationError(this.message);
}

class MessageValidationErrorConstants {
  static const String tooLong =
      'Maximum length of message is ${IChatRepository.maxMessageLength} characters';
}

class Message extends FormzInput<String, MessageValidationError> {
  const Message.pure() : super.pure('');
  const Message.dirty([value = '']) : super.dirty(value);

  @override
  MessageValidationError? validator(String? value) {
    if (value!.length > IChatRepository.maxMessageLength) {
      return MessageValidationError.tooLong;
    }

    return null;
  }
}
