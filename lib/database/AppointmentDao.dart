import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import '../model/MyAppointment.dart';

class AppointmentDao {


  // Example method: Insert appointment
  Future<void> insertAppointment(MyAppointment appointment) async {
    final database = await DatabaseHelper.database();
    await database.insert('appointments', appointment.toMap());
  }

  Future<List<MyAppointment>> getAllAppointments() async {
    final database = await DatabaseHelper.database();
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('appointments');
    return List.generate(maps.length, (i) {
      return MyAppointment(
        id: maps[i]['id'],
        startTime: DateTime.parse(maps[i]['startTime']),
        endTime: DateTime.parse(maps[i]['endTime']),
        subject: maps[i]['subject'],
        color: Color(maps[i]['color']),
        recurrenceRule: maps[i]['recurrenceRule'],
        notes: '',
      );
    });
  }
}