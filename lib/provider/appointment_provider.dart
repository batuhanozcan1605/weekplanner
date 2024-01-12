import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/database/UniqueIdDao.dart';
import '../database/AppointmentDao.dart';
import '../database/DatabaseHelper.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';
import '../model/UniqueId.dart';

class AppointmentProvider extends ChangeNotifier {
  List<MyAppointment> _appointments = [];
  Map<int, IconData> _icons = {};
  Map<int, int> _isCompleted = {};
  List<String> _uniqueIds = [];

  List<MyAppointment> get events => _appointments;
  Map<int, IconData> get icons => _icons;
  Map<int, int> get isCompleted => _isCompleted;
  List<String> get uniqueIds => _uniqueIds;

  //main screen providers
  bool _scheduleView = false;
  bool _weekView = true;
  bool _dayView = false;
  int rebuildCalender = 0;

  bool get scheduleView => _scheduleView;
  bool get weekView => _weekView;
  bool get dayView => _dayView;

  void showWeekView() {
    _scheduleView = false;
    _weekView = true;
    _dayView = false;
    notifyListeners();
  }
  void showDayView() {
    _scheduleView = false;
    _weekView = false;
    _dayView = true;
    print("show day view");
    notifyListeners();
  }

  void showScheduleView() {
    _scheduleView = true;
    _weekView = false;
    _dayView = false;
    notifyListeners();
  }
  //main screen providers


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

  void initializeIsCompleted(Map<int, int> fetchedIsCompleted) {
    _isCompleted = fetchedIsCompleted;
    notifyListeners();
  }

  void initializeUniqueIds(List<String> fetchedUniqueIds) {
    _uniqueIds = fetchedUniqueIds;
    notifyListeners();
  }

  void addEvent(MyAppointment appointment, IconData icon) {
    _appointments.add(appointment);
    _icons[appointment.id!]= icon;
    AppointmentDao().insertAppointment(appointment);


    notifyListeners();
  }

  void addUniqueId(String uniqueId) {
    UniqueIdDao().insertData(uniqueId);
    _uniqueIds.add(uniqueId);

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

  void deleteUniqueIds(String uniqueId) {
    UniqueIdDao().deleteAppointment(uniqueId);
    _uniqueIds.remove(uniqueId);

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
      _isCompleted[event.id!] = event.isCompleted;

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
    for(int i= _appointments.length; i > _appointments.length-4 && i > 0; i--) {
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

  List<Events> getOther4LatestEvents() {
    Set<Events> latestEventSet = {};
    List<Events> latestEvents = [];
    for(int i= _appointments.length-4; i > _appointments.length-8 && i > 0; i--) {
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