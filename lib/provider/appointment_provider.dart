import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../database/AppointmentDao.dart';
import '../database/DatabaseHelper.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<MyAppointment> _appointments = [];
  final Map<String, IconData> _icons = {};


  List<MyAppointment> get events => _appointments;
  Map<String, IconData> get icons => _icons;

  void initializeWithAppointments(List<MyAppointment> fetchedAppointments) {
    print("DEBUG inside provider");
    _appointments = fetchedAppointments;
    notifyListeners();
  }

  void addEvent(MyAppointment appointment, IconData iconData) {
    _appointments.add(appointment);
    _icons[appointment.subject] = iconData;
    AppointmentDao().insertAppointment(appointment);


    notifyListeners();
  }

  void deleteEvent(MyAppointment appointment) {
    if (appointment.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == appointment.id);
    } else {
      // Handle non-recurring appointment deletion
      _appointments.remove(appointment);
    }

    notifyListeners();
  }

  void editEvent(MyAppointment newEvent, MyAppointment oldEvent) {
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