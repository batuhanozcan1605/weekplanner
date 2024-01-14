import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/theme/theme.dart';
import '../screens/main_screen.dart';
import '../theme/theme_provider.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        showPopover(
            context: context,
            bodyBuilder: (context) => menuItems(themeProvider, context, colorScheme),
          width: 250,
          height: 50
        );
      },
      child: const Icon(Icons.more_vert),
    );
  }

  Widget menuItems(themeProvider, context, colorScheme) => Column(
        children: [
          GestureDetector(
            onTap: (){
              themeProvider.toggleThemeMode();
              themeProvider.toggleTheme();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MainScreen()));

            },
            child: Container(
              height: 50,
              color: colorScheme.background,
              child: Row(
                children: [
                  const SizedBox(width: 8,),
                  Icon(themeProvider.themeData == lightTheme ? Icons.light_mode : Icons.dark_mode, color: colorScheme.onBackground,),
                  const SizedBox(width: 8,),
                  Text(themeProvider.themeData == lightTheme ?  "Light Mode" : "Dark Mode" ,
                    style: TextStyle(color: colorScheme.onBackground, fontFamily: 'Montserrat'),),
                ],
              ),
            ),
          ),
        ],
      );
}
