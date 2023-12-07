import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/screens/day_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week Planner App',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        primaryColor: Constants.primaryColor
      ),
      home: const DayScreen(),
    );
  }
}


//to test the system
class MyCalendar extends StatelessWidget {
  CalendarController _controller = CalendarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customizing Appointment View'),
      ),
      body: SfCalendar(
        view: CalendarView.day,
        dataSource: _getCalendarDataSource(),
        appointmentBuilder: (BuildContext buildContext,
            CalendarAppointmentDetails details) {
          final Appointment meeting =
              details.appointments.first;
    if (_controller.view != CalendarView.day &&
    _controller.view != CalendarView.schedule) {
          return Container(
            width: details.bounds.width ,
            height: details.bounds.height ,
            color: meeting.color,
            child: Stack(
              children: [
                Positioned(
                  top: 5,
                  left: 5,
                  child: Icon(
                    Icons.access_alarm, // Replace with your desired icon
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: Text(
                    meeting.subject,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
    } else {
      return Center();
    }
        },
      ),
    );
  }

  // Dummy data source for testing
  DataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    DateTime today = DateTime.now();

    appointments.add(Appointment(
      startTime: today,
      endTime: today.add(Duration(hours: 1)),
      subject: 'Meeting 1',
      color: Colors.blue,
    ));

    appointments.add(Appointment(
      startTime: today.add(Duration(hours: 12)),
      endTime: today.add(Duration(hours: 13)),
      subject: 'Lunch',
      color: Colors.green,

    ));

    appointments.add(Appointment(
      startTime: today.add(Duration(days: 1)),
      endTime: today.add(Duration(days: 1, hours: 1)),
      subject: 'Meeting 2',
      color: Colors.blue,
    ));

    return DataSource(appointments);
  }
}

class DataSource extends CalendarDataSource {
  DataSource(List  source) {
    appointments = source;
  }
}

