import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/widgets/subscription/subscription_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubscriptionList extends StatefulWidget {
  const SubscriptionList({super.key});

  @override
  State<SubscriptionList> createState() => SubscriptionListState();
}

class SubscriptionListState extends State<SubscriptionList> {
  List<SubscriptionEntry> subscriptionOfTheMonth = [];

  @override
  void initState() {
    super.initState();
    _loadSubscriptionOfTheMonth();
  }

  Future<void> refresh() => _loadSubscriptionOfTheMonth();

  Future<void> _loadSubscriptionOfTheMonth() async {
    final repo = context.read<SubscriptionRepository>();
    final subscriptions = await repo.getByMonth(DateTime.now());

    if (mounted) {
      setState(() {
        subscriptionOfTheMonth = subscriptions;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 92)),
        Text(
          context.loc.paymentThisMonth,
          style: const TextStyle(fontSize: 22),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: subscriptionOfTheMonth
                  .map((sub) => SubscriptionItem(subscription: sub))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
