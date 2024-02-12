import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:weekplanner/model/event_data_source.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import '../model/MyAppointment.dart';
import '../screens/event_viewing_page.dart';
import '../utils.dart';

class DailyView extends StatefulWidget {
  const DailyView({super.key});

  @override
  State<DailyView> createState() => _DailyViewState();
}

class _DailyViewState extends State<DailyView> with SingleTickerProviderStateMixin {
  late CalendarController _controller;
  late AnimationController _animationController;
  DateTime selectedDay = DateTime.now();
  final dayListKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  bool showTutorial = true;

  void _initMainScreenInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: Utils().dailyViewTarget(
            dayListKey: dayListKey,
        ),
        skipWidget: const Card(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text('SKIP TUTORIAL', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
          ),
        ),
        colorShadow: Colors.grey,
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print("Completed");
          setState(() {
            showTutorial = false; // Tutorial tamamlandıktan sonra gösterme bayrağını kapat
          });
        }
    );
  }

  void _showInAppTour() {
    Future.delayed(const Duration(seconds: 1), () {
      tutorialCoachMark.show(context: context);
    });
  }

  void _checkTutorialStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShownDailyView') ?? false;

    if (!tutorialShown && showTutorial) {
      _initMainScreenInAppTour();
      _showInAppTour();
      prefs.setBool('tutorialShownDailyView', true);
    }
  }

  @override
  void initState() {
    _controller = CalendarController();
    setDefaultCellDate();
    _animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),);
    _checkTutorialStatus();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> setDefaultCellDate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedDateTime', DateTime.now().toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return Column(
      children: [
        Expanded(
          flex: 1,
            child: dayListView()
        ),
        Expanded(
          flex: 12,
              child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                return Opacity(
                  opacity: _animationController.value,
                  child: SfCalendar(
                    view: CalendarView.day,
                    onViewChanged: (ViewChangedDetails details) {
                      // Update selectedDay when the view changes
                      Future.delayed(Duration.zero, () {
                        // Update selectedDay when the view changes
                        setState(() {
                          selectedDay = details.visibleDates[0];
                          _animationController.reset();
                          _animationController.forward();
                        });
                      });
                    },
                    controller: _controller,
                    //showNavigationArrow: true,
                    dataSource: EventDataSource(appointments),
                    initialSelectedDate: DateTime.now(),
                    //cellBorderColor: Colors.transparent,
                    appointmentBuilder: appointmentBuilder,
                    onTap: (details) async {
                      if (details.appointments != null) {
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

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                EventViewingPage(appointment: myAppointment)));
                      } else
                      if (details.targetElement == CalendarElement.calendarCell) {
                        DateTime tappedDate = details.date!;

                        //save cell info
                        final SharedPreferences prefs = await SharedPreferences
                            .getInstance();
                        prefs.setString(
                            'selectedDateTime', tappedDate.toIso8601String());
                      }
                    },
                    headerHeight: 0,
                  ),
                );
    }
              ),
        ),
      ],
    );
  }

  Widget dayListView() {
    return Builder(
      builder: (context) {
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        var screenSize = MediaQuery.of(context).size;
        final width = screenSize.width;
        double tileWidth = width/10.3 ;
        return Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Align(
            alignment: Alignment.center,
            child: ListView(
              key: dayListKey,
              scrollDirection: Axis.horizontal,
              children: List.generate(14, (index) {

                DateTime currentDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
                DateTime day = currentDate.add(Duration(days: index));
                return GestureDetector(
                  onTap: () {
                    _controller.displayDate = day;
                    setState(() {
                      selectedDay = day;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Container(
                      width: tileWidth,
                      decoration: BoxDecoration(
                      color: colorScheme.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                color: colorScheme.background,
                width: 1
                ),),
                      alignment: Alignment.center,
                       // Customize the color as needed
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          day.day == DateTime.now().day ? Flexible(
                            flex: 1,
                            child: Text(
                              'Today',
                              style: TextStyle(
                                fontSize: 12,
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ) : Flexible(
                            flex: 1,
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5,),
                          Flexible(
                            flex: 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              width: selectedDay.day == day.day ? 10:0,
                              height: selectedDay.day == day.day ? 10:0,
                              child: CircleAvatar(
                                backgroundColor: colorScheme.primary,
                                //radius: 5,
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }
    );
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details,
      ) {
    final icons = Provider.of<AppointmentProvider>(context).icons;
    final event = details.appointments.first;
    final halfHour = details.bounds.height < 20 ? true : false;
    final sameTimeEvents = details.bounds.width < 179 ? true : false;

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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: halfHour || sameTimeEvents ? 16 : 20,
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
