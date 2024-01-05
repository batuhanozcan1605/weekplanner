import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../constants.dart';
import '../model/MyAppointment.dart';
import '../model/event_data_source.dart';
import '../provider/appointment_provider.dart';
import '../screens/event_viewing_page.dart';

class ScheduleView extends StatelessWidget {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<AppointmentProvider>(context).events;

    return SfCalendar(
      view: CalendarView.schedule,
      firstDayOfWeek: 1,
      scheduleViewSettings: ScheduleViewSettings(
          hideEmptyScheduleWeek: true,
          monthHeaderSettings: MonthHeaderSettings(backgroundColor: Constants.themePurple,
              monthTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500))),
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
    final icons = Provider.of<AppointmentProvider>(context).icons;
    final event = details.appointments.first;
    print('Appointment Details: $event');
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.7),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Segoe UI',
                ),
              ),
            ),
          ],
        ),
      ),
    );


  }
}
