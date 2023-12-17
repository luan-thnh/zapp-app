import 'package:flutter/material.dart';
import 'package:messenger/theme/colors_theme.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';

class DialogsUtil {
  static void showSnackBar(BuildContext context, String text, bool type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: const TextStyle(color: ColorsTheme.white, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(milliseconds: 500),
        backgroundColor: type ? ColorsTheme.green : ColorsTheme.red,
      ),
    );
  }

  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CircularProgressGradient(),
    );
  }
}
