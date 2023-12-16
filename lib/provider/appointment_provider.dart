import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../database/DatabaseHelper.dart';
import '../model/event.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  final Map<String, IconData> _icons = {};
  final db = DatabaseHelper.instance.database;

  List<Appointment> get events => _appointments;
  Map<String, IconData> get icons => _icons;

  void addEvent(Appointment event, IconData iconData) {
    _appointments.add(event);
    _icons[event.subject] = iconData;



    notifyListeners();
  }

  void deleteEvent(Appointment event) {
    if (event.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == event.id);
    } else {
      // Handle non-recurring appointment deletion
      _appointments.remove(event);
    }

    notifyListeners();
  }

  void editEvent(Appointment newEvent, Appointment oldEvent) {
    if (oldEvent.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == oldEvent.id);

      _appointments.add(newEvent);

    } else {
    final index = _appointments.indexOf(oldEvent);
    _appointments[index] = newEvent;


    }
    notifyListeners();
  }


}