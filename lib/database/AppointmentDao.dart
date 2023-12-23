import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import '../model/MyAppointment.dart';

class AppointmentDao {


  // Example method: Insert appointment
    Future<void> insertAppointment(MyAppointment appointment) async {
      final database = await DatabaseHelper.database();
      await database.insert('appointments', appointment.toMap());
    }



    Future<void> deleteAppointment(int id) async {
      final database = await DatabaseHelper.database();
      await database.delete(
        'appointments',
        where: 'id = ?',
        whereArgs: [id],
      );
    }

    Future<void> updateAppointment(MyAppointment appointment) async {
      final database = await DatabaseHelper.database();
      await database.update(
        'appointments',
        appointment.toMap(),
        where: 'id = ?',
        whereArgs: [appointment.id],
      );
    }

  Future<List<MyAppointment>> getAllAppointments() async {
    final database = await DatabaseHelper.database();
    final List<Map<String, dynamic>> maps = await database.query('appointments');
    return List.generate(maps.length, (i) {
      return MyAppointment(
        id: maps[i]['id'],
        startTime: DateTime.parse(maps[i]['startTime']),
        endTime: DateTime.parse(maps[i]['endTime']),
        subject: maps[i]['subject'],
        notes: maps[i]['notes'],
        color: Color(maps[i]['color']),
        icon: IconData(maps[i]['icon'], fontFamily: 'MaterialIcons'),
        recurrenceRule: maps[i]['recurrenceRule'],
      );
    });
  }

}