import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../database/AppointmentDao.dart';
import '../database/DatabaseHelper.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<MyAppointment> _appointments = [];
  Map<int, IconData> _icons = {};

  List<MyAppointment> get events => _appointments;
  Map<int, IconData> get icons => _icons;

  int getHighestId() {
    var highestId = _appointments.isNotEmpty
        ? _appointments.map((obj) => obj.id ?? 0).reduce((max, id) => id > max ? id : max)
        : 0;
    return highestId;
  }
  void initializeWithAppointments(List<MyAppointment> fetchedAppointments) {
    print("DEBUG inside provider");
    _appointments = fetchedAppointments;
    notifyListeners();
  }

  void initializeIcons(Map<int, IconData> fetchedIcons) {
    print("DEBUG inside provider icons");
    _icons = fetchedIcons;
    notifyListeners();
  }


  void addEvent(MyAppointment appointment, IconData icon) {
    _appointments.add(appointment);
    _icons[appointment.id!]= icon;
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