import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:table_calendar/table_calendar.dart";

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(now.year - 1),
        lastDay: DateTime.utc(now.year + 1),
        focusedDay: now,
        rowHeight: 45,
        sixWeekMonthsEnforced: true,
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
        calendarStyle: CalendarStyle(
          cellMargin: const EdgeInsets.all(3.0),
          cellPadding: EdgeInsets.zero,
          todayDecoration: BoxDecoration(
            color: colors.primaryContainer,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10.0),
          ),
          todayTextStyle: TextStyle(
            color: colors.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
          defaultTextStyle: TextStyle(fontWeight: FontWeight.w500),
          weekendTextStyle: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
