import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper2 {

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'uniqueId.db'),
      onCreate: (db, version){
        db.execute("""CREATE TABLE another_table (
            id INTEGER PRIMARY KEY,
            uniqueId TEXT
        )"""
        );
      },
      version: 1, // Change the version if needed
    );
  }
}