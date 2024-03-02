import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/main.dart';
import '../../model/MyAppointment.dart';
import '../../provider/appointment_provider.dart';
import '../../simple_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../utils.dart';

class FirstEvent extends StatefulWidget {
  const FirstEvent({Key? key, required this.isSelectedEventWork, this.context})
      : super(key: key);

  final bool isSelectedEventWork;
  final context;

  @override
  State<FirstEvent> createState() => _FirstEventState();
}

class _FirstEventState extends State<FirstEvent> {
  late String title;
  late IconData icon;
  List<DateTime> selectedDateObjects = [];
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  late List<DateTime> currentWeekDays;
  bool isChecked = false;
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now().add(Duration(hours: 2));
  bool isRecurrenceEnabled = true;
  Duration? selectedDuration = const Duration(hours: 2, minutes: 0);
  late FixedExtentScrollController _scrollControllerHour;
  late FixedExtentScrollController _scrollControllerMinute;

  List<DateTime> _getWeekDays(DateTime currentDate) {
// Find the first day of the current week (assuming Monday is the start of the week)
    DateTime firstDayOfWeek =
    currentDate.subtract(Duration(days: currentDate.weekday - 1));
    List<DateTime> weekDays =
    List.generate(7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return weekDays;
  }


  @override
  void initState() {
    title = widget.isSelectedEventWork ? AppLocalizations.of(widget.context)!.work : AppLocalizations.of(widget.context)!.school;
    icon = widget.isSelectedEventWork ? Icons.work : Icons.school;
    currentWeekDays = _getWeekDays(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;
    final height = screenSize.height;

    _scrollControllerHour =
        FixedExtentScrollController(initialItem: selectedDuration!.inHours);
    _scrollControllerMinute = FixedExtentScrollController(
        initialItem: selectedDuration!.inMinutes % 60);
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
        padding: const EdgeInsets.only(top: 60, left: 27, right: 27),
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Container(
              height: 75,
              decoration: BoxDecoration(
                color: Color(0xFF673AB7).withOpacity(0.7),
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(
                      icon,
                      color: SimpleWidgets.softColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                          color: SimpleWidgets.softColor,
                          fontSize: 20,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                ]),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
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
                  SizedBox(
                    height: 18,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ListTile(
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
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Divider(
                      color: colorScheme.primary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child: Text(AppLocalizations.of(context)!.multipleDaysForThisEvent, textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize:  height < 700 ? 14 : 16),),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: dayPicker(),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 14,),
          ElevatedButton(onPressed: (){

            if (isRecurrenceEnabled) {
              saveRecurringEvent();
            } else {
              saveForm();
            }

            }, child: Text(
            "CONTINUE TO CALENDAR",
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: height < 700 ? 14 : 18,
                color: colorScheme.onBackground),
          ),
          )
        ])
    );
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
      subject: title,
      notes: '',
      startTime: fromDate,
      endTime: toDate,
      color: Color(0xFF673AB7),
      icon: icon,
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=$days',
      isCompleted: 0,
    );

    provider.addEvent(event, icon);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

  Future saveForm() async {
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    if (selectedDateObjects.isNotEmpty) {
      print("selected days events: ${selectedDaysEvents()}");
      provider.addSelectedDaysEvents(selectedDaysEvents(), icon);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()));
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
      subject: title,
      notes: '',
      startTime: fromDate,
      endTime: toDate,
      icon: icon,
      color: Color(0xFF673AB7),
      isCompleted: 0,
    );

    provider.addEvent(event, icon);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()));
  }

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
        subject: title,
        notes: '',
        startTime: newFromDate,
        endTime: toDate,
        icon: icon,
        color: Color(0xFF673AB7),
        isCompleted: 0,
      );

      createdAppointments.add(event);
    }

    return createdAppointments;
  }

  Widget dayPicker() => Builder(builder: (context) {

    String _getDayAbbreviation(int index) {
      final daysOfWeek = [AppLocalizations.of(context)!.monday, AppLocalizations.of(context)!.tuesday, AppLocalizations.of(context)!.wednesday,
        AppLocalizations.of(context)!.thursday, AppLocalizations.of(context)!.friday, AppLocalizations.of(context)!.saturday, AppLocalizations.of(context)!.sunday];
      return daysOfWeek[index];
    }
        var screenSize = MediaQuery.of(context).size;
        final width = screenSize.width;

        double tileWidth = width / 10.3;
        return SizedBox(
            height: 60,
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(7, (index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedDays[index] = !selectedDays[index];
                      selectedDays[index]
                          ? selectedDateObjects.add(currentWeekDays[index])
                          : selectedDateObjects.remove(currentWeekDays[index]);
                      selectedDateObjects.length == 7
                          ? isChecked = true
                          : isChecked = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      height: 60.0,
                      width: tileWidth,
                      decoration: BoxDecoration(
                        color: selectedDays[index]
                            ? Color(0xFF673AB7).withOpacity(0.7)
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                       child: Text(
                         _getDayAbbreviation(index),
                         style: const TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                      ),
                    ),
                  ),
                );
              }),
            )
        );
      });

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

  Widget buildFrom(colorScheme) => Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward, color: colorScheme.primary),
                  onPressed: () {
                    setState(() {
                      selectedDateObjects = [];
                      selectedDays.fillRange(0, selectedDays.length, false);
                      isChecked = false;
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
                        onClicked: () => pickFromDateTime(pickDate: true)),
              ),
              Expanded(
                  flex: 2,
                  child: buildDropdownField(
                      text: Utils.toTime(fromDate),
                      onClicked: () => pickFromDateTime(pickDate: false))),
            ],
          ),
        );
      });

  Future pickFromDateTime({required bool pickDate, Locale? locale}) async {
    final date =
        await pickDateTime(fromDate, pickDate: pickDate, locale: locale);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, date.hour, date.minute);
    }

    setState(() {
      fromDate = date;
    });
  }

  Future<DateTime?> pickDateTime(DateTime initialDate,
      {required bool pickDate, DateTime? firstDate, Locale? locale}) async {
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
          initialEntryMode: TimePickerEntryMode.input);

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
                        height: (height / 915) * 450,
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
}
