import 'package:intl/intl.dart';

class Util {
  static String formatTime(DateTime time, {String locale: ''}) =>
      "${new DateFormat.yMd().format(time)} at ${new DateFormat.jms().format(time)}";
}
