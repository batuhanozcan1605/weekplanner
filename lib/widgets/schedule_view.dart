import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../constants.dart';
import '../model/MyAppointment.dart';
import '../model/event_data_source.dart';
import '../provider/appointment_provider.dart';
import '../screens/event_viewing_page.dart';
import 'dart:math';

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key? key}) : super(key: key);

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
      scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
          monthHeaderSettings: MonthHeaderSettings(backgroundColor: Constants.themePurple,
              monthTextStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.w500))),
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
          notes: event.notes,
          isCompleted: event.recurrenceRule == null ? event.isCompleted : 0,
        );
        print('DEBUG ${event.subject}');
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
    //print('Appointment Details: $event');
    String uniqueId = getUniqueId(event.id.toString(), event.startTime);

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
                              ? Icon(Icons.check_circle_rounded, color: Colors.white)
                              : Icon(Icons.check_circle_outline_rounded, color: Colors.white),
                          onPressed: () {
                            //print(event.isCompleted);
                            setState(() {
                              tappedEventId = event.id;
                            });
                            print(isCompleted[event.id]);
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

String getUniqueId(String eventId, DateTime occurrenceDateTime) {
  return '$eventId-${occurrenceDateTime.toIso8601String()}';
}
