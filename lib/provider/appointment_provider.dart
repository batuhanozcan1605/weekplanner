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

    _appointments = fetchedAppointments;
    notifyListeners();
  }

  void initializeIcons(Map<int, IconData> fetchedIcons) {

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
    AppointmentDao().deleteAppointment(appointment.id!);
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
    AppointmentDao().updateAppointment(newEvent);
    if (oldEvent.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == oldEvent.id);

      _appointments.add(newEvent);

    } else {
      AppointmentDao().updateAppointment(newEvent);
    final index = _appointments.indexOf(oldEvent);
    _appointments[index] = newEvent;

    }
    notifyListeners();
  }

  void editCompletedEvent(MyAppointment event) {

      AppointmentDao().updateIsCompleted(event);
      final index = _appointments.indexOf(event);
      _appointments[index] = event;

    notifyListeners();
  }

  void addSelectedDaysEvents(List<MyAppointment> appointments, icon){
    for(int i=0; i < appointments.length; i++) {
      //print('DEBUG provider içi appointment: ${appointments[i]}');
      AppointmentDao().insertAppointment(appointments[i]);
    _appointments.add(appointments[i]);
    _icons[appointments[i].id!]= icon;
    }
    notifyListeners();
  }

  List<Events> get4LatestEvents() {
    Set<Events> latestEventSet = {};
    List<Events> latestEvents = [];
    for(int i=_appointments.length; i > _appointments.length-8 && i > 0; i--) {
      print('provider içi latest $i');
      final appointment = _appointments[i-1];
      print('provider içi latest $appointment');
      final event = Events(subject: appointment.subject, icon: appointment.icon, color: appointment.color);
      latestEventSet.add(event);
      print(latestEventSet);
    }
    latestEvents = latestEventSet.toList();
    return latestEvents;
  }

}