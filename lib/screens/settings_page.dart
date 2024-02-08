import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/ad_helper.dart';
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
