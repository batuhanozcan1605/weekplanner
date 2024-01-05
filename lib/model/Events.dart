import 'dart:ui';
import 'package:flutter/material.dart';

class Events {
  final String subject;
  final IconData? icon;
  final Color color;


  Events(
      {required this.subject,
      required this.icon,
      required this.color,
      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Events &&
              runtimeType == other.runtimeType &&
              subject == other.subject &&
              icon == other.icon &&
              color == other.color;

  @override
  int get hashCode => subject.hashCode ^ icon.hashCode ^ color.hashCode;
}

