import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import '../theme/theme_provider.dart';
import 'menu_button.dart';

class PseudoAppBar extends StatelessWidget {
  const PseudoAppBar({super.key});

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.pie_chart, color: colorScheme.background,),
        Consumer<AppointmentProvider>(
          builder: (BuildContext context, AppointmentProvider value, Widget? child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => provider.showScheduleView(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_timeline, color: value.scheduleView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 10,),
                      Text('TO DO', style: TextStyle(color: value.scheduleView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => provider.showWeekView(),
                  child: Column(
                    children: [
                      Icon(Icons.view_week_rounded, color: value.weekView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 10,),
                      Text('WEEKS', style: TextStyle(color: value.weekView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => provider.showDayView(),
                  child: Column(
                    children: [
                      Icon(Icons.view_day, color: value.dayView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 10,),
                      Text('DAYS', style: TextStyle(color: value.dayView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        MenuButton(),
      ],
    );
  }
}
