import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/model/event_data_source.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import '../model/MyAppointment.dart';
import '../screens/event_viewing_page.dart';

class CalenderWidget extends StatefulWidget {
  @override
  State<CalenderWidget> createState() => _CalenderWidgetState();
}

class _CalenderWidgetState extends State<CalenderWidget> {
  late CalendarController _controller;

  @override
  void initState() {
    _controller = CalendarController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<AppointmentProvider>(context).events;

    return Column(
      children: [
        Expanded(
          flex: 1,
            child: dayListView()
        ),
        Expanded(
          flex: 12,
          child: SfCalendar(
            view: CalendarView.day,
            controller: _controller,
            //showNavigationArrow: true,
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

              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EventViewingPage(appointment: myAppointment)));
            },
            headerHeight: 0,
          ),
        ),
      ],
    );
  }

  Widget dayListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
      child: Align(
        alignment: Alignment.center,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(14, (index) {
            DateTime currentDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
            DateTime day = currentDate.add(Duration(days: index));
            return GestureDetector(
              onTap: () {
                _controller.displayDate = day;
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 40,
                  decoration: day.day == DateTime.now().day ? BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Constants.themePurple,
                          width: 1
                      )
                  ) : BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.black,
                      width: 1
                    )
                  ),
                  alignment: Alignment.center,
                   // Customize the color as needed
                  child: Text(
                     '${day.day}',
                    style: TextStyle(
                      color: Constants.themePurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
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
