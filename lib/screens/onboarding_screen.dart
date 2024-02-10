import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/main.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:weekplanner/theme/theme.dart';
import '../theme/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    Future.delayed(const Duration(milliseconds: 1200), () {
      setState(() {
        opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;
    double refPhoneHeight = 915.0;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(28, 28);
    double blur = 20.0;

    return Scaffold(
      backgroundColor: themeProvider.themeData == darkTheme
          ? const Color(0xFF2E3239)
          : const Color(0xFFF3E7E7),
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
                  padding: EdgeInsets.only(top: height/(refPhoneHeight/30.0)),
                  child: Text(
                    "WELCOME TO THE\nSTRONG WEEK",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: colorScheme.primary,
                        fontFamily: 'Montserrat',
                        fontSize: height/(refPhoneHeight/20),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height/(refPhoneHeight/44)),
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
                      Text(
                        AppLocalizations.of(context)!.onboarding1,
                        style:
                            const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height/(refPhoneHeight/24)),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye_outlined,
                        color: Color(0xFFFFC107),
                        size: 30,
                      ),
                      SizedBox(
                        width: height/(refPhoneHeight/20),
                      ),
                      Flexible(
                          child: Text(
                              AppLocalizations.of(context)!.onboarding2,
                        style:
                            const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.crop_free_rounded,
                        color: Color(0xFFE53935),
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                              AppLocalizations.of(context)!.onboarding3,
                        style:
                            const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.not_interested_outlined,
                        color: Color(0xFF42A1E9),
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.onboarding4,
                        style:
                            const TextStyle(fontFamily: 'Montserrat', fontSize: 16),
                      )),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height/(refPhoneHeight/54)),
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
                                  ? const Color(0xFF2E3239)
                                  : const Color(0xFFF3E7E7),
                              boxShadow: [
                                BoxShadow(
                                  inset: isPressed,
                                  blurRadius: blur,
                                  offset: -distance,
                                  color: themeProvider.themeData == darkTheme
                                      ? const Color(0xFF35393F)
                                      : Colors.white70,
                                ),
                                BoxShadow(
                                  inset: isPressed,
                                  blurRadius: blur,
                                  offset: distance,
                                  color: themeProvider.themeData == darkTheme
                                      ? const Color(0xFF23262A)
                                      : const Color(0xFFA7A9AF),
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
                SizedBox(height: height/(refPhoneHeight/38),),
                Text(
                  AppLocalizations.of(context)!.theme,
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
          child: Text(
            AppLocalizations.of(context)!.letsStart,
            style: const TextStyle(fontFamily: 'Montserrat', fontSize: 18),
          ),
        ),
      ),
    );
  }
}
