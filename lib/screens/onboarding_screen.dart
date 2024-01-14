import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weekplanner/main.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      "WELCOME TO THE\nSTRONG WEEK",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xFFD0BBFF),
                          fontFamily: 'Montserrat',
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 64.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/cain.svg',
                        height: 30,
                        width: 30,
                      ),
                      const SizedBox(width: 20,),
                      const Text('A simplistic week planner.', style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye_outlined, color: Color(0xFFFFC107), size: 30,),
                      SizedBox(width: 20,),
                      Flexible(
                          child: Text('Overview your week and manage your time efficiently.',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),)
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(Icons.crop_free_rounded, color: Color(0xFFE53935), size: 30,),
                      SizedBox(width: 20,),
                      Flexible(
                          child: Text('Be aware of your free times.',
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),)
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      Icon(Icons.not_interested_outlined, color: Color(0xFF42A1E9), size: 30,),
                      SizedBox(width: 20,),
                      Flexible(
                          child: Text("You don't need overwhelming features. \nNo micro-management, no reminders, no monthly view, no time picking more than half-hour accuracy.",
                            style: TextStyle(fontFamily: 'Montserrat', fontSize: 16),)
                      ),
                    ],
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
