import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/widgets/schedule_view.dart';
import '../provider/event_provider.dart';
import '../widgets/calender_widget.dart';
import 'event_editing_page.dart';

class DayScreen extends StatefulWidget {
  const DayScreen({Key? key}) : super(key: key);

  @override
  State<DayScreen> createState() => _DayScreenState();
}

class _DayScreenState extends State<DayScreen> {
  bool scheduleView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () => setState(() {
                        scheduleView = true;
                      }),
                      icon: Icon(Icons.view_timeline, color: scheduleView == true ? Constants.themePurple : Colors.white)),
                  IconButton(
                      onPressed: () => setState(() {
                        scheduleView = false;
                      }),
                      icon: Icon(Icons.view_day, color: scheduleView == false ? Constants.themePurple : Colors.white)),
                ],
              ),
            ),
            Expanded(
                child: AnimatedSwitcher(
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  duration: Duration(milliseconds: 500),
                  child: scheduleView == false ? CalenderWidget() : const ScheduleView())),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.themePurple,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => EventEditingPage()),
        ),
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
