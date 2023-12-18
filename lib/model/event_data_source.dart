import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'MyAppointment.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<MyAppointment> appointments) {
    this.appointments = appointments;
  }

  MyAppointment getEvent(int index) => appointments![index] as MyAppointment;

 //IconData? getIcon(int index) => getEvent(index).icon;

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


}
