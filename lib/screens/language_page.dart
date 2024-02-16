import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/provider/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weekplanner/screens/main_screen.dart';

class LanguagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text(
          AppLocalizations.of(context)!.languages,
          style: TextStyle(
              color: colorScheme.onBackground, fontFamily: 'Montserrat'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(27.0),
        child: ListView(children: <Widget>[
          ListTile(
            tileColor: colorScheme.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            title: Text(
              'English',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'en');
            },
          ),
          ListTile(
            tileColor: colorScheme.secondary,
            title: Text(
              'Espanol',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'es');
            },
          ),
          ListTile(
            tileColor: colorScheme.secondary,
            title: Text(
              'Português',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'pt');
            },
          ),
          ListTile(
            tileColor: colorScheme.secondary,
            title: Text(
              'Русский',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'ru');
            },
          ),
          ListTile(
            tileColor: colorScheme.secondary,
            title: Text(
              'Türkçe',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'tr');
            },
          ),
          ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
              ),
            tileColor: colorScheme.secondary,
            title: Text(
              '中国人',
              style: TextStyle(
                  color: colorScheme.onBackground, fontFamily: 'Montserrat'),
            ),
            onTap: () {
              _changeLocale(context, 'zh');
            },  
          ),
        ]),
      ),
    );
  }

  void _changeLocale(context, String localeCode) {
    Provider.of<SettingsProvider>(context, listen: false)
        .changeLocale(localeCode);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
  }

}
