import 'package:flutter/material.dart';
import 'package:weekplanner/simple_widgets.dart';
import 'package:weekplanner/data.dart';
import 'package:weekplanner/widgets/latest_events_pageview.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            Padding(
              padding: EdgeInsets.only(left: 18.0, bottom: 8),
              child: Text(AppLocalizations.of(context)!.latest, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),),
            ),
              const LatestEvents(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
              child: Divider(),
            ),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,

              ),
              children: [
                SimpleWidgets().categoryCard(AppLocalizations.of(context)!.must, const Color(0xFF673AB7)),
                SimpleWidgets().categoryCard(AppLocalizations.of(context)!.daily, const Color(0xFFFFC107)),
                SimpleWidgets().categoryCard(AppLocalizations.of(context)!.social, const Color(0xFFE53935)),
                SimpleWidgets().categoryCard(AppLocalizations.of(context)!.selfImprovement, const Color(0xFF42A1E9)),
              ],
            ),
            const SizedBox(height: 5),
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
                    child: SimpleWidgets().eventCard(event.subject, event.icon, event.color));
              },
            ),
          ],
                ),
        )
      ),
    );
  }
}

