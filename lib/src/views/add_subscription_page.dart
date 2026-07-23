import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/utils/toast.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/widgets/add_subscription.dart';
import 'package:amber_calendar/src/widgets/fab_styles.dart';
import 'package:flutter/material.dart';

class AddSubscriptionPage extends StatefulWidget {
  final SubscriptionEntry? subscriptionToEdit;

  const AddSubscriptionPage({super.key, this.subscriptionToEdit});

  @override
  State<AddSubscriptionPage> createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _addSubscriptionKey = GlobalKey<AddSubscriptionState>();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: context.loc.cancel,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 8.0),
          child: AddSubscription(
            key: _addSubscriptionKey,
            subscriptionToEdit: widget.subscriptionToEdit,
          ),
        ),
      ),
      floatingActionButton: Hero(
        tag: 'fab',
        flightShuttleBuilder: fabShuttleBuilder,
        child: FilledButton(
          onPressed: _isSubmitting
              ? null
              : () async {
                  setState(() {
                    _isSubmitting = true;
                  });
                  final success = await _addSubscriptionKey.currentState
                      ?.submit();
                  if (success == true && context.mounted) {
                    final msg = widget.subscriptionToEdit != null
                        ? context.loc.successUpdateToast
                        : context.loc.successToast;
                    showAndroidToast(context, msg);
                    Navigator.of(context).pop(true);
                  } else if (context.mounted) {
                    setState(() {
                      _isSubmitting = false;
                    });
                  }
                },
          style: fabStyle,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
