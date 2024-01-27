import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../model/MyAppointment.dart';
import '../model/event_data_source.dart';
import '../provider/appointment_provider.dart';
import '../screens/event_viewing_page.dart';

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  Future<void> setDefaultCellDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDateTime', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    setDefaultCellDate();
    final events = Provider.of<AppointmentProvider>(context).events;

    return Localizations.override(
      context: context,
      child: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 1,
        dataSource: EventDataSource(events),
        initialSelectedDate: DateTime.now(),
        //cellBorderColor: Colors.transparent,
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
                isCompleted: event.recurrenceRule == null ? event.isCompleted : 0,
            );
      
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(appointment: myAppointment)));
          } else if(details.targetElement == CalendarElement.calendarCell) {
            DateTime tappedDate = details.date!;
      
            //save cell info
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('selectedDateTime', tappedDate.toIso8601String());
          }
        },
        headerHeight: 0,
      ),
    );

  }
  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details,
      ) {
    final icons = Provider.of<AppointmentProvider>(context).icons;
    final event = details.appointments.first;

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

