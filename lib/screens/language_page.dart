import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/provider/locale_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
              Provider.of<LocaleProvider>(context, listen: false)
                  .changeLocale(Locale('en'));
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
              Provider.of<LocaleProvider>(context, listen: false)
                  .changeLocale(Locale('es'));
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
              Provider.of<LocaleProvider>(context, listen: false)
                  .changeLocale(Locale('tr'));
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
              Provider.of<LocaleProvider>(context, listen: false)
                  .changeLocale(Locale('zh'));
            },
          ),
        ]),
      ),
    );
  }
}
