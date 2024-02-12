import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/MyAppointment.dart';
import '../model/event_data_source.dart';
import '../provider/appointment_provider.dart';
import '../screens/event_editing_page.dart';
import '../screens/event_viewing_page.dart';

class WeekView extends StatefulWidget {
  const WeekView({super.key});

  @override
  State<WeekView> createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  Future<void> setDefaultCellDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDateTime', DateTime.now().toIso8601String());
  }



  @override
  Widget build(BuildContext context) {
    setDefaultCellDate();
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return SfCalendar(
      view: CalendarView.week,
      firstDayOfWeek: 1,
      allowDragAndDrop: true,
      onDragEnd: (AppointmentDragEndDetails appointmentDragEndDetails) {
        dynamic appointment = appointmentDragEndDetails.appointment!;
        provider.editDraggedAppointment(appointment);
      },
      dataSource: EventDataSource(appointments),
      initialSelectedDate: DateTime.now(),
      appointmentBuilder: appointmentBuilder,
      onTap: (details) async {
        if(details.appointments != null) {
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

          Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(appointment: myAppointment)));
        } else if(details.targetElement == CalendarElement.calendarCell) {
          DateTime tappedDate = details.date!;
          //save cell info
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('selectedDateTime', tappedDate.toIso8601String());
        }
      },
      /*onLongPress: (CalendarLongPressDetails details) {
        DateTime date = details.date!;
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventEditingPage(cellDate: date,)));
      },*/
      headerHeight: 0,
    );

  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details,
      ) {
    final icons = Provider.of<AppointmentProvider>(context).icons;
    final event = details.appointments.first;
    print('object event $event ');
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: event.color.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(icons[event.id], color: Colors.white),
      ),
    );

  }
}

