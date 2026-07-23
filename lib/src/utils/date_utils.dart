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

/// Returns all payment dates for [sub] within [rangeStart]..[rangeEnd] (inclusive).
/// Dates are normalized to midnight (no time component).
List<DateTime> getPaymentDaysInRange(
  SubscriptionEntry sub,
  DateTime rangeStart,
  DateTime rangeEnd,
) {
  // Normalize all dates to midnight
  var current = DateTime(
    sub.startDay.year,
    sub.startDay.month,
    sub.startDay.day,
  );
  final start = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
  final end = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);

  // Compute effective end date from repeatXTimes / repeatUntil
  DateTime? effectiveEnd;
  if (sub.repeatUntil != null) {
    effectiveEnd = DateTime(
      sub.repeatUntil!.year,
      sub.repeatUntil!.month,
      sub.repeatUntil!.day,
    );
  } else if (sub.repeatXTimes != null) {
    final last = addDuration(
      current,
      (sub.repeatXTimes! - 1) * sub.frequency,
      sub.unitOfTime,
    );
    effectiveEnd = DateTime(last.year, last.month, last.day);
  }

  if (sub.cancelledAt != null) {
    final cancelled = DateTime(
      sub.cancelledAt!.year,
      sub.cancelledAt!.month,
      sub.cancelledAt!.day,
    );
    // If it was cancelled, the effective end is the earlier of the natural end and the cancel date.
    // However, payments on the exact day of cancellation are typically omitted or included?
    // Let's include payments up to the day before cancellation, or exactly on cancellation?
    // If they cancel today, they don't want today's payment? Or they do?
    // Let's say cancelled date is strictly the cut-off. If a payment is ON the cancellation day,
    // usually we don't count it if they cancelled before it processed, but let's just use `isAfter` or `isBefore`.
    if (effectiveEnd == null || cancelled.isBefore(effectiveEnd)) {
      // Exclude the cancellation day itself by subtracting one day,
      // or just keep it as the limit. Let's just use it as limit:
      effectiveEnd = cancelled.subtract(const Duration(days: 1));
    }
  }

  // Fast-forward to rangeStart
  while (current.isBefore(start)) {
    current = addDuration(current, sub.frequency, sub.unitOfTime);
  }

  final days = <DateTime>[];
  while (!current.isAfter(end)) {
    if (effectiveEnd == null || !current.isAfter(effectiveEnd)) {
      days.add(current);
    }
    current = addDuration(current, sub.frequency, sub.unitOfTime);
  }
  return days;
}

/// Returns true if the subscription is currently active (has future payments
/// and has not been manually cancelled).
bool isActive(SubscriptionEntry sub) {
  // Manually cancelled
  if (sub.cancelledAt != null) return false;

  // Naturally ended via repeatUntil
  if (sub.repeatUntil != null) {
    final today = DateTime.now();
    final end = DateTime(
      sub.repeatUntil!.year,
      sub.repeatUntil!.month,
      sub.repeatUntil!.day,
    );
    if (end.isBefore(DateTime(today.year, today.month, today.day))) {
      return false;
    }
  }

  // Naturally ended via repeatXTimes (last payment is in the past)
  if (sub.repeatXTimes != null) {
    final start = DateTime(
      sub.startDay.year,
      sub.startDay.month,
      sub.startDay.day,
    );
    final lastPayment = addDuration(
      start,
      (sub.repeatXTimes! - 1) * sub.frequency,
      sub.unitOfTime,
    );
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );
    if (lastPayment.isBefore(today)) return false;
  }

  return true;
}
