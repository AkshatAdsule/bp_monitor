import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class Util {
  static String formatTime(DateTime time, {String locale: ''}) =>
      "${new DateFormat.yMd().format(time)} at ${new DateFormat.jms().format(time)}";

  static void showSnackBar(
    BuildContext context,
    String message, {
    int duration: 1500,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: duration),
        content: Text(
          message,
        ),
      ),
    );
  }
}
