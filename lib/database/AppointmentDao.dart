import 'package:sqflite/sqflite.dart';
import '../model/MyAppointment.dart';

class AppointmentDao {
  // Reference to the database
  final Database database;

  // Constructor
  AppointmentDao({required this.database});

  // Example method: Insert appointment
  Future<void> insertAppointment(MyAppointment appointment) async {
    await database.insert('appointments', appointment.toMap());
  }

// Other CRUD methods go here...
}