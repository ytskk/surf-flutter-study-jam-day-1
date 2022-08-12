import 'package:flutter/material.dart';
import 'package:surf_practice_chat_flutter/constants/constants.dart';

class ErrorSnackBar {
  const ErrorSnackBar._();

  static SnackBar build(BuildContext context,
      [String message = 'Something went wrong']) {
    // TODO: DI
    final colors = Theme.of(context).extension<AppColors>()!;

    return SnackBar(
      content: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Icon(
              Icons.warning,
              color: colors.red,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
      ),
      backgroundColor: colors.contrastingSecondary,
    );
  }
}
