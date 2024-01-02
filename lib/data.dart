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

  Events(subject: 'School', icon: Icons.school_rounded, color: Color(0xB3673AB7)),
  Events(subject: 'Lunch', icon: Icons.lunch_dining_rounded, color: Color(0xB3FFC107)),
  Events(subject: 'Love', icon: Icons.favorite, color: Color(0xB3E53935),),
  Events(subject: 'Meditation', icon: Icons.self_improvement_rounded, color: Color(0xB342A1E9),),

  Events(subject: 'Side-hustle', icon: Icons.view_sidebar, color: Color(0xB3673AB7)),
  Events(subject: 'Dinner', icon: Icons.dinner_dining_rounded, color: Color(0xB3FFC107)),
  Events(subject: 'Family', icon: Icons.family_restroom_rounded, color: Color(0xB3E53935),),
  Events(subject: 'Reading', icon: Icons.menu_book_rounded, color: Color(0xB342A1E9),),

  Events(subject: 'Chores', icon: Icons.cleaning_services_rounded, color: Color(0xB3673AB7)),
  Events(subject: 'Shopping', icon: Icons.shopping_cart_rounded, color: Color(0xB3FFC107)),
  Events(subject: 'Leisure Time', icon: Icons.games_rounded, color: Color(0xB3E53935),),
  Events(subject: 'Walk/Exercise', icon: Icons.directions_walk_rounded, color: Color(0xB342A1E9),),

  Events(subject: 'Pet Care', icon: Icons.pets_rounded, color: Color(0xB3673AB7)),
  Events(subject: 'Movie/TV', icon: Icons.theaters_rounded, color: Color(0xB3FFC107)),
  Events(subject: 'Party', icon: Icons.nightlife_rounded, color: Color(0xB3E53935),),
  Events(subject: 'Self-Care', icon: Icons.spa_outlined, color: Color(0xB342A1E9),),

];

}