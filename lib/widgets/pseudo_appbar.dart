import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/purchase_api.dart';
import 'package:weekplanner/screens/settings_page.dart';
import 'package:weekplanner/widgets/paywall_widget.dart';
import '../model/entitlement.dart';
import '../provider/revenuecat_provider.dart';
import '../utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PseudoAppBar extends StatelessWidget {
  const PseudoAppBar({super.key, this.globalKey});
  // ignore: prefer_typing_uninitialized_variables
  final globalKey;


  Future fetchOffers(context, emoji) async {
    final offerings = await PurchaseApi.fetchOffers();
    if(offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No plans found')));
    }else{
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      Utils.showSheet(
        context,
          (context) => PaywallWidget(
            packages: packages,
            title: '$emoji  ' + AppLocalizations.of(context)!.removeAds,
            description: AppLocalizations.of(context)!.description,
            onClickedPackage: (package) async {
              await PurchaseApi.purchasePackage(package);

              Navigator.pop(context);

            },
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    final star = EmojiParser().get('star').code;
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    //final showAds = entitlement == Entitlement.ads;
    bool showAds = false;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
            onPressed: () async {
              print('show ads $showAds');
              if(showAds) {
                await fetchOffers(context, star);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are already using the app without ads.')));
              }
          }, icon: Icon(Icons.workspace_premium_rounded, color: showAds ? colorScheme.onBackground : colorScheme.background,)),
        Consumer<AppointmentProvider>(
          builder: (BuildContext context, AppointmentProvider value, Widget? child) {
            return Row(
              key: globalKey,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () => provider.showScheduleView(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.view_timeline, color: value.scheduleView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 5,),
                      Text('TO DO', style: TextStyle(color: value.scheduleView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => provider.showWeekView(),
                  child: Column(
                    children: [
                      Icon(Icons.view_week_rounded, color: value.weekView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 5,),
                      Text('WEEKS', style: TextStyle(color: value.weekView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: () => provider.showDayView(),
                  child: Column(
                    children: [
                      Icon(Icons.view_day, color: value.dayView == true ? colorScheme.primary : colorScheme.onBackground),
                      const SizedBox(height: 5,),
                      Text('DAYS', style: TextStyle(color: value.dayView == true ? colorScheme.primary : colorScheme.onBackground, fontFamily: 'Montserrat'),),
                    ],
                  ),
                ),
              ],
            );
          },
        ),

        IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const SettingsPage()));
             },
            icon: Icon(Icons.settings)),
        /*IconButton(
          onPressed: () {
            themeProvider.toggleTheme();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const MainScreen()));
          },
          icon: Icon(themeProvider.themeData == lightTheme ? Icons.light_mode : Icons.dark_mode, color: colorScheme.onBackground,),),*/
        //const MenuButton(),
      ],
    );
  }
}
