import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/category_repository.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/utils/toast.dart';
import 'package:amber_calendar/src/utils/date_utils.dart';
import 'package:amber_calendar/src/views/add_subscription_page.dart';
import 'package:amber_calendar/src/widgets/subscription/subscription_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:amber_calendar/src/providers/settings_provider.dart';
import 'package:amber_calendar/src/utils/currency_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscriptionDetailsPage extends StatefulWidget {
  final SubscriptionEntry subscription;
  final String heroTagPrefix;

  const SubscriptionDetailsPage({
    super.key,
    required this.subscription,
    this.heroTagPrefix = '',
  });

  @override
  State<SubscriptionDetailsPage> createState() =>
      _SubscriptionDetailsPageState();
}

class _SubscriptionDetailsPageState extends State<SubscriptionDetailsPage> {
  late SubscriptionEntry _subscription;
  Category? _category;
  bool _wasModified = false;

  @override
  void initState() {
    super.initState();
    _subscription = widget.subscription;
    _loadCategory();
  }

  Future<void> _loadCategory() async {
    if (_subscription.categoryId != null) {
      final repo = context.read<CategoryRepository>();
      final cat = await repo.getById(_subscription.categoryId!);
      if (mounted) {
        setState(() {
          _category = cat;
        });
      }
    }
  }

  Future<void> _refreshSubscription() async {
    final repo = context.read<SubscriptionRepository>();
    final updated = await repo.getById(_subscription.id);
    if (updated != null && mounted) {
      setState(() {
        _subscription = updated;
        _wasModified = true;
      });
      _loadCategory();
    }
  }

  String _getRecurrenceText(BuildContext context) {
    final freq = _subscription.frequency;
    final unit = _subscription.unitOfTime;
    final day = _subscription.startDay.day;

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
    final formattedPrice = CurrencyUtils.format(context, _subscription.price, currencySymbol);

    final df = DateFormat.yMMMd(Localizations.localeOf(context).toString());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pop(_wasModified);
      },
      child: Scaffold(
        backgroundColor: colors.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(_wasModified),
          ),
          title: Text(context.loc.subscriptionDetails),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: context.loc.edit,
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        AddSubscriptionPage(subscriptionToEdit: _subscription),
                  ),
                );
                if (result == true) {
                  await _refreshSubscription();
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 32.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isActive(_subscription)) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: colors.errorContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: colors.onErrorContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _subscription.cancelledAt != null
                              ? context.loc.inactiveSince(
                                  df.format(_subscription.cancelledAt!),
                                )
                              : context.loc.inactive,
                          style: TextStyle(
                            color: colors.onErrorContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Center(
                  child: Hero(
                    tag: '${widget.heroTagPrefix}avatar_${_subscription.id}',
                    child: SubscriptionAvatar(
                      name: _subscription.name,
                      websiteUrl: _subscription.websiteUrl,
                      size: 100,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  _subscription.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  formattedPrice,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),

                _DetailRow(
                  icon: Icons.calendar_month,
                  title: context.loc.firstPaymentDate,
                  value: df.format(_subscription.startDay),
                ),
                const SizedBox(height: 24),
                _DetailRow(
                  icon: Icons.repeat,
                  title: context.loc.period,
                  value: _getRecurrenceText(context),
                ),
                const SizedBox(height: 24),
                _DetailRow(
                  icon: Icons.event_busy,
                  title: context.loc.endCondition,
                  value: _subscription.repeatUntil != null
                      ? df.format(_subscription.repeatUntil!)
                      : _subscription.repeatXTimes != null
                      ? context.loc.endAfterPayments(
                          _subscription.repeatXTimes!,
                        )
                      : context.loc.never,
                ),
                const SizedBox(height: 24),
                if (_category != null) ...[
                  _DetailRow(
                    icon: Icons.category,
                    title: context.loc.category,
                    value: _category!.name,
                  ),
                  const SizedBox(height: 24),
                ],
                if (_subscription.websiteUrl != null &&
                    _subscription.websiteUrl!.isNotEmpty) ...[
                  _DetailRow(
                    icon: Icons.link,
                    title: "URL",
                    value: _subscription.websiteUrl!,
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () async {
                        var urlString = _subscription.websiteUrl!;
                        if (!urlString.startsWith('http://') &&
                            !urlString.startsWith('https://')) {
                          urlString = 'https://$urlString';
                        }
                        final url = Uri.parse(urlString);
                        try {
                          final success = await launchUrl(
                            url,
                            mode: LaunchMode.externalApplication,
                          );
                          if (!success && context.mounted) {
                            showAndroidToast(
                              context,
                              "Impossible d'ouvrir l'URL",
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            showAndroidToast(
                              context,
                              "Impossible d'ouvrir l'URL",
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (_subscription.notes.isNotEmpty) ...[
                  _DetailRow(
                    icon: Icons.notes,
                    title: context.loc.notes,
                    value: _subscription.notes,
                  ),
                  const SizedBox(height: 24),
                ],

                const SizedBox(height: 48),
                ..._buildActionButtons(context, colors),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showConfirmDialog(
    String title,
    String content,
    String confirmText,
  ) {
    final colors = Theme.of(context).colorScheme;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: colors.error),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, ColorScheme colors) {
    return [
      if (isActive(_subscription))
        OutlinedButton.icon(
          onPressed: () async {
            final confirm = await _showConfirmDialog(
              context.loc.stopSubscription,
              context.loc.stopConfirmation,
              context.loc.stop,
            );

            if (confirm == true && context.mounted) {
              final repo = context.read<SubscriptionRepository>();
              await repo.cancel(_subscription.id);
              if (context.mounted) {
                showAndroidToast(context, context.loc.successStopToast);
                _refreshSubscription();
              }
            }
          },
          icon: const Icon(Icons.stop_circle_outlined),
          label: Text(context.loc.stopSubscription),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.error,
            side: BorderSide(color: colors.error),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        )
      else
        FilledButton.icon(
          onPressed: () async {
            final repo = context.read<SubscriptionRepository>();
            await repo.reactivate(_subscription.id);
            if (context.mounted) {
              showAndroidToast(context, context.loc.successReactivateToast);
              _refreshSubscription();
            }
          },
          icon: const Icon(Icons.play_circle_outline),
          label: Text(context.loc.reactivateSubscription),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: () async {
          final confirm = await _showConfirmDialog(
            context.loc.deleteSubscription,
            context.loc.deleteConfirmation,
            context.loc.delete,
          );

          if (confirm == true && context.mounted) {
            final repo = context.read<SubscriptionRepository>();
            await repo.delete(_subscription.id);
            if (context.mounted) {
              showAndroidToast(context, context.loc.successDeleteToast);
              // Return true to indicate a change was made (deleted)
              Navigator.of(context).pop(true);
            }
          }
        },
        icon: Icon(Icons.delete, color: colors.error),
        label: Text(
          context.loc.deleteSubscription,
          style: TextStyle(color: colors.error),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.error),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    ];
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Widget? trailing;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colors.outline, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: colors.outline, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );
  }
}
