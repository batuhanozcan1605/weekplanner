import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/database/DatabaseHelper.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'database/AppointmentDao.dart';
import 'model/MyAppointment.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the database
  //await DatabaseHelper.instance.database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppointmentProvider>(
          create: (_) => AppointmentProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Week Planner App',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
          primaryColor: Constants.primaryColor
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future<void> loadData() async {

    try {

      await DatabaseHelper.database();

      // Fetch data from the database

      List<MyAppointment> fetchedAppointments = await AppointmentDao().getAllAppointments();


      // Initialize your provider with the fetched data
      Provider.of<AppointmentProvider>(context, listen: false).initializeWithAppointments(fetchedAppointments);
      Provider.of<AppointmentProvider>(context, listen: false).initializeIcons(fetchedIcons(fetchedAppointments));
      Provider.of<AppointmentProvider>(context, listen: false).initializeIsCompleted(fetchedIsCompleted(fetchedAppointments));


    } catch (error) {
      // Handle errors appropriately
      print("ERROR: $error");
      // Navigate to an error screen or retry loading
    }

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
      future: loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Data loading is complete, return your UI here
          return MainScreen();
        } else {
          // Data is still loading, return a loading indicator
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
