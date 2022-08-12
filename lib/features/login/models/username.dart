import 'package:formz/formz.dart';

enum UsernameValidationError {
  empty(UsernameValidationErrorConstants.empty);

  final String message;
  const UsernameValidationError(this.message);
}

class UsernameValidationErrorConstants {
  static const String empty = 'Username cannot be empty';
}

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([value = '']) : super.dirty(value);

  @override
  UsernameValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return UsernameValidationError.empty;
    }

    return null;
  }
}
