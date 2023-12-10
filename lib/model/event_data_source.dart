import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/model/event.dart';

class EventDataSource extends CalendarDataSource{
  EventDataSource(List<Event> appointments) {
    this.appointments = appointments;
  }

  Event getEvent(int index) => appointments![index] as Event;

  IconData getIcon(int index) => getEvent(index).icon;

  @override
  DateTime getStartTime(int index) => getEvent(index).from;


  @override
  DateTime getEndTime(int index) => getEvent(index).to;


  @override
  String getSubject(int index) => getEvent(index).subject;

  @override
  Color getColor(int index) => getEvent(index).color;

  @override
  String? getRecurrenceRule(int index) => getEvent(index).recurrenceRule;


}
