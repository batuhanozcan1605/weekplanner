import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/simple_widgets.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/utils.dart';
import '../model/MyAppointment.dart';
import '../provider/appointment_provider.dart';

class EventViewingPage extends StatelessWidget {
  const EventViewingPage({super.key, required this.appointment});

  final MyAppointment appointment;

  @override
  Widget build(BuildContext context) {
    final icons = Provider.of<AppointmentProvider>(context).icons;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title:  Text(appointment.subject,style: const TextStyle(
            fontFamily: 'Segoe UI',
            fontSize: 20,
            fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => EventEditingPage(appointment: appointment, iconFromEdit: icons[appointment.id])));
            },
            icon: const Icon(Icons.edit), color: colorScheme.onBackground,),
          IconButton(
            onPressed: () {
              final provider = Provider.of<AppointmentProvider>(context, listen: false);
              provider.deleteEvent(appointment);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete), color: colorScheme.onBackground,)
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
                    child: Text('FROM', style: TextStyle(color: colorScheme.primary),)),
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
                      child: Text('TO', style: TextStyle(color: colorScheme.primary))),
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
            appointment.recurrenceRule != null ? const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
              Icon(Icons.repeat, color: SimpleWidgets.themePurple,),
              SizedBox(width: 8,),
              Text('Recurring Event'),
            ],
            ) : const Center(),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Divider(color: SimpleWidgets.themePurple,),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: appointment.notes == null ? const Text("") : Text(appointment.notes!, style: TextStyle(color: colorScheme.onBackground),),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 300,
                height: 300,
                color: Colors.white,
                child: const Center(child: Text('AD BANNER', style: TextStyle(color: Colors.orangeAccent),)),
              ),
            )
          ],
        ),
      )
    );
  }
}
