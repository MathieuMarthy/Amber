import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:amber_calendar/src/providers/settings_provider.dart';
import 'package:amber_calendar/src/utils/localization.dart';
import 'package:amber_calendar/src/local/app_database.dart';
import 'package:amber_calendar/src/services/database_backup_service.dart';
import 'package:amber_calendar/src/utils/toast.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Future<void> _exportDatabase() async {
    try {
      final bytes = await DatabaseBackupService.getDatabaseBytes();
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Export Database Backup',
        fileName: 'amber_calendar_backup.db',
        bytes: bytes,
      );
      
      if (path != null && mounted) {
        showAndroidToast(context, 'Exported to: $path');
      }
    } catch (e, stack) {
      debugPrint('Export Error: $e');
      debugPrint('Stacktrace: $stack');
      if (mounted) showAndroidToast(context, '${context.loc.exportError} : $e');
    }
  }

  Future<void> _importDatabase() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.loc.importDatabase),
        content: Text(context.loc.importWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text(context.loc.importDatabase),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['db', 'sqlite', 'sqlite3'],
    );
    if (result != null && result.files.single.path != null) {
      try {
        if (!mounted) return;
        final db = context.read<AppDatabase>();
        await DatabaseBackupService.importDatabase(result.files.single.path!, db);
        
        if (mounted) {
          Phoenix.rebirth(context);
        }
      } catch (e) {
        if (mounted) showAndroidToast(context, context.loc.importError);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 32, 32, 16),
            child: Text(
              context.loc.settings,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: Text(context.loc.theme),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox(),
                    items: [
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text(context.loc.themeLight),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text(context.loc.themeDark),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text(context.loc.themeSystem),
                      ),
                    ],
                    onChanged: (mode) {
                      if (mode != null) {
                        context.read<SettingsProvider>().updateThemeMode(mode);
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.attach_money_outlined),
                  title: Text(context.loc.currency),
                  trailing: DropdownButton<String>(
                    value: settings.currencySymbol,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: '€', child: Text('€')),
                      DropdownMenuItem(value: '\$', child: Text('\$')),
                      DropdownMenuItem(value: '£', child: Text('£')),
                      DropdownMenuItem(value: '¥', child: Text('¥')),
                      DropdownMenuItem(value: 'CHF', child: Text('CHF')),
                      DropdownMenuItem(value: 'CAD\$', child: Text('CAD\$')),
                      DropdownMenuItem(value: 'AUD\$', child: Text('AUD\$')),
                    ],
                    onChanged: (symbol) {
                      if (symbol != null) {
                        context.read<SettingsProvider>().updateCurrencySymbol(symbol);
                      }
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    context.loc.dataManagement,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: Text(context.loc.exportDatabase),
                  onTap: _exportDatabase,
                ),
                ListTile(
                  leading: const Icon(Icons.file_download),
                  title: Text(context.loc.importDatabase),
                  onTap: _importDatabase,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
