import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';

class Event {
  final String title;
  final String detail;
  final IconData icon;
  final DateTime from;
  final DateTime to;
  final Color backgroundColor;
  final bool isAllDay; //bu iptal olacak.
  final bool isRepetitive;

  Event(
      {required this.title,
      required this.detail,
      this.icon = Icons.square_rounded,
      required this.from,
      required this.to,
      this.backgroundColor = Colors.deepPurple,
      required this.isAllDay,
      required this.isRepetitive});
}
