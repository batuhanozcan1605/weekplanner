import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/ad_helper.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/screens/language_page.dart';
import 'package:weekplanner/screens/main_screen.dart';
import 'package:weekplanner/theme/theme.dart';
import '../theme/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: colorScheme.background,
          title: Text(
            'Settings',
            style: TextStyle(
                color: colorScheme.onBackground, fontFamily: 'Montserrat'),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(27),
          child: Column(
            children: [
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                tileColor: colorScheme.secondary,
                leading: Icon(
                  themeProvider.themeData == lightTheme
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: colorScheme.onBackground,
                ),
                title: Text(
                  'Tap to toggle theme',
                  style: TextStyle(
                      color: colorScheme.onBackground,
                      fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  themeProvider.toggleTheme();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                },
              ),
              SizedBox(height: 18),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                tileColor: colorScheme.secondary,
                leading: Icon(Icons.language),
                title: Text(
                  'Change Language',
                  style: TextStyle(
                      color: colorScheme.onBackground,
                      fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LanguagePage()));
                },
              ),
              SizedBox(height: 18),
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                tileColor: colorScheme.secondary,
                leading: Icon(Icons.delete_forever),
                title: Text(
                  'Delete All Events',
                  style: TextStyle(
                      color: colorScheme.onBackground,
                      fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('This will delete all events forever. \n Do you want to continue?', style: TextStyle(fontFamily: 'Montserrat', fontSize: 26),),
                        content: SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  provider.deleteAll();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()));
                                },
                                child: Text('Delete All'),
                              ),
                              SizedBox(height: 16,),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('No'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: _bannerAd == null
            ? Container()
            : SizedBox(
                height: 52,
                child: AdWidget(ad: _bannerAd!),
              ));
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
