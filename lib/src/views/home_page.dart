import "package:amber_calendar/src/widgets/calendar.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  final bool isDynamic;

  const HomePage({super.key, required this.isDynamic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(children: [const Calendar()]),
      ),
    );
  }
}
