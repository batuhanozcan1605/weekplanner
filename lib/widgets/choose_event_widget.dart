import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/data.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/screens/event_viewing_page.dart';

class ChooseEvent extends StatelessWidget {
  const ChooseEvent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List eventTemplate = Data().eventTemplates;

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black38,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: eventTemplate.length, // Adjust the number of items as needed
          itemBuilder: (context, index) {
            final event = eventTemplate[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (BuildContext context) => EventEditingPage(eventTemplate: event,),
                )
                );
              },
                child: Constants().eventCard(event.subject, event.icon, event.color));
          },
        ),
      ),
    );
  }
}
