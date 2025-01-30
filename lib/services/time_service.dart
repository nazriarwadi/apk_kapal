import 'package:intl/intl.dart';

class TimeService {
  static String getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm', 'id_ID').format(now);
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
  }
}
