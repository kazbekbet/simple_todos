import 'package:intl/intl.dart';

/// --> Класс работы с датой и временем
class DateTimeUtils {
  static String getDateTimeByStandardFormat({required DateTime date}) {
    return DateFormat("dd/MM в HH:mm").format(DateTime.parse(date.toLocal().toString()));
  }

  static Duration getDifferenceWith({required DateTime fromDate, required DateTime toDate}) {
    return fromDate.difference(toDate);
  }

  static String getDifferenceByFormat({required DateTime fromDate, required DateTime toDate}) {
    int result = getDifferenceWith(fromDate: fromDate, toDate: toDate).inSeconds;

    if (result >= 86400) {
      return '${(result / 86400).round()} дн.';
    }

    if (result < 86400 && result >= 3600) {
      return '${(result / 3600).round()} ч.';
    }

    if (result < 3600 && result >= 60) {
      return '${(result / 60).round()} мин.';
    }

    return '$result сек.';
  }
}
