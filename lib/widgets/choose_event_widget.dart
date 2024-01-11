import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/data.dart';
import 'package:weekplanner/provider/appointment_provider.dart';

class ChooseEvent extends StatelessWidget {
  const ChooseEvent({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final width = screenSize.width;
    final cardSize = (width-40)/4;
    List eventTemplate = Data().eventTemplates;
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    List latestEvents = provider.get8LatestEvents();
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    //print(latestEvents);

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.background,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const Padding(
              padding: EdgeInsets.only(left: 18.0, bottom: 8),
              child: Text("Latest", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, fontFamily: 'Segoe UI'),),
            ),
              Container(
                height: latestEvents.isNotEmpty ? cardSize : 10,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: latestEvents.length, // Adjust the number of items as needed
                  itemBuilder: (context, index) {
                    final event = latestEvents[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, event);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Add spacing between items
                        child: Constants().eventCard(event.subject, event.icon, event.color.withOpacity(0.7)),
                      ),
                    );
                  },
                ),
              ),
            const Padding(
              padding: EdgeInsets.all(18.0),
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
