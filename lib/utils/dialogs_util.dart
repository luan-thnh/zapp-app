import 'package:flutter/material.dart';
import 'package:messenger/widgets/circular_progress_gradient.dart';

class DialogsUtil {
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const CircularProgressGradient(),
    );
  }
}
