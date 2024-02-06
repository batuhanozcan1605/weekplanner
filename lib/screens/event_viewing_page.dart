import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/simple_widgets.dart';
import 'package:weekplanner/screens/event_editing_page.dart';
import 'package:weekplanner/utils.dart';
import '../ad_helper.dart';
import '../model/MyAppointment.dart';
import '../provider/appointment_provider.dart';

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
              onPressed: () {
                final provider =
                    Provider.of<AppointmentProvider>(context, listen: false);
                provider.deleteEvent(widget.appointment);
                Navigator.pop(context);
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
                        'FROM',
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
                        child: Text('TO',
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
                  child: _bannerAd == null
                      ? Container()
                      : SizedBox(
                          height: 250,
                          width: 300,
                          child: AdWidget(ad: _bannerAd!),
                        ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
