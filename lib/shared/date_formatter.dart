import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(
    DateTime date, {
    String pattern = DateFormats.messageDate,
  }) {
    return DateFormat(pattern).format(date);
  }
}

class DateFormats {
  static const messageDate = 'D H:mm';
}
