import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'MyAppointment.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<Appointment> appointments) {
    this.appointments = appointments;
  }

  Appointment getEvent(int index) => appointments![index] as Appointment;

  @override
  Object? getId(int index) => getId(index);

  @override
  DateTime getStartTime(int index) => getEvent(index).startTime;


  @override
  DateTime getEndTime(int index) => getEvent(index).endTime;


  @override
  String getSubject(int index) => getEvent(index).subject;


  @override
  Color getColor(int index) => getEvent(index).color;

  @override
  String? getRecurrenceRule(int index) => getEvent(index).recurrenceRule;

  @override
  List<DateTime>? getRecurrenceExceptionDates(int index) {
    return super.getRecurrenceExceptionDates(index);
  }


}
