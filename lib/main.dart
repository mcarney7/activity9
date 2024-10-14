import 'package:flutter/material.dart';
import 'database_helper.dart';

// Initialize the database helper
final dbHelper = DatabaseHelper();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // Main UI layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _insert,
              child: const Text('Insert'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _query,
              child: const Text('Query All'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _update,
              child: const Text('Update'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _delete,
              child: const Text('Delete'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _queryById(1), // Change ID as needed
              child: const Text('Query by ID'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteAll,
              child: const Text('Delete All'),
            ),
          ],
        ),
      ),
    );
  }

  // Insert function
  void _insert() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnName: 'Bob',
      DatabaseHelper.columnAge: 23
    };
    final id = await dbHelper.insert(row);
    debugPrint('Inserted row id: $id');
  }

  // Query all rows function
  void _query() async {
    final allRows = await dbHelper.queryAllRows();
    debugPrint('Query all rows:');
    for (final row in allRows) {
      debugPrint(row.toString());
    }
  }

  // Update function
  void _update() async {
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: 1, // Change ID as needed
      DatabaseHelper.columnName: 'Mary',
      DatabaseHelper.columnAge: 32
    };
    final rowsAffected = await dbHelper.update(row);
    debugPrint('Updated $rowsAffected row(s)');
  }

  // Delete function
  void _delete() async {
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    debugPrint('Deleted $rowsDeleted row(s): row $id');
  }

  // Query by ID function
  void _queryById(int id) async {
    final row = await dbHelper.queryById(id);
    if (row != null) {
      debugPrint('Row with ID $id: $row');
    } else {
      debugPrint('No record found with ID $id');
    }
  }

  // Delete all function
  void _deleteAll() async {
    final rowsDeleted = await dbHelper.deleteAll();
    debugPrint('Deleted all $rowsDeleted row(s)');
  }
}
