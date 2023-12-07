import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';
import '../widgets/calender_widget.dart';
import 'event_editing_page.dart';

class DayScreen extends StatelessWidget {
  const DayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalenderWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Constants.themePurple,
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => EventEditingPage()),
        ),
      ),
    );
  }
}
