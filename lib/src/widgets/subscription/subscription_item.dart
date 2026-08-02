import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/views/subscription_details_page.dart';
import 'package:amber_calendar/src/widgets/subscription/subscription_avatar.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:amber_calendar/src/providers/settings_provider.dart';
import 'package:amber_calendar/src/utils/currency_utils.dart';

class SubscriptionItem extends StatefulWidget {
  final SubscriptionEntry subscription;
  final VoidCallback? onChanged;
  final String heroTagPrefix;

  const SubscriptionItem({
    super.key,
    required this.subscription,
    this.onChanged,
    this.heroTagPrefix = '',
  });

  @override
  State<SubscriptionItem> createState() => _SubscriptionItemState();
}

class _SubscriptionItemState extends State<SubscriptionItem> {
  String _getRecurrenceText(BuildContext context) {
    final sub = widget.subscription;
    final freq = sub.frequency;
    final unit = sub.unitOfTime;
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
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;
    final formattedPrice = CurrencyUtils.format(context, widget.subscription.price, currencySymbol);

    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SubscriptionDetailsPage(
              subscription: widget.subscription,
              heroTagPrefix: widget.heroTagPrefix,
            ),
          ),
        );
        if (result == true) {
          widget.onChanged?.call();
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ).copyWith(right: 20),
                  child: Hero(
                    tag:
                        '${widget.heroTagPrefix}avatar_${widget.subscription.id}',
                    child: SubscriptionAvatar(
                      name: widget.subscription.name,
                      websiteUrl: widget.subscription.websiteUrl,
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
          ),
          Text(
            formattedPrice,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
