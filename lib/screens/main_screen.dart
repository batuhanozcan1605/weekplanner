import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/widgets/schedule_view.dart';
import 'package:weekplanner/widgets/week_view.dart';
import '../widgets/daily_view.dart';
import 'event_editing_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool scheduleView = false;
  bool weekView = true;
  bool dayView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => setState(() {
                    scheduleView = true;
                    weekView = false;
                    dayView = false;
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_timeline, color: scheduleView == true ? Constants.themePurple : Colors.white),
                      const SizedBox(height: 10,),
                      Text('TO DO', style: TextStyle(color: scheduleView == true ? Constants.themePurple : Colors.white),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => setState(() {
                    scheduleView = false;
                    weekView = true;
                    dayView = false;
                  }),
                  child: Column(
                    children: [
                    Icon(Icons.view_week_rounded, color: weekView == true ? Constants.themePurple : Colors.white),
                      const SizedBox(height: 10,),
                      Text('WEEKS', style: TextStyle(color: weekView == true ? Constants.themePurple : Colors.white),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => setState(() {
                    scheduleView = false;
                    weekView = false;
                    dayView = true;
                  }),
                  child: Column(
                    children: [
                      Icon(Icons.view_day, color: dayView == true ? Constants.themePurple : Colors.white),
                      const SizedBox(height: 10,),
                      Text('DAYS', style: TextStyle(color: dayView == true ? Constants.themePurple : Colors.white),),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
                child: AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: const Duration(milliseconds: 500),
                  child: weekView ? const WeekView() : AnimatedSwitcher(
                      switchInCurve: Curves.easeIn,
                      switchOutCurve: Curves.easeOut,
                      duration: const Duration(milliseconds: 500),
                      child: scheduleView == false ? const DailyView() : const ScheduleView()),)
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
          // ignore: use_build_context_synchronously
          Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => EventEditingPage(cellDate: cellDate,)),
        );
          }
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
