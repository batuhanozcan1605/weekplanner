import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static Future<Database> database() async {
    final dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'appointments.db'),
      onCreate: (db, version){
        db.execute("""CREATE TABLE appointments (
            id INTEGER PRIMARY KEY,
            startTime TEXT,
            endTime TEXT,
            subject TEXT,
            notes TEXT,
            color INTEGER,
            icon INTEGER,
            recurrenceRule TEXT,
            isCompleted INTEGER DEFAULT 0
        )"""
            );
      },
      version: 1,
    );

  }


}