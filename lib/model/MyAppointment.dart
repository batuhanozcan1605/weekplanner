import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MyAppointment extends Appointment {
  final String? recurrenceRule;
  final int? id;
  final IconData? icon;

  MyAppointment({
    this.id,
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    required String notes,
    required Color color,
    this.icon,
    this.recurrenceRule,
  }) : super(
    startTime: startTime,
    endTime: endTime,
    subject: subject,
    notes: notes,
    color: color,
  );

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
    );
  }
}