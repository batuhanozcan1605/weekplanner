import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:weekplanner/ad_helper.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/utils.dart';
import 'package:weekplanner/widgets/pseudo_appbar.dart';
import 'package:weekplanner/widgets/schedule_view.dart';
import 'package:weekplanner/widgets/week_view.dart';
import '../model/entitlement.dart';
import '../provider/revenuecat_provider.dart';
import '../widgets/daily_view.dart';
import 'event_editing_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BannerAd? _bannerAd;

  final viewNavigator = GlobalKey();
  final fabKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  bool showTutorial = true;

  void _initMainScreenInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: Utils()
            .mainScreenTargets(viewNavigator: viewNavigator, fabKey: fabKey),
        skipWidget: const Card(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'SKIP TUTORIAL',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        colorShadow: Colors.grey,
        paddingFocus: 10,
        hideSkip: false,
        opacityShadow: 0.8,
        onFinish: () {
          print("Completed");
          setState(() {
            showTutorial =
                false; // Tutorial tamamlandıktan sonra gösterme bayrağını kapat
          });
        });
  }

  void _showInAppTour() {
    Future.delayed(const Duration(seconds: 1), () {
      tutorialCoachMark.show(context: context);
    });
  }

  void _checkTutorialStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool tutorialShown = prefs.getBool('tutorialShownMainScreen') ?? false;
    //
    if (!tutorialShown && showTutorial) {
      _initMainScreenInAppTour();
      _showInAppTour();
      prefs.setBool('tutorialShownMainScreen', true);
    }
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    _checkTutorialStatus();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    //final showAds = entitlement == Entitlement.ads;
    bool showAds = false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: PseudoAppBar(
                globalKey: viewNavigator,
              ),
            ),
            Expanded(child: Consumer<AppointmentProvider>(builder:
                (BuildContext context, AppointmentProvider value,
                    Widget? child) {
              return AnimatedSwitcher(
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
                child: value.weekView
                    ? const WeekView()
                    : AnimatedSwitcher(
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        duration: const Duration(milliseconds: 500),
                        child: value.scheduleView == false
                            ? const DailyView()
                            : const ScheduleView()),
              );
            })),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: fabKey,
        backgroundColor: colorScheme.primary,
        onPressed: () async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final String? selectedDateTimeString =
              prefs.getString('selectedDateTime');
          if (selectedDateTimeString != null) {
            final DateTime cellDate = DateTime.parse(selectedDateTimeString);
            // ignore: use_build_context_synchronously
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return EventEditingPage(
                    cellDate: cellDate,
                  );
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
      bottomNavigationBar: showAds
          ? SizedBox(
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
    );
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }
}
