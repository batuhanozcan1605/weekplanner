import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/widgets/schedule_view.dart';
import 'package:weekplanner/widgets/week_view.dart';
import '../provider/appointment_provider.dart';
import '../widgets/daily_view.dart';
import 'event_editing_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool scheduleView = false;
  bool weekView = false;
  bool dayView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                          scheduleView = true;
                          weekView = false;
                          dayView = false;
                        }),
                        icon: Icon(Icons.view_timeline, color: scheduleView == true ? Constants.themePurple : Colors.white)),
                    Text('SCHEDULE', style: TextStyle(color: scheduleView == true ? Constants.themePurple : Colors.white),),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                          weekView = true;
                          scheduleView = false;
                          dayView = false;
                        }),
                        icon: Icon(Icons.view_week_rounded, color: weekView == true ? Constants.themePurple : Colors.white)),
                    Text('WEEKS', style: TextStyle(color: weekView == true ? Constants.themePurple : Colors.white),),
                  ],
                ),
                SizedBox(width: 20,),
                Column(
                  children: [
                    IconButton(
                        onPressed: () => setState(() {
                          scheduleView = false;
                          weekView = false;
                          dayView = true;
                        }),
                        icon: Icon(Icons.view_day, color: dayView == true ? Constants.themePurple : Colors.white)),
                    Text('DAYS', style: TextStyle(color: dayView == true ? Constants.themePurple : Colors.white),),
                  ],
                ),
              ],
            ),
            Expanded(
                child: AnimatedSwitcher(
                  child: weekView ? WeekView() : AnimatedSwitcher(
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      duration: Duration(milliseconds: 500),
                      child: scheduleView == false ? DailyView() : const ScheduleView()),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: Duration(milliseconds: 500),)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.themePurple,
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? selectedDateTimeString = prefs.getString('selectedDateTime');
          if(selectedDateTimeString != null) {
            final DateTime cellDate = DateTime.parse(selectedDateTimeString);
            print("CELL DATE $cellDate");
          Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => EventEditingPage(cellDate: cellDate,)),
        );
          }
        },
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
