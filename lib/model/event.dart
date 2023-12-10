import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';

class Event {
  final String subject;
  final String detail;
  final IconData icon;
  final DateTime from;
  final DateTime to;
  final Color color;
  final String? recurrenceRule;

  Event(
      {required this.subject,
      required this.detail,
      required this.icon,
      required this.from,
      required this.to,
      this.color = Colors.deepPurple,
        this.recurrenceRule,
      });
}
