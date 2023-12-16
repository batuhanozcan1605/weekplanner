import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/utils.dart';
import '../model/MyAppointment.dart';
import '../provider/appointment_provider.dart';

class EventViewingPage extends StatelessWidget {
  const EventViewingPage({Key? key, required this.appointment}) : super(key: key);

  final MyAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => EventEditingPage(appointment: appointment,)));
            },
            icon: const Icon(Icons.edit), color: Constants.softColor,),
          IconButton(
            onPressed: () {
              final provider = Provider.of<AppointmentProvider>(context, listen: false);
              provider.deleteEvent(appointment);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete), color: Constants.softColor,)
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
                      Text(Utils.toDate(appointment.startTime)),
                      Text(Utils.toTime(appointment.startTime)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
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
                        Text(Utils.toDate(appointment.endTime)),
                        Text(Utils.toTime(appointment.endTime)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            appointment.recurrenceRule != null ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Icon(Icons.repeat, color: Constants.themePurple,),
              const SizedBox(width: 8,),
              const Text('Recurring Event'),
            ],
            ) : const Center(),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Divider(color: Constants.themePurple,),
            ),
            Text(appointment.subject,style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: Text(appointment.notes!),
            ),
          ],
        ),
      )
    );
  }
}
