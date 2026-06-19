import 'package:amber_calendar/src/views/add_subscription_page.dart';
import 'package:amber_calendar/src/widgets/calendar.dart';
import 'package:amber_calendar/src/widgets/fab_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final bool isDynamic;

  const HomePage({super.key, required this.isDynamic});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(children: [const Calendar()]),
      ),
      floatingActionButton: Hero(
        tag: 'fab',
        flightShuttleBuilder: fabShuttleBuilder,
        child: FilledButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddSubscriptionPage(),
              ),
            );
          },
          style: fabStyle,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
