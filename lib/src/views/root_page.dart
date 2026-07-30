import 'package:amber_calendar/src/views/add_subscription_page.dart';
import 'package:amber_calendar/src/views/all_subscriptions_page.dart';
import 'package:amber_calendar/src/views/home_page.dart';
import 'package:amber_calendar/src/views/settings_page.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/widgets/fab_styles.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;

  final _homeKey = GlobalKey<HomePageBodyState>();
  final _allSubsKey = GlobalKey<AllSubscriptionsPageState>();

  Future<void> _onAddPressed() async {
    final result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddSubscriptionPage()));
    if (result == true) {
      _homeKey.currentState?.refresh();
      _allSubsKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePageBody(key: _homeKey),
          AllSubscriptionsPage(key: _allSubsKey),
          const SettingsPage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          if (i == 0) {
            _homeKey.currentState?.refresh();
          } else if (i == 1) {
            _allSubsKey.currentState?.refresh();
          }
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.loc.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.list_outlined),
            selectedIcon: const Icon(Icons.list),
            label: context.loc.allSubscriptions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: context.loc.settings,
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'fab',
        flightShuttleBuilder: fabShuttleBuilder,
        child: FilledButton(
          onPressed: _onAddPressed,
          style: fabStyle,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
