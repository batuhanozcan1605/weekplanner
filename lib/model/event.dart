import 'dart:ui';

class Event {
  final String title;
  final String detail;
  final String icon;
  final DateTime from;
  final DateTime to;
  final String backgroundColor;
  final bool isEveryDay;
  final bool isRepetative;

  Event(this.title, this.detail, this.icon, this.from, this.to,
      this.backgroundColor, this.isEveryDay, this.isRepetative);
}