import 'package:amber_calendar/src/local/app_database.dart';

/// Adds a specified [amount] of time (days, weeks, months, years) based on [unit] to a [date].
DateTime addDuration(DateTime date, int amount, UnitOfTime unit) {
  switch (unit) {
    case UnitOfTime.day:
      return date.add(Duration(days: amount));
    case UnitOfTime.week:
      return date.add(Duration(days: amount * 7));
    case UnitOfTime.month:
      var year = date.year;
      var month = date.month + amount;
      while (month > 12) {
        year += 1;
        month -= 12;
      }
      while (month < 1) {
        year -= 1;
        month += 12;
      }
      int day = date.day;
      final lastDayOfNewMonth = DateTime(year, month + 1, 0).day;
      if (day > lastDayOfNewMonth) {
        day = lastDayOfNewMonth;
      }
      return DateTime(
        year,
        month,
        day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
    case UnitOfTime.year:
      var year = date.year + amount;
      int month = date.month;
      int day = date.day;
      final lastDayOfNewMonth = DateTime(year, month + 1, 0).day;
      if (day > lastDayOfNewMonth) {
        day = lastDayOfNewMonth;
      }
      return DateTime(
        year,
        month,
        day,
        date.hour,
        date.minute,
        date.second,
        date.millisecond,
        date.microsecond,
      );
  }
}
