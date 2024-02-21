import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import 'package:weekplanner/database/DatabaseHelper2.dart';
import 'package:weekplanner/database/UniqueIdDao.dart';
import 'package:weekplanner/l10n/l10n.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/provider/settings_provider.dart';
import 'package:weekplanner/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/screens/onboarding_screen.dart';
import 'package:weekplanner/theme/theme_provider.dart';
import 'database/AppointmentDao.dart';
import 'model/MyAppointment.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  MobileAds.instance.initialize();
  final isDark = sharedPreferences.getBool('isDark') ?? true;
  final locale = sharedPreferences.getString('locale') ?? 'null';

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider(isDark)),
          ChangeNotifierProvider<AppointmentProvider>(create: (_) => AppointmentProvider()),
          ChangeNotifierProvider<SettingsProvider>(create: (_) => SettingsProvider(locale))
        ],
            child: const MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Week Planner App',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: L10n.all,
      locale: Provider.of<SettingsProvider>(context).appLocale,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const StartApp(),
    );
  }
}


class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkIfFirstTime(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show loading indicator or splash screen
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && snapshot.data!) {
          // Show onboarding screen
          return const OnBoardingScreen();
        } else {
          // Show main content
          return const SplashScreen();
        }
      },
    );
  }
}

Future<bool> checkIfFirstTime() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  return isFirstTime;
}

Future<void> setFirstTimeFalse() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isFirstTime', false);
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    setFirstTimeFalse();
  }

  Future<void> loadData(BuildContext context) async {

    try {

      await DatabaseHelper.database();
      await DatabaseHelper2.database();

      // Fetch data from the database

      List<MyAppointment> fetchedMyAppointments = await AppointmentDao().getAllAppointments();
      List<String> fetchedUniqueIds = await UniqueIdDao().getAllUniqueIds();
      AppointmentDao().deleteObsoleteData(fetchedMyAppointments);

      // ignore: use_build_context_synchronously
      final provider = Provider.of<AppointmentProvider>(context, listen: false);
      // Initialize your provider with the fetched data
      provider.initializeWithMyAppointments(fetchedMyAppointments);
      provider.initializeWithAppointments(fetchedAppointments(fetchedMyAppointments));
      provider.initializeIcons(fetchedIcons(fetchedMyAppointments));
      provider.initializeIsCompleted(fetchedIsCompleted(fetchedMyAppointments));
      provider.initializeUniqueIds(fetchedUniqueIds);

    } catch (error) {
      // Handle errors appropriately
      //print("ERROR: $error");
      // Navigate to an error screen or retry loading
    }

  }

  List<Appointment> fetchedAppointments(fetchedMyAppointments) {
    List<Appointment> appointments = [];

    for(int i = 0; i < fetchedMyAppointments.length; i++) {

      final appointment = Appointment(
          id: fetchedMyAppointments[i].id,
          startTime: fetchedMyAppointments[i].startTime,
          endTime: fetchedMyAppointments[i].endTime,
          recurrenceRule: fetchedMyAppointments[i].recurrenceRule,
          recurrenceExceptionDates: fetchedMyAppointments[i].recurrenceExceptionDates,
          subject: fetchedMyAppointments[i].subject,
          notes: fetchedMyAppointments[i].notes,
          color: fetchedMyAppointments[i].color
      );

      appointments.add(appointment);
    }

    return appointments;
  }

  Map<int, IconData> fetchedIcons(List<MyAppointment> fetchedAppointments) {
    Map<int, IconData> map = {};
    for(var i = 0; i < fetchedAppointments.length; i++) {
        map[fetchedAppointments[i].id!] = fetchedAppointments[i].icon!;
    }
    return map;
  }

  Map<int, int> fetchedIsCompleted(List<MyAppointment> fetchedAppointments) {
    Map<int, int> map = {};
    for(var i = 0; i < fetchedAppointments.length; i++) {
      map[fetchedAppointments[i].id!] = fetchedAppointments[i].isCompleted!;
    }
    return map;
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Data loading is complete, return your UI here
          return const MainScreen();
        } else {
          // Data is still loading, return a loading indicator
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
