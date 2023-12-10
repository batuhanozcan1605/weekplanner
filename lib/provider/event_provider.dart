import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/event.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get events => _appointments;

  void addEvent(Appointment event) {
    _appointments.add(event);

    notifyListeners();
  }

  void deleteEvent(Appointment event) {
    if (event.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _appointments.removeWhere((existingEvent) =>
      existingEvent.recurrenceId == event.recurrenceId &&
          existingEvent.recurrenceRule != null);
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
      existingEvent.recurrenceId == oldEvent.recurrenceId &&
          existingEvent.recurrenceRule != null);

      _appointments.add(newEvent);
    } else {
    final index = _appointments.indexOf(oldEvent);
    _appointments[index] = newEvent;


    }
    notifyListeners();
  }


}