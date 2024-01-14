import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/theme/theme_provider.dart';
import 'package:weekplanner/widgets/menu_button.dart';
import 'package:weekplanner/widgets/pseudo_appbar.dart';
import 'package:weekplanner/widgets/schedule_view.dart';
import 'package:weekplanner/widgets/week_view.dart';
import '../widgets/daily_view.dart';
import 'event_editing_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: PseudoAppBar(),
            ),
            Expanded(
                child: Consumer<AppointmentProvider>(
                  builder: (BuildContext context, AppointmentProvider value, Widget? child) {
                  return AnimatedSwitcher(
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    duration: const Duration(milliseconds: 500),
                    child: value.weekView ? const WeekView() : AnimatedSwitcher(
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                        child: value.scheduleView == false ? const DailyView() : const ScheduleView()),
                    );
                  }
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
       backgroundColor: colorScheme.primary,
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? selectedDateTimeString = prefs.getString('selectedDateTime');
          if(selectedDateTimeString != null) {
            final DateTime cellDate = DateTime.parse(selectedDateTimeString);
          // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return EventEditingPage(cellDate: cellDate,);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(
                    CurveTween(curve: curve),
                  );

                  var offsetAnimation = animation.drive(tween);

                  return ScaleTransition(
                    scale: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          }
        },
        heroTag: 'fabHero',
        child: Icon(Icons.add, color: colorScheme.background),
      ),
    );
  }


}

