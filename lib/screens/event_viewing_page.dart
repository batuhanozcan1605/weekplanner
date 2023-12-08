import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';
import '../model/event.dart';

class EventViewingPage extends StatelessWidget {
  final Event event;

  EventViewingPage({required this.event});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: CloseButton(),
      actions: buildViewingActions(context, event),
    ),
    body: ListView(
      padding: EdgeInsets.all(32),
      children: <Widget>[
        buildDateTime(event),
        SizedBox(height: 32),
        Text(
          event.title,
          style: TextStyle(
              color: Constants.softColor, fontSize: 22, fontFamily: 'Segoe UI'),
        ),
        SizedBox(height: 24,),
        Text(event.detail ?? '', style: TextStyle(color: Constants.softColor, fontSize: 18, fontFamily: 'Segoe UI'),)
      ],
    ),
  );

  Widget buildDateTime(Event event) => Column(

  );


}

List<Widget> buildViewingActions(BuildContext context,Event event) => [

  IconButton(
    icon: Icon(Icons.edit, color: Constants.softColor,),
    onPressed: () {

    },
  ),
  IconButton(
    onPressed: () {

    },
    icon: Icon(Icons.delete, color: Constants.softColor,),

  )

  ];
