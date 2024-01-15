import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/main.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:weekplanner/theme/theme.dart';

import '../theme/theme_provider.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  bool isPressed = false;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start the opacity animation after a delay
    Future.delayed(Duration(milliseconds: 1200), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Offset distance = isPressed ? Offset(10, 10) : Offset(28, 28);
    double blur = 20.0;

    return Scaffold(
      backgroundColor: themeProvider.themeData == darkTheme
          ? Color(0xFF2E3239)
          : Color(0xFFF3E7E7),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    "WELCOME TO THE\nSTRONG WEEK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: 'Montserrat',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 44.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/cain.svg',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'A simplistic week planner.',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.remove_red_eye_outlined,
                        color: Color(0xFFFFC107),
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                        'Overview your week and manage your time efficiently.',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.crop_free_rounded,
                        color: Color(0xFFE53935),
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                        'Be aware of your free time.',
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.not_interested_outlined,
                        color: Color(0xFF42A1E9),
                        size: 30,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                        "You don't need overwhelming features. \nNo micro-management, no reminders, no monthly view, no time picking more than half-hour accuracy.",
                        style:
                            TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 54.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Listener(
                        onPointerUp: (_) => setState(() {
                          isPressed = false;
                          themeProvider.toggleTheme();
                          //themeProvider.toggleThemeMode();
                        }),
                        onPointerDown: (_) => setState(() {
                          isPressed = true;
                        }),
                        child: AnimatedContainer(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: themeProvider.themeData == darkTheme
                                  ? Color(0xFF2E3239)
                                  : Color(0xFFF3E7E7),
                              boxShadow: [
                                BoxShadow(
                                  inset: isPressed,
                                  blurRadius: blur,
                                  offset: -distance,
                                  color: themeProvider.themeData == darkTheme
                                      ? Color(0xFF35393F)
                                      : Colors.white70,
                                ),
                                BoxShadow(
                                  inset: isPressed,
                                  blurRadius: blur,
                                  offset: distance,
                                  color: themeProvider.themeData == darkTheme
                                      ? Color(0xFF23262A)
                                      : Color(0xFFA7A9AF),
                                ),
                              ]),
                          duration: const Duration(milliseconds: 100),
                          child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Icon(
                              themeProvider.themeData == darkTheme
                                  ? Icons.dark_mode
                                  : Icons.light_mode,
                              color: colorScheme.primary,
                              size: 50,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 38,),
                Text(
                  "Change Theme",
                  style:
                  TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 20,
                      color: colorScheme.onBackground,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SplashScreen()));
          },
          child: const Text(
            "LET'S START",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 18),
          ),
        ),
      ),
    );
  }
}

/*
Container(
width: 500.0,
height: 500.0,
color: Color(0xff333333),
alignment: Alignment.center,
transformAlignment: Alignment.center,
child: Container(
color: Color(0xff333333),
child: Container(
width: 184,
height: 184,
child: Icon(
Icons.star,
size: 61,
color: Colors.amber,
),
decoration: BoxDecoration(
color: Color(0xff333333),
borderRadius: BorderRadius.circular(33),
gradient: LinearGradient(
begin: Alignment.topLeft,
end: Alignment.bottomRight,
colors: [
Color(0xff333333),
Color(0xff333333),
],
),
boxShadow: [
BoxShadow(
color: Color(0xff4a4a4a),
offset: Offset(-12.8, -12.8),
blurRadius: 19,
spreadRadius: 0.0,
),
BoxShadow(
color: Color(0xff1c1c1c),
offset: Offset(12.8, 12.8),
blurRadius: 19,
spreadRadius: 0.0,
),
],
),
),
),
)*/
