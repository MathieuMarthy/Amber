import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SubscriptionItem extends StatefulWidget {
  final SubscriptionEntry subscription;

  const SubscriptionItem({super.key, required this.subscription});

  @override
  State<SubscriptionItem> createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  String _getRecurrenceText(BuildContext context) {
    final sub = widget.subscription;
    final freq = sub.frequency;
    final unit = UnitOfTime.values[sub.unitOfTime];
    final day = sub.startDay.day;

    switch (unit) {
      case UnitOfTime.day:
        return context.loc.recurrenceDays(freq);
      case UnitOfTime.week:
        return context.loc.recurrenceWeeks(freq);
      case UnitOfTime.month:
        return context.loc.recurrenceMonths(freq, day);
      case UnitOfTime.year:
        return context.loc.recurrenceYears(freq);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final formattedPrice = NumberFormat.currency(
      symbol: '€',
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    ).format(widget.subscription.price / 100);

    return Row(
      children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(20),
              child: Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subscription.name,
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _getRecurrenceText(context),
                    style: TextStyle(color: colors.outline),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          formattedPrice,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ],
    );
  }
}
