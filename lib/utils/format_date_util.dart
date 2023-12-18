import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormatDateUtil {
  static String getFormattedTime(BuildContext context, String? time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time!));

    if (time.isEmpty) return '';

    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getLastMessageTime(BuildContext context, String time) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    if (now.day == sent.day && now.month == sent.month && now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    } else if (now.difference(sent).inDays < 7) {
      return DateFormat('EEE HH:mm').format(sent);
    } else {
      return DateFormat('HH:mm, dd MMM, yyyy').format(sent);
    }
  }

  static String formatDuration(String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));

    DateTime now = DateTime.now();
    Duration duration = now.difference(date);

    if (duration.inDays > 365) {
      return DateFormat('yyyy/MM/dd').format(DateTime.now().subtract(duration));
    } else if (duration.inDays > 30) {
      return DateFormat('MM/dd').format(DateTime.now().subtract(duration));
    } else if (duration.inDays > 0) {
      return DateFormat('dd/MM').format(DateTime.now().subtract(duration));
    } else if (duration.inHours > 0) {
      return "${duration.inHours}h";
    } else if (duration.inMinutes > 0) {
      return "${duration.inMinutes}m";
    } else {
      return "now";
    }
  }

  static String formatDurationTime(Duration duration) {
    final formatter = DateFormat('mm:ss');
    return formatter.format(DateTime(0, 0, 0, 0, 0, duration.inSeconds));
  }
}
