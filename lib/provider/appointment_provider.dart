import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/database/UniqueIdDao.dart';
import 'package:weekplanner/utils.dart';
import '../database/AppointmentDao.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';

class AppointmentProvider extends ChangeNotifier {
  List<MyAppointment> _myAppointments = [];
  List<Appointment> _appointments = [];
  Map<int, IconData> _icons = {};
  Map<int, int> _isCompleted = {};
  List<String> _uniqueIds = [];
  int _idOnDragStart = -1;

  List<MyAppointment> get events => _myAppointments;
  List<Appointment> get appointments => _appointments;
  Map<int, IconData> get icons => _icons;
  Map<int, int> get isCompleted => _isCompleted;
  List<String> get uniqueIds => _uniqueIds;
  int get idOnDragStart => _idOnDragStart;

  //main screen providers
  bool _scheduleView = false;
  bool _weekView = true;
  bool _dayView = false;

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
    var highestId = _myAppointments.isNotEmpty
        ? _myAppointments.map((obj) => obj.id ?? 0).reduce((max, id) => id > max ? id : max)
        : 0;
    return highestId;
  }
  void initializeWithMyAppointments(List<MyAppointment> fetchedMyAppointments) {

    _myAppointments = fetchedMyAppointments;
    notifyListeners();
  }

  void initializeWithAppointments(List<Appointment> fetchedAppointments) {

    _appointments = fetchedAppointments;
    print('debug $appointments');
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
    _myAppointments.add(appointment);
    _appointments.add(Utils.appointmentConverter(appointment));
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
      _myAppointments.removeWhere((existingEvent) =>
      existingEvent.id == appointment.id);
      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == Utils.appointmentConverter(appointment).id);
    } else {
      // Handle non-recurring appointment deletion
      _myAppointments.remove(appointment);
      _appointments.remove(Utils.appointmentConverter(appointment));
    }

    notifyListeners();
  }

  void deleteAll() {
    AppointmentDao().deleteAll();
    _myAppointments.clear();
    _appointments.clear();
    _uniqueIds.clear();
    _isCompleted.clear();
    _icons.clear();
    notifyListeners();
  }

  void deleteUniqueIds(String uniqueId) {
    UniqueIdDao().deleteAppointment(uniqueId);
    _uniqueIds.remove(uniqueId);

    notifyListeners();
  }

  void editEvent(MyAppointment newEvent, MyAppointment oldEvent) {
    AppointmentDao().updateAppointment(newEvent);
    _icons[oldEvent.id!]= newEvent.icon as IconData;
    if (oldEvent.recurrenceRule != null) {
      // Handle recurring appointment deletion
      _myAppointments.removeWhere((existingEvent) =>
      existingEvent.id == oldEvent.id);

      _myAppointments.add(newEvent);

      _appointments.removeWhere((existingEvent) =>
      existingEvent.id == Utils.appointmentConverter(oldEvent).id);

      _appointments.add(Utils.appointmentConverter(newEvent));

    } else {

      final index = _myAppointments.indexOf(oldEvent);
      _myAppointments[index] = newEvent;

      final index2 = _appointments.indexOf(Utils.appointmentConverter(oldEvent));
      print('index2 : $index2');
      _appointments[index2] = Utils.appointmentConverter(newEvent);

    }
    notifyListeners();
  }

  void editDraggedAppointment(Appointment appointment, AppointmentType appointmentType) {

    int id = appointment.id as int;
    print("appo id $id");
    if(appointmentType == AppointmentType.changedOccurrence) {
      print('id dragstart $_idOnDragStart');
      _icons[id] = _icons[_idOnDragStart]!;
      //_isCompleted[id] = _isCompleted[_idOnDragStart]!;
      notifyListeners();
    }

    final myAppointment = MyAppointment(
        id: id,
        startTime: appointment.startTime,
        endTime: appointment.endTime,
        subject: appointment.subject,
        notes: appointment.notes,
        color: appointment.color,
        recurrenceRule: appointment.recurrenceRule,
        icon: _icons[appointment.id],
        isCompleted: _isCompleted[appointment.id]
    );

    print('object update $myAppointment');
    print("appo type ne: $appointmentType");
    appointmentType == AppointmentType.changedOccurrence ?
    insertOccurrenceAppointment(myAppointment, appointment) :
    updateDraggedAppointment(myAppointment);
  }

  void insertOccurrenceAppointment(myAppointment, appointment) {
    //paterni yenile

    final result = _myAppointments.where((element) => element.id == appointment.recurrenceId);
    MyAppointment recurredAppointment;

// Check if any result is found
    if (result.isNotEmpty) {
      // Extract the first element from the iterable
      recurredAppointment = result.first;
      print('recurredAppointment ne: $recurredAppointment');
      List<DateTime>? setException() {

        if (recurredAppointment.recurrenceExceptionDates == null) {
          final exceptionDate = <DateTime>[];
          exceptionDate.add(DateTime(
              recurredAppointment.startTime.year,
              recurredAppointment.startTime.month,
              recurredAppointment.startTime.day));
          print('exceptionDates1: $exceptionDate');
          return exceptionDate;
        } else {
          List<DateTime>? exceptionDate =
          List.from(recurredAppointment.recurrenceExceptionDates!);
          print('exceptionDates2: $exceptionDate');
          exceptionDate.add(DateTime(
              recurredAppointment.startTime.year,
              recurredAppointment.startTime.month,
              recurredAppointment.startTime.day));
          return exceptionDate;
        }
      }

      final newRecurringAppointment = MyAppointment(
          id: recurredAppointment.id,
          startTime: recurredAppointment.startTime,
          endTime: recurredAppointment.endTime,
          subject: recurredAppointment.subject,
          notes: recurredAppointment.notes,
          color: recurredAppointment.color,
          recurrenceRule: recurredAppointment.recurrenceRule,
          recurrenceExceptionDates: setException(),
          icon: _icons[recurredAppointment.id],
          isCompleted: _isCompleted[recurredAppointment.id]
      );

      AppointmentDao().updateAppointment(newRecurringAppointment);

      _myAppointments.removeWhere((existingEvent) =>
      existingEvent.id == recurredAppointment.id);

      _myAppointments.add(newRecurringAppointment);

    } else {

      print('No recurred appointment found for id ${appointment.recurrenceId}');
    }

    //occured olanı ekle
    _myAppointments.removeWhere((existingEvent) =>
    existingEvent.id == appointment.id);
    _appointments.remove(appointment);
    AppointmentDao().deleteAppointment(appointment.id);
    _myAppointments.add(myAppointment);
    _appointments.add(Utils.appointmentConverter(myAppointment));
    AppointmentDao().insertAppointment(myAppointment);
    notifyListeners();

  }

  void updateDraggedAppointment(myAppointment) {

    _myAppointments.add(myAppointment);
    AppointmentDao().insertAppointment(myAppointment);
  }

  void setAppointmentOnDragStart(appointment) {
    if(appointment.recurrenceRule == null) {
    _myAppointments.removeWhere((existingEvent) =>
    existingEvent.id == appointment.id);
    _appointments.remove(appointment);
    AppointmentDao().deleteAppointment(appointment.id);
    } else {

    }

    _idOnDragStart = appointment.id;
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
      _myAppointments.add(appointments[i]);
      _appointments.add(Utils.appointmentConverter(appointments[i]));
    _icons[appointments[i].id!]= icon;
    }
    notifyListeners();
  }

  List<Events> get4LatestEvents() {
    Set<Events> latestEventSet = {};
    List<Events> latestEvents = [];
    for(int i= _myAppointments.length; i > _myAppointments.length-4 && i > 0; i--) {

      final appointment = _myAppointments[i-1];

      final event = Events(subject: appointment.subject, icon: appointment.icon, color: appointment.color);
      latestEventSet.add(event);

    }
    latestEvents = latestEventSet.toList();
    return latestEvents;
  }

  List<Events> getOther4LatestEvents() {
    Set<Events> latestEventSet = {};
    List<Events> latestEvents = [];
    for(int i= _myAppointments.length-4; i > _myAppointments.length-8 && i > 0; i--) {

      final appointment = _myAppointments[i-1];

      final event = Events(subject: appointment.subject, icon: appointment.icon, color: appointment.color);
      latestEventSet.add(event);

    }
    latestEvents = latestEventSet.toList();
    return latestEvents;
  }

  DateTime firstDateOfRecurringEventStart(id) {
    Appointment? appointment = _appointments.firstWhere(
          (appointment) => appointment.id == id,
    );

      return appointment.startTime;

  }

  DateTime firstDateOfRecurringEventEnd(id) {
    Appointment? appointment = _appointments.firstWhere(
          (appointment) => appointment.id == id,
    );

    return appointment.endTime;

  }

}