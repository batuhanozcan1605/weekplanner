import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/model/event.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/utils.dart';

import '../provider/event_provider.dart';

class EventViewingPage extends StatelessWidget {
  const EventViewingPage({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => EventEditingPage(event: event,)));
            },
            icon: Icon(Icons.edit), color: Constants.softColor,),
          IconButton(
            onPressed: () {
              final provider = Provider.of<EventProvider>(context, listen: false);
              provider.deleteEvent(event);
              Navigator.pop(context);
            },
            icon: Icon(Icons.delete), color: Constants.softColor,)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                    child: Text('FROM', style: TextStyle(color: Constants.themePurple),)),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.toDate(event.from)),
                      Text(Utils.toTime(event.from)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text('TO', style: TextStyle(color: Constants.themePurple))),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Utils.toDate(event.to)),
                        Text(Utils.toTime(event.to)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Divider(color: Constants.themePurple,),
            ),
            Text(event.subject,style: TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(event.detail),
            ),
          ],
        ),
      )
    );
  }
}
