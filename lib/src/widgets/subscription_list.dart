import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/widgets/subscription/subscription_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SubscriptionList extends StatefulWidget {
  final VoidCallback? onRefreshNeeded;
  final DateTime month;

  const SubscriptionList({
    super.key,
    required this.month,
    this.onRefreshNeeded,
  });

  @override
  State<SubscriptionList> createState() => SubscriptionListState();
}

class SubscriptionListState extends State<SubscriptionList> {
  List<SubscriptionEntry> subscriptionOfTheMonth = [];
  int? _monthlyTotalCents;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionOfTheMonth();
  }

  @override
  void didUpdateWidget(SubscriptionList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.month.year != oldWidget.month.year ||
        widget.month.month != oldWidget.month.month) {
      _loadSubscriptionOfTheMonth();
    }
  }

  Future<void> refresh() => _loadSubscriptionOfTheMonth();

  Future<void> _loadSubscriptionOfTheMonth() async {
    final repo = context.read<SubscriptionRepository>();
    final summary = await repo.getMonthSummary(widget.month);

    if (mounted) {
      setState(() {
        subscriptionOfTheMonth = summary.subscriptions;
        _monthlyTotalCents = summary.totalCents;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 92)),
        Row(
          children: [
            Text(
              context.loc.paymentThisMonth,
              style: const TextStyle(fontSize: 22),
            ),
            const Spacer(),
            _monthlyTotalCents == null
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    NumberFormat.currency(
                      symbol: '€',
                      decimalDigits: 2,
                      locale: Localizations.localeOf(context).toString(),
                    ).format(_monthlyTotalCents! / 100),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: subscriptionOfTheMonth
                  .map(
                    (sub) => SubscriptionItem(
                      subscription: sub,
                      heroTagPrefix: 'home_',
                      onChanged: () {
                        refresh();
                        widget.onRefreshNeeded?.call();
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
