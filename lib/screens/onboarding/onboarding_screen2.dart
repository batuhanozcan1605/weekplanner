import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weekplanner/const.dart';
import 'package:weekplanner/main.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/screens/onboarding/onboarding_first_event.dart';

class OnBoardingScreen2 extends StatefulWidget {
  const OnBoardingScreen2({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen2> createState() => _OnBoardingScreen2State();
}

class _OnBoardingScreen2State extends State<OnBoardingScreen2> {
  double opacity = 0.0;
  bool workSelected = false;
  bool schoolSelected = false;
  bool isContinue = false;

  @override
  void initState() {
    super.initState();
    // Start the opacity animation after a delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
          child: isContinue == false
              ? Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: opacity,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 22,
                          ),
                          Text(
                            AppLocalizations.of(context)!.mustActivity,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorScheme.onBackground,
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 52,
                          ),
                          Text(
                            AppLocalizations.of(context)!.suchAs,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorScheme.primary,
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 52,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (workSelected) {
                                            schoolSelected = false;
                                            workSelected = false;
                                          } else {
                                            workSelected = true;
                                            schoolSelected = false;
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        height: height/(refPhoneHeight/140.0),
                                        width: height/(refPhoneHeight/140.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF673AB7),
                                            borderRadius:
                                                BorderRadius.circular(11.0),
                                            border: workSelected
                                                ? Border.all(
                                                    color: colorScheme.onBackground, // Color of the border
                                                    width:
                                                        2, // Width of the border
                                                  )
                                                : null,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.work,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.work,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (schoolSelected) {
                                            schoolSelected = false;
                                            workSelected = false;
                                          } else {
                                            workSelected = false;
                                            schoolSelected = true;
                                          }
                                        });
                                      },
                                      child: SizedBox(
                                        height: height/(refPhoneHeight/140.0),
                                        width: height/(refPhoneHeight/140.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xFF673AB7),
                                            borderRadius:
                                                BorderRadius.circular(11.0),
                                            border: schoolSelected
                                                ? Border.all(
                                                    color: colorScheme
                                                        .onBackground, // Color of the border
                                                    width:
                                                        2, // Width of the border
                                                  )
                                                : null,
                                          ),
                                          child: Center(
                                            child: Icon(
                                              Icons.school_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.school,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ],
                                ),
                              ]),
                          SizedBox(
                            height: 42,
                          ),
                          workSelected == false && schoolSelected == false
                              ? Center()
                              : ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isContinue = true;
                                    });
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.continuee,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 18,
                                        color: colorScheme.onBackground),
                                  ),
                                ),
                        ]),
                  ),
                )
              : FirstEvent(isSelectedEventWork: workSelected, context: context,),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SplashScreen()));
          },
          child: Text(
            "SKIP THIS STEP",
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18),
          ),
        ),
      ),
    );
  }
}
