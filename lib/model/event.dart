import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';

class Event {
  final String title;
  final String? detail;
  final String? icon;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay;
  final bool isRepetative;

  Event(
      {required this.title,
      this.detail,
      this.icon,
      required this.from,
      required this.to,
      this.backgroundColor = Colors.deepPurple,
      required this.isAllDay,
      required this.isRepetative});
}
