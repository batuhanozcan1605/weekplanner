import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Utils {
  static String toDate(DateTime dateTime) {
    final date = DateFormat.MMMEd().format(dateTime);

    return date;
  }

  static String toTime(DateTime dateTime) {
    final time = DateFormat.Hm().format(dateTime);
    return time;
  }

  static DateTime roundOffMinute(DateTime dateTime) {
    int roundedMinute = dateTime.minute < 30 && dateTime.minute > 0 ? 30 : 0;
    final newDateTime = dateTime.minute < 30
        ? dateTime
            .subtract(Duration(minutes: dateTime.minute % 30))
            .add(Duration(minutes: roundedMinute))
        : dateTime
            .subtract(Duration(minutes: dateTime.minute % 30))
            .add(Duration(minutes: roundedMinute))
            .add(const Duration(hours: 1));
    return DateTime(
      newDateTime.year,
      newDateTime.month,
      newDateTime.day,
      newDateTime.hour,
      roundedMinute,
    );
  }

  static String dayAbbreviation(DateTime fromDate) {
    int weekday = fromDate.weekday;
    switch (weekday) {
      case 1:
        return 'MO';
      case 2:
        return 'TU';
      case 3:
        return 'WE';
      case 4:
        return 'TH';
      case 5:
        return 'FR';
      case 6:
        return 'SA';
      case 7:
        return 'SU';
      default:
        return '';
    }
  }

  static String dayAbbreviationForMultipleDays(
      List<DateTime> selectedDateObjects) {
    String multipleDays = dayAbbreviation(selectedDateObjects.first);
    for (int i = 1; i < selectedDateObjects.length; i++) {
      String day = dayAbbreviation(selectedDateObjects[i]);
      multipleDays = '$multipleDays,$day';
    }
    return multipleDays;
  }

  List<TargetFocus> mainScreenTargets({
    required GlobalKey viewNavigator,
    required GlobalKey fabKey,
  }) {
    List<TargetFocus> targets = [];

    targets.add(TargetFocus(
        keyTarget: viewNavigator,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        radius: 10,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.bottom,
              builder: (context, controller) {
                return Container(
                  alignment: Alignment.center,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You can change the calender view here.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ]),
    );

    targets.add(TargetFocus(
        keyTarget: fabKey,
        enableOverlayTab: true,
        alignSkip: Alignment.topRight,
        radius: 10,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
              align: ContentAlign.top,
              builder: (context, controller) {
                return Container(
                  alignment: Alignment.center,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You can add an event from here.\n(Tap to the calender cell you want to assign before)",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ]),
    );

    return targets;
  }
}
