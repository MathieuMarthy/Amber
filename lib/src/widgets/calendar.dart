import "package:amber_calendar/src/local/app_database.dart";
import "package:amber_calendar/src/repositories/subscription_repository.dart";
import "package:amber_calendar/src/utils/subscription_color.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:table_calendar/table_calendar.dart";

class Calendar extends StatefulWidget {
  final ValueChanged<DateTime>? onMonthChanged;

  const Calendar({super.key, this.onMonthChanged});

  @override
  State<Calendar> createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  Map<DateTime, List<SubscriptionEntry>> _paymentDayMap = {};

  @override
  void initState() {
    super.initState();
    _loadPaymentDays(_focusedDay);
  }

  Future<void> refresh() => _loadPaymentDays(_focusedDay);

  Future<void> _loadPaymentDays(DateTime focusedDay) async {
    // Cover the full 6-week range table_calendar may show
    final rangeStart = DateTime(
      focusedDay.year,
      focusedDay.month,
      1,
    ).subtract(const Duration(days: 7));
    final rangeEnd = DateTime(
      focusedDay.year,
      focusedDay.month + 1,
      0,
    ).add(const Duration(days: 7));

    final repo = context.read<SubscriptionRepository>();
    final map = await repo.getPaymentDayMap(rangeStart, rangeEnd);

    if (mounted) {
      setState(() {
        _paymentDayMap = map;
      });
    }
  }

  List<SubscriptionEntry> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _paymentDayMap[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TableCalendar<SubscriptionEntry>(
        firstDay: DateTime.utc(_focusedDay.year - 1),
        lastDay: DateTime.utc(_focusedDay.year + 1),
        focusedDay: _focusedDay,
        rowHeight: 45,
        sixWeekMonthsEnforced: true,
        eventLoader: _getEventsForDay,
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
          _loadPaymentDays(focusedDay);
          widget.onMonthChanged?.call(focusedDay);
        },
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) {
            return DateFormat.E(locale).format(date)[0].toUpperCase();
          },
        ),
        startingDayOfWeek: StartingDayOfWeek.monday,
        calendarStyle: const CalendarStyle(
          cellMargin: EdgeInsets.all(3.0),
          cellPadding: EdgeInsets.zero,
          defaultTextStyle: TextStyle(fontWeight: FontWeight.w500),
          weekendTextStyle: TextStyle(fontWeight: FontWeight.w500),
          // Hide the default markers — we use markerBuilder instead
          markerSize: 0,
        ),
        calendarBuilders: CalendarBuilders(
          todayBuilder: (context, day, focusedDay) {
            final colors = Theme.of(context).colorScheme;
            return Container(
              // Extra bottom margin leaves room for the markers below the blue box
              margin: const EdgeInsets.fromLTRB(3, 3, 3, 10),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: TextStyle(
                  color: colors.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
          markerBuilder: (context, date, subs) {
            if (subs.isEmpty) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: subs
                  .map(
                    (sub) => Container(
                      width: 5,
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: subscriptionColor(sub.name),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
