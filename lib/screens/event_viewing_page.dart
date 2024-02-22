import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/screens/main_screen.dart';
import 'package:weekplanner/simple_widgets.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/utils.dart';
import '../ad_helper.dart';
import '../model/MyAppointment.dart';
import '../model/entitlement.dart';
import '../provider/appointment_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../provider/revenuecat_provider.dart';

class EventViewingPage extends StatefulWidget {
  const EventViewingPage({super.key, required this.appointment});

  final MyAppointment appointment;

  @override
  State<EventViewingPage> createState() => _EventViewingPageState();
}

class _EventViewingPageState extends State<EventViewingPage> {
  BannerAd? _bannerAd;

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    final icons = Provider.of<AppointmentProvider>(context).icons;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    final showAds = entitlement == Entitlement.ads;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        title: Text(
          widget.appointment.subject,
          style: const TextStyle(
              fontFamily: 'Segoe UI',
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => EventEditingPage(
                      appointment: widget.appointment,
                      iconFromEdit: icons[widget.appointment.id])));
            },
            icon: const Icon(Icons.edit),
            color: colorScheme.onBackground,
          ),
          IconButton(
            onPressed: () async {
              final provider =
                  Provider.of<AppointmentProvider>(context, listen: false);
              if (widget.appointment.recurrenceRule != null) {
                await showDeleteDialog(
                    context, provider, icons[widget.appointment.id]);
              } else {
                provider.deleteEvent(widget.appointment);
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.delete),
            color: colorScheme.onBackground,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(38.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      AppLocalizations.of(context)!.from,
                      style: TextStyle(color: colorScheme.primary),
                    )),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(Utils.toDate(widget.appointment.startTime, context)),
                      Text(Utils.toTime(widget.appointment.startTime)),
                    ],
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 1,
                      child: Text(AppLocalizations.of(context)!.to,
                          style: TextStyle(color: colorScheme.primary))),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Utils.toDate(widget.appointment.endTime, context)),
                        Text(Utils.toTime(widget.appointment.endTime)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            widget.appointment.recurrenceRule != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.repeat,
                        color: colorScheme.primary,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Recurring Event'),
                    ],
                  )
                : const Center(),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Divider(
                color: SimpleWidgets.themePurple,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18.0),
              child: widget.appointment.notes == null
                  ? const Text("")
                  : Text(
                      widget.appointment.notes!,
                      style: TextStyle(color: colorScheme.onBackground),
                    ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: showAds
                    ? SizedBox(
                        height: 50,
                        width: 320,
                        child: AdWidget(ad: _bannerAd!),
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<DateTime>? setException() {
    print("null mı ${widget.appointment.recurrenceExceptionDates}");
    if (widget.appointment.recurrenceExceptionDates == null) {
      final exceptionDate = <DateTime>[];
      exceptionDate.add(DateTime(
          widget.appointment.startTime.year,
          widget.appointment.startTime.month,
          widget.appointment.startTime.day));
      print('exceptionDates1: $exceptionDate');
      return exceptionDate;
    } else {
      List<DateTime>? exceptionDate =
          List.from(widget.appointment.recurrenceExceptionDates!);
      print('exceptionDates2: $exceptionDate');
      exceptionDate.add(DateTime(
          widget.appointment.startTime.year,
          widget.appointment.startTime.month,
          widget.appointment.startTime.day));
      return exceptionDate;
    }
  }

  Future<void> showDeleteDialog(BuildContext context, provider, icon) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  DateTime firstDateOfRecurringEventStart = provider
                      .firstDateOfRecurringEventStart(widget.appointment.id);
                  DateTime firstDateOfRecurringEventEnd = provider
                      .firstDateOfRecurringEventEnd(widget.appointment.id);
                  final editedEvent = MyAppointment(
                    id: widget.appointment.id,
                    subject: widget.appointment.subject,
                    notes: widget.appointment.notes!,
                    startTime:
                        firstDateOfRecurringEventStart, //sorun burda gibi
                    endTime: firstDateOfRecurringEventEnd,
                    icon: icon,
                    color: widget.appointment.color,
                    recurrenceRule: widget.appointment.recurrenceRule,
                    recurrenceExceptionDates: setException(),
                  );
                  print('editedEvent $editedEvent');
                  provider.editEvent(editedEvent, widget.appointment);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
                child: Text('Only delete from this day'),
              ),
              ElevatedButton(
                onPressed: () {
                  provider.deleteEvent(widget.appointment);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
                child: Text('Delete this recurring event completely'),
              ),
            ],
          ),
        );
      },
    );
  }
}
