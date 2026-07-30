import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:amber_calendar/src/local/app_database.dart';
import 'dart:typed_data';

class DatabaseBackupService {
  static Future<File> _getDbFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'amber_calendar.db'));
  }

  /// Retrieves the raw bytes of the current database file for export.
  static Future<Uint8List> getDatabaseBytes() async {
    final file = await _getDbFile();
    if (!await file.exists()) {
      throw Exception('Database file does not exist');
    }
    return await file.readAsBytes();
  }

  /// Replaces the current database with the provided file and cleans up WAL/SHM.
  static Future<void> importDatabase(String importedFilePath, AppDatabase db) async {
    final importedFile = File(importedFilePath);
    if (!await importedFile.exists()) {
      throw Exception('Imported file does not exist');
    }

    // Close active database connection
    await db.close();

    // Overwrite the main database file
    final dbFile = await _getDbFile();
    await importedFile.copy(dbFile.path);

    // Delete temporary SQLite files to avoid corruption
    final dir = await getApplicationDocumentsDirectory();
    final wal = File(p.join(dir.path, 'amber_calendar.db-wal'));
    final shm = File(p.join(dir.path, 'amber_calendar.db-shm'));
    if (await wal.exists()) await wal.delete();
    if (await shm.exists()) await shm.delete();
  }
}
