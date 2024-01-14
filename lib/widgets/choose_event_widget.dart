import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/data.dart';
import 'package:weekplanner/widgets/latest_events_pageview.dart';

class ChooseEvent extends StatelessWidget {
  const ChooseEvent({super.key});

  @override
  Widget build(BuildContext context) {
    List eventTemplate = Data().eventTemplates;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

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
              child: Text("Latest", style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
            ),
              const LatestEvents(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
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

