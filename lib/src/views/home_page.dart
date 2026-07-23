import 'package:amber_calendar/src/widgets/calendar.dart';
import 'package:amber_calendar/src/widgets/subscription_list.dart';
import 'package:flutter/material.dart';

/// The body of the home tab: calendar + this month's subscription list.
/// The FAB and Scaffold are managed by RootPage.
class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => HomePageBodyState();
}

class HomePageBodyState extends State<HomePageBody> {
  final _subscriptionListKey = GlobalKey<SubscriptionListState>();
  final _calendarKey = GlobalKey<CalendarState>();
  DateTime _currentMonth = DateTime.now();

  void refresh() {
    _subscriptionListKey.currentState?.refresh();
    _calendarKey.currentState?.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Calendar(
              key: _calendarKey,
              onMonthChanged: (month) {
                if (mounted) {
                  setState(() => _currentMonth = month);
                }
              },
            ),
            Expanded(
              child: SubscriptionList(
                key: _subscriptionListKey,
                month: _currentMonth,
                onRefreshNeeded: () => _calendarKey.currentState?.refresh(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
