import 'package:intl/intl.dart';

class Utils {

  static String toDate(DateTime dateTime) {
    final date = DateFormat.MMMEd().format(dateTime);

    return '$date';
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return '$time';
  }

  static DateTime roundOffMinute(DateTime dateTime) {
    int roundedMinute = dateTime.minute < 30 ? 30 : 0;
    final newDateTime = dateTime.subtract(Duration(minutes: dateTime.minute % 30)).add(Duration(minutes: roundedMinute));
    return DateTime(
      newDateTime.year,
      newDateTime.month,
      newDateTime.day,
      newDateTime.hour,
      roundedMinute,
    );
  }

  static String dayAbbreviation(DateTime fromDate) {
    int weekday = fromDate.weekday;
    switch(weekday) {
      case 1:
        return 'MO'; // The switch statement must be told to exit, or it will execute every case.
      case 2:
        return 'TU';
      case 3:
        return 'WE';
      case 4:
        return 'TH';
      case 5:
        return 'FR';
      case 6:
        return 'SA';
      case 7:
        return 'SU';
      default: return '';
    }
  }

}