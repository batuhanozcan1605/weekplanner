import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:weekplanner/model/entitlement.dart';
import 'package:weekplanner/simple_widgets.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/utils.dart';
import 'package:weekplanner/widgets/choose_event_widget.dart';
import 'package:weekplanner/widgets/color_listview_widget.dart';
import '../ad_helper.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../provider/revenuecat_provider.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage(
      {super.key,
      this.appointment,
      this.eventTemplate,
      this.iconFromEdit,
      this.isCompletedFromEdit,
      this.cellDate});

  final MyAppointment? appointment;
  final Events? eventTemplate;
  final IconData? iconFromEdit;
  final int? isCompletedFromEdit;
  final DateTime? cellDate;

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  final addEventKey = GlobalKey();
  final repeatEachWeek = GlobalKey();
  final dayPickerKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;
  bool showTutorial = true;

  void _initEventEditInAppTour() {
    tutorialCoachMark = TutorialCoachMark(
        targets: Utils().eventEditingTargets(
          addEventKey: addEventKey,
          dayPickerKey: dayPickerKey,
          repeatEachWeek: repeatEachWeek,
        ),
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
    bool tutorialShown = prefs.getBool('tutorialShownEventEdit') ?? false;
    //
    if (!tutorialShown && showTutorial) {
      _initEventEditInAppTour();
      _showInAppTour();
      prefs.setBool('tutorialShownEventEdit', true);
    }
  }

  final titleController = TextEditingController();
  final detailController = TextEditingController();
  late FixedExtentScrollController _scrollControllerHour;
  late FixedExtentScrollController _scrollControllerMinute;

  late DateTime fromDate;
  late DateTime toDate;
  Color backgroundColor = Colors.deepPurple;
  bool isChecked = false;
  bool isCheckedNextWeek = false;
  late bool isEditing;
  late bool isRecurrenceEnabled;
  bool daysThisWeek = true;
  IconData icon = Icons.square_rounded;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<bool> selectedNextWeekDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<DateTime> currentWeekDays = [];
  List<DateTime> nextWeekDays = [];
  List<DateTime> selectedDateObjects = [];
  Duration? selectedDuration = const Duration(hours: 2, minutes: 0);
  Events? selectedEvent;
  late DateTime firstDateOfRecurringEventStart;
  late DateTime firstDateOfRecurringEventEnd;
  bool showAds = false;

  @override
  void initState() {
    super.initState();

    if(showAds){
    _createBannerAd();
    _createInterstitialAd();
    }
    _checkTutorialStatus();

    widget.appointment != null ? isEditing = true : isEditing = false;



    if (widget.appointment == null) {
      isRecurrenceEnabled = false;
      DateTime fromDateWithExactMinute = widget.cellDate!;
      fromDate = Utils.roundOffMinute(fromDateWithExactMinute);
      toDate = fromDate.add(const Duration(hours: 2));
      currentWeekDays = _getWeekDays(DateTime.now());
      nextWeekDays = _getNextWeekDays(DateTime.now());
    } else {
      final event = widget.appointment!;

      titleController.text = event.subject;
      fromDate = event.startTime;
      toDate = event.endTime;

      Duration dif = toDate.difference(fromDate);
      int durationMinute = dif.inMinutes % 60;
      int durationHour = dif.inHours;

      selectedDuration = Duration(hours: durationHour, minutes: durationMinute);
      isRecurrenceEnabled =
          widget.appointment!.recurrenceRule == null ? false : true;
      backgroundColor = widget.appointment!.color;
      icon = widget.iconFromEdit!;
      currentWeekDays = _getWeekDays(DateTime.now());
      nextWeekDays = _getNextWeekDays(DateTime.now());

      final provider = Provider.of<AppointmentProvider>(context, listen: false);
      firstDateOfRecurringEventStart = provider
          .firstDateOfRecurringEventStart(event.id);
      firstDateOfRecurringEventEnd = provider
          .firstDateOfRecurringEventEnd(event.id);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    ColorScheme colorScheme = Theme.of(context).colorScheme;
    _scrollControllerHour =
        FixedExtentScrollController(initialItem: selectedDuration!.inHours);
    _scrollControllerMinute = FixedExtentScrollController(
        initialItem: selectedDuration!.inMinutes % 60);
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    //final showAds = entitlement == Entitlement.ads;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.cancel),
        ),
        actions: [
          IconButton(
              onPressed: () {
                if(showAds) {
                interstitialAdFrequency();
                }

                Future.delayed(const Duration(milliseconds: 1000));
                if (isRecurrenceEnabled) {
                  saveRecurringEvent();
                } else {
                  saveForm();
                }
              },
              icon: Icon(
                Icons.check,
                color: colorScheme.primary,
              ))
        ],
        title: Text(
          AppLocalizations.of(context)!.addPlan,
          style: TextStyle(
              color: colorScheme.onBackground, fontFamily: 'Montserrat'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 115,
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Row(children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  selectedEvent == null
                                      ? icon
                                      : selectedEvent!.icon,
                                  color: SimpleWidgets.softColor,
                                ),
                              ),
                              Expanded(child: buildTitle()),
                            ]),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                            ),
                            child: buildDetailInput(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Column(
                        key: addEventKey,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final chosenEvent = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const ChooseEvent()));

                              if (chosenEvent != null) {
                                setState(() {
                                  selectedEvent = chosenEvent;
                                  titleController.text = selectedEvent!.subject;
                                  backgroundColor = selectedEvent!.color;
                                  icon = selectedEvent!.icon as IconData;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: SimpleWidgets.softColor,
                            ),
                            iconSize: 30,
                          ),
                          Text(AppLocalizations.of(context)!.event,
                              style: const TextStyle(
                                  color: SimpleWidgets.softColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat')),
                        ],
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: 115,
                decoration: BoxDecoration(
                  color: colorScheme.secondary,
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Column(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.palette,
                              color: colorScheme.onBackground,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.color,
                            style: TextStyle(
                                color: colorScheme.onBackground,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28.0, vertical: 5),
                        child: ColorListView(
                            selectedColor: backgroundColor,
                            onColorSelected: (Color color) {
                              setState(() {
                                backgroundColor = color;
                              });
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 11),
            showAds
                ? SizedBox(
                    height: 50,
                    width: 320,
                    child: AdWidget(ad: _bannerAd!),
                  ) : Container(),
            Padding(
                padding: const EdgeInsets.only(top: 11.0),
                child: Container(
                  height: 469,
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(11.0),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.time,
                              style: TextStyle(
                                  color: colorScheme.onBackground,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ],
                        ),
                      ),
                      buildDateTimePicker(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ListTile(
                          key: repeatEachWeek,
                          title: Row(
                            children: [
                              Icon(
                                Icons.repeat,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                child: Text(
                                  AppLocalizations.of(context)!.repeat,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary),
                                ),
                              ),
                            ],
                          ),
                          trailing: Switch(
                            value: isRecurrenceEnabled,
                            onChanged: (value) {
                              setState(() {
                                isRecurrenceEnabled = value;
                              });
                            },
                          ),
                        ),
                      ),
                      isEditing
                          ? const SizedBox(
                              height: 15,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Divider(
                                color: colorScheme.primary,
                              ),
                            ),
                      if (isEditing)
                        const Center()
                      else
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 13.0, right: 13.0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  daysThisWeek = !daysThisWeek;
                                }),
                                child: Text(
                                  daysThisWeek
                                      ? AppLocalizations.of(context)!
                                          .dayPickerThis
                                      : AppLocalizations.of(context)!
                                          .dayPickerNext,
                                  style: TextStyle(
                                      color: colorScheme.onBackground,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      daysThisWeek = !daysThisWeek;
                                    });
                                  },
                                  icon: daysThisWeek
                                      ? const Icon(
                                          Icons.arrow_forward_ios_rounded)
                                      : const Icon(
                                          Icons.arrow_back_ios_new_rounded)),
                            ],
                          ),
                        ),
                      isEditing
                          ? const Center()
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              child: dayPicker(),
                            ),
                      isEditing
                          ? const Center()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [myCheckBox()]),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget myCheckBox() => Row(
        children: [
          Text(AppLocalizations.of(context)!.everyDay),
          daysThisWeek
              ? Checkbox(
                  activeColor: backgroundColor,
                  checkColor: SimpleWidgets.softColor,
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      if (daysThisWeek) {
                        isChecked = value!;
                        isChecked
                            ? selectedDays.fillRange(
                                0, selectedDays.length, true)
                            : selectedDays.fillRange(
                                0, selectedDays.length, false);
                        isChecked
                            ? selectedDateObjects = List.from(currentWeekDays)
                            : selectedDateObjects = [];
                      } else {
                        isChecked = value!;
                        isChecked
                            ? selectedNextWeekDays.fillRange(
                                0, selectedNextWeekDays.length, true)
                            : selectedNextWeekDays.fillRange(
                                0, selectedNextWeekDays.length, false);
                        isChecked
                            ? selectedDateObjects = List.from(nextWeekDays)
                            : selectedDateObjects = [];
                      }
                    });
                  },
                )
              : Checkbox(
                  activeColor: backgroundColor,
                  checkColor: SimpleWidgets.softColor,
                  value: isCheckedNextWeek,
                  onChanged: (value) {
                    setState(() {
                      isCheckedNextWeek = value!;
                      isCheckedNextWeek
                          ? selectedNextWeekDays.fillRange(
                              0, selectedNextWeekDays.length, true)
                          : selectedNextWeekDays.fillRange(
                              0, selectedNextWeekDays.length, false);
                      isCheckedNextWeek
                          ? selectedDateObjects = List.from(nextWeekDays)
                          : selectedDateObjects = [];
                    });
                  },
                ),
        ],
      );

  List<MyAppointment> selectedDaysEvents() {
    List<MyAppointment> createdAppointments = [];

    final provider = Provider.of<AppointmentProvider>(context, listen: false);
    int highestId = provider.getHighestId() + 1;
    for (int i = 0; i < selectedDateObjects.length; i++) {
      DateTime newFromDate = DateTime(
          selectedDateObjects[i].year,
          selectedDateObjects[i].month,
          selectedDateObjects[i].day,
          fromDate.hour,
          fromDate.minute);

      DateTime checkToDateIf00 = newFromDate.add(Duration(
          hours: selectedDuration!.inHours,
          minutes: selectedDuration!.inMinutes % 60));
      if (checkToDateIf00.hour == 0 && checkToDateIf00.minute == 0) {
        toDate = newFromDate
            .add(Duration(
                hours: selectedDuration!.inHours,
                minutes: selectedDuration!.inMinutes % 60))
            .subtract(const Duration(minutes: 1));
      } else {
        toDate = newFromDate.add(Duration(
            hours: selectedDuration!.inHours,
            minutes: selectedDuration!.inMinutes % 60));
      }

      final event = MyAppointment(
        id: highestId + i,
        subject: titleController.text,
        notes: detailController.text,
        startTime: newFromDate,
        endTime: toDate,
        icon: icon,
        color: backgroundColor,
        isCompleted: 0,
      );

      createdAppointments.add(event);
    }

    return createdAppointments;
  }

  Future saveForm() async {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    if (selectedDateObjects.isNotEmpty) {
      print("selected days events: ${selectedDaysEvents()}");
      provider.addSelectedDaysEvents(selectedDaysEvents(), icon);
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    DateTime checkToDateIf00 = fromDate.add(Duration(
        hours: selectedDuration!.inHours,
        minutes: selectedDuration!.inMinutes % 60));
    if (checkToDateIf00.hour == 0 && checkToDateIf00.minute == 0) {
      toDate = fromDate
          .add(Duration(
              hours: selectedDuration!.inHours,
              minutes: selectedDuration!.inMinutes % 60))
          .subtract(const Duration(minutes: 1));
    } else {
      toDate = fromDate.add(Duration(
          hours: selectedDuration!.inHours,
          minutes: selectedDuration!.inMinutes % 60));
    }

    final event = MyAppointment(
      id: provider.getHighestId() + 1,
      subject: titleController.text,
      notes: detailController.text,
      startTime: fromDate,
      endTime: toDate,
      icon: icon,
      color: backgroundColor,
      isCompleted: 0,
    );

    if (isEditing) {

        String uniqueId = Utils.getUniqueId(widget.appointment!.id.toString(), widget.appointment!.startTime);
        bool completedRecurringEvent = provider.uniqueIds.contains(uniqueId);
        print('completed $completedRecurringEvent uniqueId: $uniqueId');

      final editedEvent = MyAppointment(
        id: widget.appointment!.id,
        subject: titleController.text,
        notes: detailController.text,
        startTime: fromDate,
        endTime: toDate,
        icon: selectedEvent == null ? widget.iconFromEdit : icon,
        color: backgroundColor,
        isCompleted: completedRecurringEvent ? 1 : widget.isCompletedFromEdit,
      );

      print("editedEvent isCompleted: ${widget.appointment!.isCompleted}");

      if(completedRecurringEvent) provider.editCompletedEvent(widget.appointment!);
      provider.deleteUniqueIds(uniqueId);
      provider.editEvent(editedEvent, widget.appointment!);

      Navigator.pop(context);
      //Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      provider.addEvent(event, icon);
      Navigator.pop(context);
      //Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  Future saveRecurringEvent() async {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    String days = selectedDateObjects.isNotEmpty
        ? Utils.dayAbbreviationForMultipleDays(selectedDateObjects)
        : Utils.dayAbbreviation(fromDate);

    DateTime checkToDateIf00 = fromDate.add(Duration(
        hours: selectedDuration!.inHours,
        minutes: selectedDuration!.inMinutes % 60));
    if (checkToDateIf00.hour == 0 && checkToDateIf00.minute == 0) {
      toDate = fromDate
          .add(Duration(
              hours: selectedDuration!.inHours,
              minutes: selectedDuration!.inMinutes % 60))
          .subtract(const Duration(minutes: 1));
    } else {
      toDate = fromDate.add(Duration(
          hours: selectedDuration!.inHours,
          minutes: selectedDuration!.inMinutes % 60));
    }

    final event = MyAppointment(
      id: provider.getHighestId() + 1,
      subject: titleController.text,
      notes: detailController.text,
      startTime: fromDate,
      endTime: toDate,
      color: backgroundColor,
      icon: icon,
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=$days',
      isCompleted: 0,
    );

    final isEditing = widget.appointment != null;

    if (isEditing) {
      final wasRecurred = widget.appointment!.recurrenceRule != null;
      DateTime editedRecurredStartTime = DateTime(
          firstDateOfRecurringEventStart.year, firstDateOfRecurringEventStart.month,  firstDateOfRecurringEventStart.day,
        fromDate.hour, fromDate.minute
      );

      DateTime editedRecurredEndTime = DateTime(firstDateOfRecurringEventEnd.year, firstDateOfRecurringEventEnd.month, firstDateOfRecurringEventEnd.day,
        toDate.hour, toDate.minute
      );

      final editedEvent = MyAppointment(
        id: widget.appointment!.id,
        subject: titleController.text,
        notes: detailController.text,
        startTime: editedRecurredStartTime,
        endTime: editedRecurredEndTime,
        icon: selectedEvent == null ? widget.iconFromEdit : icon,
        color: backgroundColor,
        recurrenceRule: wasRecurred
            ? widget.appointment!.recurrenceRule
            : 'FREQ=WEEKLY;BYDAY=$days',
        recurrenceExceptionDates: widget.appointment!.recurrenceExceptionDates,
        isCompleted: widget.isCompletedFromEdit,
      );

      if(widget.appointment!.isCompleted == 1) {
        provider.editCompletedEvent(widget.appointment!);
        String uniqueId = Utils.getUniqueId(widget.appointment!.id.toString(), widget.appointment!.startTime);
        provider.addUniqueId(uniqueId);
      }
      provider.editEvent(editedEvent, widget.appointment!);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      provider.addEvent(event, icon);
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  Widget buildTitle() => TextFormField(
        autofocus: false,
        style: const TextStyle(
            color: SimpleWidgets.softColor,
            fontSize: 20,
            fontFamily: 'Segoe UI'),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)!.hintText,
          hintStyle: TextStyle(color: SimpleWidgets.softColor.withOpacity(0.6)),
        ),
        onFieldSubmitted: (_) {},
        //validator: (title) => title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: titleController,
      );

  Widget buildDetailInput() => TextFormField(
        maxLines: 2,
        style: const TextStyle(
            color: SimpleWidgets.softColor,
            fontSize: 14,
            fontFamily: 'Segoe UI'),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.details,
            hintStyle: const TextStyle(color: SimpleWidgets.softColor)),
        onFieldSubmitted: (_) {},
        controller: detailController,
      );

  Widget buildDateTimePicker() => Builder(
        builder: (BuildContext context) {
          ColorScheme colorScheme = Theme.of(context).colorScheme;
          return Column(
            children: [
              buildFrom(colorScheme),
              buildDuration(colorScheme),
              //buildTo(),
            ],
          );
        },
      );

  Widget buildDuration(colorScheme) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: GestureDetector(
          onTap: () async {
            Duration? duration = await showDialog<Duration>(
                context: context,
                builder: (BuildContext context) {
                  var screenSize = MediaQuery.of(context).size;
                  final width = screenSize.width;
                  final height = screenSize.height;
                  int selectedHour = selectedDuration!.inHours;
                  int selectedMinute = selectedDuration!.inMinutes % 60;
                  return AlertDialog(
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'CANCEL',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Montserrat'),
                            )),
                        TextButton(
                            onPressed: () => Navigator.pop(
                                context,
                                Duration(
                                    hours: selectedHour,
                                    minutes: selectedMinute)),
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'Montserrat'),
                            )),
                      ],
                      //title: Text('Select Duration'),
                      content: SizedBox(
                        width: (width / 412) * 400,
                        height: (height/915) * 450,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    AppLocalizations.of(context)!.hoursCapital,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat'),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .minutesCapital,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Montserrat')))),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 10,
                              child: Row(
                                children: [
                                  //hours wheel
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                        controller: _scrollControllerHour,
                                        onSelectedItemChanged: (value) {
                                          selectedHour = value;
                                        },
                                        itemExtent: 50,
                                        overAndUnderCenterOpacity: 0.5,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                                childCount: 25,
                                                builder: (BuildContext context,
                                                    int index) {
                                                  return SimpleWidgets()
                                                      .hourTile(index);
                                                })),
                                  ),
                                  //minutes wheel
                                  Expanded(
                                    child: ListWheelScrollView.useDelegate(
                                        controller: _scrollControllerMinute,
                                        onSelectedItemChanged: (value) {
                                          selectedMinute = value * 30;
                                        },
                                        itemExtent: 50,
                                        overAndUnderCenterOpacity: 0.5,
                                        perspective: 0.005,
                                        diameterRatio: 1.2,
                                        physics:
                                            const FixedExtentScrollPhysics(),
                                        childDelegate:
                                            ListWheelChildBuilderDelegate(
                                                childCount: 2,
                                                builder: (BuildContext context,
                                                    int index) {
                                                  int minutes = index * 30;
                                                  return SimpleWidgets()
                                                      .minuteTile(minutes);
                                                })),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ));
                });
            if (duration == null) return;
            setState(() {
              selectedDuration = duration;
            });
          },
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Icon(
                  Icons.timelapse_rounded,
                  color: colorScheme.primary,
                ),
              ),
              Text(
                AppLocalizations.of(context)!.duration,
                style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: durationDropdown(colorScheme),
              ),
            ],
          ),
        ),
      );

  Widget durationDropdown(colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Flexible(
          flex: 1,
          child: Text(
            '${selectedDuration!.inHours} ${AppLocalizations.of(context)!.hours}',
            style: TextStyle(
                color: colorScheme.onBackground,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 8),
        Flexible(
          flex: 1,
          child: Text(
              '${(selectedDuration!.inMinutes % 60).toString()} ${AppLocalizations.of(context)!.minutes}',
              style: TextStyle(
                  color: colorScheme.onBackground,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget buildFrom(colorScheme) => Builder(
    builder: (context) {
      return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: colorScheme.primary),
                    onPressed: () {
                      if(isEditing) {
                        if(widget.appointment!.recurrenceRule != null){
                          return;
                        }
                      }
                      setState(() {
                        selectedDateObjects = [];
                        selectedDays.fillRange(
                            0, selectedNextWeekDays.length, false);
                        selectedNextWeekDays.fillRange(
                            0, selectedNextWeekDays.length, false);
                        isChecked = false;
                        isCheckedNextWeek = false;
                      });
                      pickFromDateTime(pickDate: true);
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: selectedDateObjects.isNotEmpty
                      ? const Center(child: Text("-"))
                      : buildDropdownField(
                          text: Utils.toDate(fromDate, context),
                          onClicked: () {
                            if(isEditing) {
                              if(widget.appointment!.recurrenceRule != null){
                                return;
                              }
                            }
                            pickFromDateTime(pickDate: true);
                          }),
                ),
                Expanded(
                    flex: 2,
                    child: buildDropdownField(
                        text: Utils.toTime(fromDate),
                        onClicked: () => pickFromDateTime(pickDate: false))),
              ],
            ),
          );
    }
  );

  Widget buildTo() => Padding(
        padding: const EdgeInsets.only(left: 14.0),
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.arrow_back,
                color: SimpleWidgets.themePurple,
              ),
            ),
            Expanded(
              flex: 3,
              child: buildDropdownField(
                  text: Utils.toDate(toDate, context),
                  onClicked: () => pickToDateTime(pickDate: true)),
            ),
            Expanded(
                flex: 2,
                child: buildDropdownField(
                    text: Utils.toTime(toDate),
                    onClicked: () => pickToDateTime(pickDate: false))),
          ],
        ),
      );

  Future pickFromDateTime({required bool pickDate, Locale? locale}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate, locale: locale);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    if (date.isBefore(fromDate)) {
      setState(() {
        toDate = fromDate;
      });
      return;
    }
    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
        Locale? locale
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
          locale: locale,
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2021, 8),
          lastDate: DateTime(2101));
      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
        initialEntryMode: TimePickerEntryMode.input
      );

      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      Builder(builder: (context) {
        ColorScheme colorScheme = Theme.of(context).colorScheme;
        return ListTile(
          title: Text(
            text,
            style: TextStyle(
                color: colorScheme.onBackground, fontWeight: FontWeight.bold),
          ),
          onTap: onClicked,
        );
      });

  Widget dayPicker() => Builder(builder: (context) {
        var screenSize = MediaQuery.of(context).size;
        final width = screenSize.width;
        double tileWidth = width / 10.3;
        return SizedBox(
            key: dayPickerKey,
            height: 60,
            child: daysThisWeek
                ? ListView(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(7, (index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedDays[index] = !selectedDays[index];
                            selectedDays[index]
                                ? selectedDateObjects
                                    .add(currentWeekDays[index])
                                : selectedDateObjects
                                    .remove(currentWeekDays[index]);
                            selectedDateObjects.length == 7
                                ? isChecked = true
                                : isChecked = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            height: 60,
                            width: tileWidth,
                            decoration: BoxDecoration(
                              color: selectedDays[index]
                                  ? backgroundColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getDayAbbreviation(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${currentWeekDays[index].day}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                : ListView(
                    shrinkWrap: true,
                    //physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: List.generate(7, (index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedNextWeekDays[index] =
                                !selectedNextWeekDays[index];
                            selectedNextWeekDays[index]
                                ? selectedDateObjects.add(nextWeekDays[index])
                                : selectedDateObjects
                                    .remove(nextWeekDays[index]);
                            selectedDateObjects.length == 7
                                ? isChecked = true
                                : isChecked = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            height: 40,
                            width: tileWidth,
                            decoration: BoxDecoration(
                              color: selectedNextWeekDays[index]
                                  ? backgroundColor
                                  : Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _getDayAbbreviation(index),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${nextWeekDays[index].day}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  )
        );
      });

  String _getDayAbbreviation(int index) {
    final daysOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return daysOfWeek[index];
  }

  List<DateTime> _getWeekDays(DateTime currentDate) {
// Find the first day of the current week (assuming Monday is the start of the week)
    DateTime firstDayOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    List<DateTime> weekDays =
        List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return weekDays;
  }

  List<DateTime> _getNextWeekDays(DateTime currentDate) {
// Find the first day of the current week (assuming Monday is the start of the week)
    DateTime firstDayOfNextWeek = currentDate
        .add(const Duration(days: 7))
        .subtract(Duration(days: currentDate.weekday - 1));
    List<DateTime> weekDays = List.generate(
        7, (index) => firstDayOfNextWeek.add(Duration(days: index)));

    return weekDays;
  }

  //ADD METHODS

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: AdHelper.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (LoadAdError error) => _interstitialAd = null,
        ));
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createInterstitialAd();
      }, onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createInterstitialAd();
      });
      _interstitialAd!.show();

      _interstitialAd = null;
    }
  }

  Future<void> interstitialAdFrequency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int showedAdCount = prefs.getInt('showedAdCount') ?? 0;

    showedAdCount++;

    if (showedAdCount % 5 == 0) {
      _showInterstitialAd();
    }

    prefs.setInt('showedAdCount', showedAdCount);
  }
}
