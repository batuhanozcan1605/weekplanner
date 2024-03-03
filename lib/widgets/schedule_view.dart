import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/MyAppointment.dart';
import '../model/event_data_source.dart';
import '../provider/appointment_provider.dart';
import '../screens/event_viewing_page.dart';
import 'dart:math';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils.dart';


class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  int tappedEventId = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<AppointmentProvider>(context).events;

      return SfCalendar(
        view: CalendarView.schedule,
        firstDayOfWeek: 1,
        scheduleViewMonthHeaderBuilder: scheduleViewHeaderBuilder,
        scheduleViewSettings: const ScheduleViewSettings(
            hideEmptyScheduleWeek: false,
            ),
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        //cellBorderColor: Colors.transparent,
        appointmentBuilder: appointmentBuilder,
        onTap: (details) {
          if(details.appointments == null) return;
          final event = details.appointments!.first;
          final myAppointment = MyAppointment(
            id: event.id,
            startTime: event.startTime,
            endTime: event.endTime,
            subject: event.subject,
            color: event.color,
            recurrenceRule: event.recurrenceRule,
            recurrenceExceptionDates: event.recurrenceExceptionDates,
            notes: event.notes,
            isCompleted: event.recurrenceRule == null ? event.isCompleted : 0,
          );
          //print('DEBUG ${event.subject}');
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(appointment: myAppointment)));
        },
        headerHeight: 0,
      );

  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details,
      ) {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    final isCompleted = Provider.of<AppointmentProvider>(context).isCompleted;
    final icons = Provider.of<AppointmentProvider>(context).icons;
    final uniqueIds = Provider.of<AppointmentProvider>(context).uniqueIds;
    final event = details.appointments.first;

    String uniqueId = Utils.getUniqueId(event.id.toString(), event.startTime);

    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: isCompleted[event.id] == 1 || uniqueIds.contains(uniqueId) ? Colors.grey : event.color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icons[event.id], color: Colors.white)),
            ), // Add some spacing between the Icon and Text
            Center(
              child: Text(
                event.subject,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  decoration: isCompleted[event.id] == 1 || uniqueIds.contains(uniqueId) ? TextDecoration.lineThrough : TextDecoration.none,
                  decorationThickness: 3.0,
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 9.0),
              child: Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedBuilder(
                    animation: controller, // Assuming you have an AnimationController
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: tappedEventId == event.id ? controller.value * (isCompleted[event.id]  == 1 ? 2*pi : 2*pi) : controller.value * 0, // Rotate based on isCompleted
                        child: IconButton(
                          icon: isCompleted[event.id] == 1 || uniqueIds.contains(uniqueId)
                              ? const Icon(Icons.check_circle_rounded, color: Colors.white)
                              : const Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                          onPressed: () {
                            //print(event.isCompleted);
                            setState(() {
                              tappedEventId = event.id;
                            });

                            controller.reset();
                            if(event.recurrenceRule == null) {
                              provider.editCompletedEvent(event);
                              controller.forward();
                            }else{
                              uniqueIds.contains(uniqueId) ? provider.deleteUniqueIds(uniqueId)
                                  : provider.addUniqueId(uniqueId);
                              controller.forward();
                            }
                          },
                        ),
                      );
                    },
                  ),
              ),
            ),
          ],
        ),
      ),
    );

  }
}



Widget scheduleViewHeaderBuilder(
    BuildContext buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = _getMonthName(details.date.month);
  final localization = AppLocalizations.of(buildContext)!;

  return Stack(
    children: [
      Image(
          image: ExactAssetImage('assets/images/$monthName.png'),
          fit: BoxFit.cover,
          width: details.bounds.width,
          height: details.bounds.height),
      Positioned(
        left: 55,
        right: 0,
        top: 40,
        bottom: 0,
        child: Text(
          _getLocaleMonthName(details.date.month, localization),
          style: TextStyle(fontSize: 28, fontFamily: 'Montserrat'),
        ),
      )
    ],
  );
}

String _getMonthName(int month) {
  if (month == 01) {
    return 'january';
  } else if (month == 02) {
    return 'february';
  } else if (month == 03) {
    return 'march';
  } else if (month == 04) {
    return 'april';
  } else if (month == 05) {
    return 'may';
  } else if (month == 06) {
    return 'june';
  } else if (month == 07) {
    return 'july';
  } else if (month == 08) {
    return 'august';
  } else if (month == 09) {
    return 'september';
  } else if (month == 10) {
    return 'october';
  } else if (month == 11) {
    return 'november';
  } else {
    return 'december';
  }
}

String _getLocaleMonthName(int month, localization) {
  if (month == 01) {
    return localization.january;
  } else if (month == 02) {
    return localization.february;
  } else if (month == 03) {
    return localization.march;
  } else if (month == 04) {
    return localization.april;
  } else if (month == 05) {
    return localization.may;
  } else if (month == 06) {
    return localization.june;
  } else if (month == 07) {
    return localization.july;
  } else if (month == 08) {
    return localization.august;
  } else if (month == 09) {
    return localization.september;
  } else if (month == 10) {
    return localization.october;
  } else if (month == 11) {
    return localization.november;
  } else {
    return localization.december;
  }
}
