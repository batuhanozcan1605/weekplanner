import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import 'package:weekplanner/database/DatabaseHelper2.dart';
import '../model/MyAppointment.dart';

class AppointmentDao {

  Future<void> updateIsCompleted(MyAppointment appointment) async {
    MyAppointment myAppointment = appointment;
    myAppointment.isCompleted = myAppointment.isCompleted == 1 ? 0 : 1;
    updateAppointment(myAppointment);
  }

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

  Future<void> deleteAll() async {
    final db = await DatabaseHelper.database();
    final db2 = await DatabaseHelper2.database();
    // Delete all rows from the table
    await db.delete('appointments');
    await db2.delete('uniqueId');
  }

    Future<void> updateAppointment(MyAppointment appointment) async {
      final database = await DatabaseHelper.database();
      print('gelen id ne ${appointment.id}');
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
        recurrenceExceptionDates: jsonDecode(maps[i]['recurrenceExceptionDates'])
            .map<DateTime>((date) => DateTime.parse(date))
            .toList(),
        isCompleted: maps[i]['isCompleted']
      );
    });
  }

  Future<void> deleteObsoleteData(List fetchedAppointments) async {

    fetchedAppointments.forEach((appointment) {
      if(appointment.recurrenceRule == null) {
        if (appointment.endTime.isBefore(DateTime.now().subtract(const Duration(days: 31)))) {
          deleteAppointment(appointment.id);
        }
      }
    });

  }

}