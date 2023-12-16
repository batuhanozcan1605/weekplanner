import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weekplanner/model/Events.dart';
class Data {

final List<Color> colors = [
  Color(0xB3673AB7),
  Color(0xB3FFC107),
  Color(0xB34CAF50),
  Color(0xB342A1E9),
  Color(0xB3E53935),
];

final List<Events> eventTemplates = [
  Events(subject: 'Work', icon: Icons.work, color: Color(0xB3673AB7)),
  Events(subject: 'Breakfast', icon: Icons.free_breakfast_rounded, color: Color(0xB3FFC107)),
  Events(subject: 'Friends', icon: Icons.people_outline, color: Color(0xB3E53935),),
  Events(subject: 'Gym', icon: Icons.fitness_center_rounded, color: Color(0xB342A1E9),),
  Events(subject: 'Side-hustle', icon: Icons.view_sidebar, color: Color(0xB3673AB7)),
  Events(subject: 'Lunch', icon: Icons.lunch_dining_rounded, color: Color(0xB3FFC107)),
];

}