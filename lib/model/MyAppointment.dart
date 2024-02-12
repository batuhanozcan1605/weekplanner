import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyAppointment extends Appointment {

  final String? recurrenceRule;
  final int? id;
  final IconData? icon;
  var isCompleted;


  MyAppointment({
    this.id,
    required super.startTime,
    required super.endTime,
    required super.subject,
    required String? super.notes,
    required super.color,
    this.icon,
    this.recurrenceRule,
    this.isCompleted
  });

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'subject': subject,
      'notes': notes,
      'color': color.value,
      'icon': icon!.codePoint,
      'recurrenceRule': recurrenceRule,
      'isCompleted' : isCompleted,
    };
  }

  // Create MyAppointment from Map
  factory MyAppointment.fromMap(Map<String, dynamic> map) {
    return MyAppointment(
      id: map['id'],
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      subject: map['subject'],
      notes: map['notes'],
      color: Color(map['color']),
      icon: IconData(map['icon'], fontFamily: 'MaterialIcons'),
      recurrenceRule: map['recurrenceRule'],
      isCompleted: map['isCompleted']
    );
  }
}