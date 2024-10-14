import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Database configuration constants
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  // Table and column names
  static const table = 'my_table';
  static const columnId = '_id';
  static const columnName = 'name';
  static const columnAge = 'age';

  late Database _db;

  // Initialize the database, conditional for non-web platforms
  Future<void> init() async {
    if (!kIsWeb) {
      // Get the documents directory for storing the database file
      final documentsDirectory = await getApplicationDocumentsDirectory();
      final path = join(documentsDirectory.path, _databaseName);

      // Open the database, creating it if it doesn't exist
      _db = await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
      );
    } else {
      // Throw an error if this code is run on the web platform
      throw UnsupportedError("Local database storage is not supported on the web platform.");
    }
  }

  // SQL code to create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnAge INTEGER NOT NULL
          )
          ''');
  }

  // Insert a row into the database
  Future<int> insert(Map<String, dynamic> row) async {
    if (!kIsWeb) {
      return await _db.insert(table, row);
    }
    throw UnsupportedError("Insert operation is not supported on the web.");
  }

  // Query all rows from the database
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    if (!kIsWeb) {
      return await _db.query(table);
    }
    throw UnsupportedError("Query operation is not supported on the web.");
  }

  // Get the row count in the database
  Future<int> queryRowCount() async {
    if (!kIsWeb) {
      final results = await _db.rawQuery('SELECT COUNT(*) FROM $table');
      return Sqflite.firstIntValue(results) ?? 0;
    }
    throw UnsupportedError("Row count query is not supported on the web.");
  }

  // Update a specific row in the database
  Future<int> update(Map<String, dynamic> row) async {
    if (!kIsWeb) {
      int id = row[columnId];
      return await _db.update(
        table,
        row,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    }
    throw UnsupportedError("Update operation is not supported on the web.");
  }

  // Delete a specific row from the database
  Future<int> delete(int id) async {
    if (!kIsWeb) {
      return await _db.delete(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
    }
    throw UnsupportedError("Delete operation is not supported on the web.");
  }

  // Query a single row by ID
  Future<Map<String, dynamic>?> queryById(int id) async {
    if (!kIsWeb) {
      final result = await _db.query(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      return result.isNotEmpty ? result.first : null;
    }
    throw UnsupportedError("Query by ID operation is not supported on the web.");
  }

  // Delete all records from the database
  Future<int> deleteAll() async {
    if (!kIsWeb) {
      return await _db.delete(table);
    }
    throw UnsupportedError("Delete all operation is not supported on the web.");
  }
}
