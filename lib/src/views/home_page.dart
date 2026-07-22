import 'package:amber_calendar/src/views/add_subscription_page.dart';
import 'package:amber_calendar/src/widgets/calendar.dart';
import 'package:amber_calendar/src/widgets/fab_styles.dart';
import 'package:amber_calendar/src/widgets/subscription_list.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final bool isDynamic;

  const HomePage({super.key, required this.isDynamic});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _subscriptionListKey = GlobalKey<SubscriptionListState>();
  final _calendarKey = GlobalKey<CalendarState>();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Calendar(key: _calendarKey),
            Expanded(child: SubscriptionList(key: _subscriptionListKey)),
          ],
        ),
      ),
      floatingActionButton: Hero(
        tag: 'fab',
        flightShuttleBuilder: fabShuttleBuilder,
        child: FilledButton(
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddSubscriptionPage(),
              ),
            );
            _subscriptionListKey.currentState?.refresh();
            _calendarKey.currentState?.refresh();
          },
          style: fabStyle,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
