import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/data.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/screens/event_viewing_page.dart';

class ChooseEvent extends StatelessWidget {
  const ChooseEvent({super.key});

  @override
  Widget build(BuildContext context) {

    List eventTemplate = Data().eventTemplates;
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    List latestEvents = provider.get4LatestEvents();
    print(latestEvents);

    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black38,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.only(left: 18.0, bottom: 8),
              child: const Text("Latest", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Segoe UI'),),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: latestEvents.length, // Adjust the number of items as needed
              itemBuilder: (context, index) {
                final event = latestEvents[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.pop(context, event);

                    },
                    child: Constants().eventCard(event.subject, event.icon, event.color.withOpacity(0.7)));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Divider(),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: eventTemplate.length, // Adjust the number of items as needed
              itemBuilder: (context, index) {
                final event = eventTemplate[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, event);

                  },
                    child: Constants().eventCard(event.subject, event.icon, event.color));
              },
            ),
          ],
                ),
        )
      ),
    );
  }
}
