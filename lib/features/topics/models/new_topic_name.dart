import 'package:formz/formz.dart';

enum NameValidationError {
  empty(NameValidationErrorConstants.empty),
  tooLong(NameValidationErrorConstants.tooLong);

  final String message;
  const NameValidationError(this.message);
}

class NameValidationErrorConstants {
  static const String empty = 'Topic name cannot be empty';
  static const String tooLong =
      'Topic name cannot be longer than ${NameValidationConstants.maxLength} characters';
}

class NameValidationConstants {
  static const int maxLength = 80;
}

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([value = '']) : super.dirty(value);

  @override
  NameValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return NameValidationError.empty;
    }

    if (value!.length > NameValidationConstants.maxLength) {
      return NameValidationError.tooLong;
    }

    return null;
  }
}
