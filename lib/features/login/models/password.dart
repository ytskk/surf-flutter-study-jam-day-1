import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty(PasswordValidationErrorConstants.empty);

  final String message;
  const PasswordValidationError(this.message);
}

class PasswordValidationErrorConstants {
  static const String empty = 'Password cannot be empty';
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([value = '']) : super.dirty(value);

  @override
  PasswordValidationError? validator(String? value) {
    if (value?.isEmpty == true) {
      return PasswordValidationError.empty;
    }

    return null;
  }
}
