import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/repositories/category_repository.dart';
import 'package:amber_calendar/src/repositories/subscription_repository.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/widgets/category_management_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:amber_calendar/src/providers/settings_provider.dart';
import 'package:amber_calendar/src/utils/currency_utils.dart';

enum EndConditionType { never, date, count }

class AddSubscription extends StatefulWidget {
  final SubscriptionEntry? subscriptionToEdit;

  const AddSubscription({super.key, this.subscriptionToEdit});

  @override
  State<AddSubscription> createState() => AddSubscriptionState();
}

class AddSubscriptionState extends State<AddSubscription> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _websiteUrlController = TextEditingController();
  final _repeatXTimesController = TextEditingController();

  DateTime _startDay = DateTime.now();
  int _frequency = 1;
  UnitOfTime _unitOfTime = UnitOfTime.month;
  EndConditionType _endCondition = EndConditionType.never;
  DateTime? _repeatUntil;
  Category? _selectedCategory;
  List<Category> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    if (widget.subscriptionToEdit != null) {
      final sub = widget.subscriptionToEdit!;
      _nameController.text = sub.name;
      _priceController.text = (sub.price / 100).toStringAsFixed(2);
      _notesController.text = sub.notes;
      _websiteUrlController.text = sub.websiteUrl ?? '';
      _startDay = sub.startDay;
      _frequency = sub.frequency;
      _unitOfTime = sub.unitOfTime;
      if (sub.repeatUntil != null) {
        _endCondition = EndConditionType.date;
        _repeatUntil = sub.repeatUntil;
      } else if (sub.repeatXTimes != null) {
        _endCondition = EndConditionType.count;
        _repeatXTimesController.text = sub.repeatXTimes.toString();
      }
      // Category will be selected after categories are loaded
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final repo = context.read<CategoryRepository>();
      final cats = await repo.getAll();
      if (mounted) {
        setState(() {
          _categories = cats;
          _isLoadingCategories = false;

          if (widget.subscriptionToEdit?.categoryId != null) {
            final catId = widget.subscriptionToEdit!.categoryId;
            try {
              _selectedCategory = cats.firstWhere((c) => c.id == catId);
            } catch (e) {
              _selectedCategory = null;
            }
          } else if (_selectedCategory != null &&
              !cats.any((c) => c.id == _selectedCategory!.id)) {
            _selectedCategory = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _websiteUrlController.dispose();
    _repeatXTimesController.dispose();
    super.dispose();
  }

  Future<bool> submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final double priceDouble =
          double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0.0;
      final int priceCents = (priceDouble * 100).round();

      try {
        final repo = context.read<SubscriptionRepository>();
        final webUrl = _websiteUrlController.text.trim();

        DateTime? repeatUntil;
        int? repeatXTimes;
        if (_endCondition == EndConditionType.date) {
          repeatUntil = _repeatUntil;
        } else if (_endCondition == EndConditionType.count) {
          repeatXTimes = int.tryParse(_repeatXTimesController.text);
        }

        if (widget.subscriptionToEdit != null) {
          await repo.update(
            widget.subscriptionToEdit!,
            name: _nameController.text.trim(),
            price: priceCents,
            notes: _notesController.text.trim(),
            websiteUrl: webUrl.isNotEmpty ? webUrl : null,
            clearWebsiteUrl: webUrl.isEmpty,
            categoryId: _selectedCategory?.id,
            clearCategory: _selectedCategory == null,
            startDay: _startDay,
            frequency: _frequency,
            unitOfTime: _unitOfTime.index,
            repeatUntil: repeatUntil,
            clearRepeatUntil: repeatUntil == null,
            repeatXTimes: repeatXTimes,
            clearRepeatXTimes: repeatXTimes == null,
          );
        } else {
          await repo.create(
            name: _nameController.text.trim(),
            price: priceCents,
            notes: _notesController.text.trim(),
            websiteUrl: webUrl.isNotEmpty ? webUrl : null,
            categoryId: _selectedCategory?.id,
            startDay: _startDay,
            frequency: _frequency,
            unitOfTime: _unitOfTime.index,
            repeatUntil: repeatUntil,
            repeatXTimes: repeatXTimes,
          );
        }
        return true;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.loc.errorCreating(e.toString())),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
    return false;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.loc.validationPriceRequired;
    }
    final normalized = value.replaceAll(',', '.');
    final val = double.tryParse(normalized);
    if (val == null) {
      return context.loc.validationPriceInvalid;
    }
    if (val < 0) {
      return context.loc.validationPriceNegative;
    }
    final parts = normalized.split('.');
    if (parts.length > 1 && parts[1].length > 2) {
      return context.loc.validationPriceDecimals;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final dateFormat = DateFormat('dd/MM/yyyy');
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.subscriptionToEdit != null
                ? context.loc.editSubscription
                : context.loc.addSubscription,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: context.loc.subscriptionName,
              hintText: context.loc.subscriptionNameHint,
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.subscriptions),
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return context.loc.validationNameRequired;
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceController,
            decoration: InputDecoration(
              labelText: context.loc.price,
              hintText: context.loc.priceHint,
              prefixText: CurrencyUtils.isSymbolOnLeft(currencySymbol) ? '$currencySymbol ' : null,
              suffixText: CurrencyUtils.isSymbolOnLeft(currencySymbol) ? null : ' $currencySymbol',
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.euro),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              TextInputFormatter.withFunction((oldValue, newValue) {
                final regExp = RegExp(r'^\d*[\.,]?\d{0,2}$');
                if (regExp.hasMatch(newValue.text)) {
                  return newValue;
                }
                return oldValue;
              }),
            ],
            validator: _validatePrice,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _startDay,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() {
                  _startDay = picked;
                });
              }
            },
            borderRadius: BorderRadius.circular(4),
            child: InputDecorator(
              decoration: InputDecoration(
                labelText: context.loc.firstPaymentDate,
                border: const OutlineInputBorder(),
                icon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                dateFormat.format(_startDay),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: Icon(Icons.repeat),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: context.loc.repeatEvery,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _frequency.toString(),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return context.loc.required;
                          }
                          final val = int.tryParse(value);
                          if (val == null || val <= 0) {
                            return context.loc.invalid;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          final val = int.tryParse(value);
                          if (val != null && val > 0) {
                            _frequency = val;
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<UnitOfTime>(
                        initialValue: _unitOfTime,
                        decoration: InputDecoration(
                          labelText: context.loc.period,
                          border: const OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: UnitOfTime.day,
                            child: Text(context.loc.days),
                          ),
                          DropdownMenuItem(
                            value: UnitOfTime.week,
                            child: Text(context.loc.weeks),
                          ),
                          DropdownMenuItem(
                            value: UnitOfTime.month,
                            child: Text(context.loc.months),
                          ),
                          DropdownMenuItem(
                            value: UnitOfTime.year,
                            child: Text(context.loc.years),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _unitOfTime = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<EndConditionType>(
            initialValue: _endCondition,
            decoration: InputDecoration(
              labelText: context.loc.endCondition,
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.event_busy),
            ),
            items: [
              DropdownMenuItem(
                value: EndConditionType.never,
                child: Text(context.loc.never),
              ),
              DropdownMenuItem(
                value: EndConditionType.date,
                child: Text(context.loc.onSpecificDate),
              ),
              DropdownMenuItem(
                value: EndConditionType.count,
                child: Text(context.loc.afterXPayments),
              ),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() => _endCondition = val);
              }
            },
          ),
          if (_endCondition == EndConditionType.date) ...[
            const SizedBox(height: 16),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _repeatUntil ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _repeatUntil = picked;
                  });
                }
              },
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: context.loc.endDate,
                  border: const OutlineInputBorder(),
                  icon: const Icon(Icons.event),
                ),
                child: Text(
                  _repeatUntil != null
                      ? dateFormat.format(_repeatUntil!)
                      : context.loc.selectDate,
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
          ] else if (_endCondition == EndConditionType.count) ...[
            const SizedBox(height: 16),
            TextFormField(
              controller: _repeatXTimesController,
              decoration: InputDecoration(
                labelText: context.loc.numberOfPayments,
                border: const OutlineInputBorder(),
                icon: const Icon(Icons.numbers),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return context.loc.required;
                }
                final val = int.tryParse(value);
                if (val == null || val <= 0) {
                  return context.loc.invalid;
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 16),
          _isLoadingCategories
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Category?>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          labelText: context.loc.category,
                          border: const OutlineInputBorder(),
                          icon: const Icon(Icons.category),
                        ),
                        items: [
                          DropdownMenuItem<Category?>(
                            value: null,
                            child: Text(context.loc.none),
                          ),
                          ..._categories.map(
                            (cat) => DropdownMenuItem<Category?>(
                              value: cat,
                              child: Text(cat.name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      icon: const Icon(Icons.settings),
                      tooltip: context.loc.manageCategories,
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => CategoryManagementDialog(
                            onChanged: _loadCategories,
                          ),
                        );
                      },
                    ),
                  ],
                ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: InputDecoration(
              labelText: context.loc.notes,
              hintText: context.loc.notesHint,
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.note),
            ),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _websiteUrlController,
            decoration: InputDecoration(
              labelText: context.loc.websiteUrl,
              hintText: context.loc.websiteUrlHint,
              border: const OutlineInputBorder(),
              icon: const Icon(Icons.link),
              suffixIcon: Tooltip(
                message: context.loc.websiteUrlTooltip,
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 4),
                child: const Icon(Icons.info_outline),
              ),
            ),
            keyboardType: TextInputType.url,
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
