import 'package:formz/formz.dart';

enum DescriptionValidationError {
  tooLong(DescriptionValidationErrorConstants.tooLong);

  final String message;
  const DescriptionValidationError(this.message);
}

class DescriptionValidationErrorConstants {
  static const String tooLong =
      'Topic name cannot be longer than ${DescriptionValidationConstants.maxLength} characters';
}

class DescriptionValidationConstants {
  static const int maxLength = 1024;
}

class Description extends FormzInput<String, DescriptionValidationError> {
  const Description.pure() : super.pure('');
  const Description.dirty([value = '']) : super.dirty(value);

  @override
  DescriptionValidationError? validator(String? value) {
    if (value!.length > DescriptionValidationConstants.maxLength) {
      return DescriptionValidationError.tooLong;
    }

    return null;
  }
}
