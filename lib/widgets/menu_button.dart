import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import '../screens/main_screen.dart';
import '../theme/theme_provider.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showPopover(
            context: context,
            bodyBuilder: (context) => menuItems(themeProvider, context, colorScheme, provider),
          width: 250,
          height: 50
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }

  Widget menuItems(themeProvider, context, colorScheme, provider) => Column(
        children: [
          GestureDetector(
            onTap: (){
              themeProvider.toggleThemeMode();
              themeProvider.toggleTheme();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainScreen()));

            },
            child: Container(
              height: 50,
              color: colorScheme.background,
              child: Row(
                children: [
                  const SizedBox(width: 8,),
                  Icon(Icons.light_mode, color: colorScheme.onBackground,),
                  const SizedBox(width: 8,),
                  Text("Light Mode", style: TextStyle(color: colorScheme.onBackground),),
                ],
              ),
            ),
          ),
        ],
      );
}
