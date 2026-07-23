import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/utils/date_utils.dart';
import 'package:amber_calendar/src/widgets/subscription/subscription_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Lists ALL subscriptions (not just this month's), in creation order.
/// The FAB and Scaffold are managed by RootPage.
class AllSubscriptionsPage extends StatefulWidget {
  const AllSubscriptionsPage({super.key});

  @override
  State<AllSubscriptionsPage> createState() => AllSubscriptionsPageState();
}

class AllSubscriptionsPageState extends State<AllSubscriptionsPage> {
  List<SubscriptionEntry> _activeSubscriptions = [];
  List<SubscriptionEntry> _inactiveSubscriptions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> refresh() => _load();

  Future<void> _load() async {
    final repo = context.read<SubscriptionRepository>();
    final subs = await repo.getAll(); // get all

    if (mounted) {
      setState(() {
        _activeSubscriptions = subs.where((s) => isActive(s)).toList();
        _inactiveSubscriptions = subs.where((s) => !isActive(s)).toList();
        _isLoading = false;
      });
    }
  }

  Widget _buildList(List<SubscriptionEntry> list, ColorScheme colors) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: colors.outline),
            const SizedBox(height: 16),
            Text(
              context.loc.noSubscriptions,
              style: TextStyle(color: colors.outline),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: list.length,
      itemBuilder: (ctx, i) => SubscriptionItem(
        subscription: list[i],
        heroTagPrefix: 'all_',
        onChanged: refresh,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
              child: Text(
                context.loc.allSubscriptions,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            TabBar(
              labelColor: colors.primary,
              unselectedLabelColor: colors.outline,
              indicatorColor: colors.primary,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: colors.outlineVariant.withOpacity(0.5),
              tabs: [
                Tab(text: context.loc.filterActive),
                Tab(text: context.loc.filterInactive),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(_activeSubscriptions, colors),
                  _buildList(_inactiveSubscriptions, colors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
