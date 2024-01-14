import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/utils.dart';
import 'package:weekplanner/widgets/choose_event_widget.dart';
import 'package:weekplanner/widgets/color_listview_widget.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({super.key, this.appointment, this.eventTemplate, this.iconFromEdit, this.cellDate});

  final MyAppointment? appointment;
  final Events? eventTemplate;
  final IconData? iconFromEdit;
  final DateTime? cellDate;


  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {

  final titleController = TextEditingController();
  final detailController = TextEditingController();

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
  List<bool> selectedNextWeekDays = [false, false, false, false, false, false, false];
  List<DateTime> currentWeekDays = [];
  List<DateTime> nextWeekDays = [];
  List<DateTime> selectedDateObjects = [];
  Duration? selectedDurationHour = const Duration(hours: 2);
  int selectedDurationMinute = 0;
  Events? selectedEvent;

  @override
  void initState() {
    super.initState();

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
      Duration durationHour = event.endTime.hour - event.startTime.hour < 0 ? Duration(hours: 24 + (event.endTime.hour - event.startTime.hour)) : Duration(hours: event.endTime.hour - event.startTime.hour);
      selectedDurationHour = durationHour;
      int durationMinute = (event.startTime.minute - event.endTime.minute).abs();
      selectedDurationMinute = durationMinute;
      isRecurrenceEnabled = widget.appointment!.recurrenceRule == null ? false : true;
      backgroundColor = widget.appointment!.color;
      icon = widget.iconFromEdit!;
      currentWeekDays = _getWeekDays(DateTime.now());
      nextWeekDays = _getNextWeekDays(DateTime.now());
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            }, icon: const Icon(Icons.cancel),),
        actions: [
          IconButton(
              onPressed: (){

                if(isRecurrenceEnabled) {
                  saveRecurringEvent();
                }else{
                  saveForm();
                }
              },
              icon: Icon(
                Icons.check,
                color: colorScheme.primary,
              ))
        ],
        title: Text(
          "ADD PLAN",
          style: TextStyle(color: colorScheme.onBackground),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(27),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(selectedEvent == null ? icon : selectedEvent!.icon, color: Constants.softColor,),
                                  ),
                                  Expanded(child: buildTitle()),
                                ]
                            ),
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
                        children: [
                          IconButton(
                              onPressed: () async  {
                                  final chosenEvent = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const ChooseEvent()));

                                 setState(() {
                                   selectedEvent = chosenEvent;
                                   titleController.text = selectedEvent!.subject;
                                   backgroundColor = selectedEvent!.color;
                                   icon = selectedEvent!.icon as IconData;
                                 });
                              },
                              icon: Icon( Icons.add_circle, color: Constants.softColor,),
                            iconSize: 30,
                          ),
                          Text("Event",
                              style: TextStyle(color: Constants.softColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI')),
                        ],
                      )
                  ),
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
                            child: Icon(Icons.palette, color: colorScheme.onBackground,),
                          ),
                          Text('Color', style: TextStyle(
                              color: colorScheme.onBackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI'),
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 5),
                        child: ColorListView(
                          selectedColor: backgroundColor,
                            onColorSelected: (Color color){
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
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Center(
                  child: Text(
                    'AD BANNER',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 13,
                      color: Color(0xffa79020),
                    ),
                    textAlign: TextAlign.center,
                    softWrap: false,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 11.0),
              child: Container(
                height: 390,
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
                              Text('Time', style: TextStyle(
                              color: colorScheme.onBackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI'),),
                            ],
                      ),
                    ),
                    buildDateTimePicker(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ListTile(
                        title: Text('Repeat Each Week', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary),),
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
                    isEditing ? const Center() : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Divider(color: colorScheme.primary,),
                    ),
                    isEditing ? const Center() : Padding(
                      padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(daysThisWeek ? "Days - This Week" : "Days - Next Week", style: TextStyle(
                              color: colorScheme.onBackground,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI'),
                          ),
                         IconButton(
                             onPressed: () {
                               setState(() {
                                 daysThisWeek = !daysThisWeek;
                               });
                             },
                             icon: daysThisWeek ? const Icon(Icons.arrow_forward_ios_rounded) : const Icon(Icons.arrow_back_ios_new_rounded)),
                        myCheckBox(),
                        ],
                      ),
                    ),
                    isEditing ? const Center()  :  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: dayPicker(),
                    ),

                  ],
                ),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget myCheckBox() => Row(
    children: [
      const Text('Everyday'),
      daysThisWeek ? Checkbox(
        activeColor: Colors.deepPurple,
        checkColor: Constants.softColor,
        value: isChecked,
        onChanged: (value) {
          setState(() {
            if(daysThisWeek) {
              isChecked = value!;
              isChecked
                  ? selectedDays.fillRange(0, selectedDays.length, true)
                  : selectedDays.fillRange(0, selectedDays.length, false);
              isChecked
                  ? selectedDateObjects = List.from(currentWeekDays)
                  : selectedDateObjects = [];
            }else{
              isChecked = value!;
              isChecked
                  ? selectedNextWeekDays.fillRange(0, selectedNextWeekDays.length, true)
                  : selectedNextWeekDays.fillRange(0, selectedNextWeekDays.length, false);
              isChecked
                  ? selectedDateObjects = List.from(nextWeekDays)
                  : selectedDateObjects = [];
            }
          });
        },
      ) : Checkbox(
        activeColor: Colors.deepPurple,
        checkColor: Constants.softColor,
        value: isCheckedNextWeek,
        onChanged: (value) {
          setState(() {

            isCheckedNextWeek = value!;
            isCheckedNextWeek
                ? selectedNextWeekDays.fillRange(0, selectedNextWeekDays.length, true)
                : selectedNextWeekDays.fillRange(0, selectedNextWeekDays.length, false);
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
    for(int i = 0; i < selectedDateObjects.length; i++) {
      DateTime newFromDate = DateTime(fromDate.year, fromDate.month, selectedDateObjects[i].day, fromDate.hour, fromDate.minute);
        toDate = newFromDate.add(Duration(hours: selectedDurationHour!.inHours, minutes: selectedDurationMinute));

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

    if(selectedDateObjects.isNotEmpty) {
      provider.addSelectedDaysEvents(selectedDaysEvents(), icon);
      Navigator.popUntil(context, (route) => route.isFirst);
      return;
    }

    toDate = fromDate.add(Duration(hours: selectedDurationHour!.inHours, minutes: selectedDurationMinute));
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

    if(isEditing) {
      final editedEvent = MyAppointment(
        id: widget.appointment!.id,
        subject: titleController.text,
        notes: detailController.text,
        startTime: fromDate,
        endTime: toDate,
        icon: icon,
        color: backgroundColor,
        isCompleted: 0,
      );
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


    String days = selectedDateObjects.isNotEmpty ? Utils.dayAbbreviationForMultipleDays(selectedDateObjects) : Utils.dayAbbreviation(fromDate);


    toDate = fromDate.add(Duration(hours: selectedDurationHour!.inHours, minutes: selectedDurationMinute));
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

    if(isEditing) {
      final wasRecurred = widget.appointment!.recurrenceRule != null;
      final editedEvent = MyAppointment(
        id: widget.appointment!.id,
        subject: titleController.text,
        notes: detailController.text,
        startTime: fromDate,
        endTime: toDate,
        icon: icon,
        color: backgroundColor,
        recurrenceRule: wasRecurred ? widget.appointment!.recurrenceRule : 'FREQ=WEEKLY;BYDAY=$days',
        isCompleted: 0,
      );
      provider.editEvent(editedEvent, widget.appointment!);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      provider.addEvent(event, icon);
      Navigator.popUntil(context, (route) => route.isFirst);
    }

  }

  Widget buildTitle() => TextFormField(
    autofocus: false,
        style: TextStyle(
            color: Constants.softColor, fontSize: 20, fontFamily: 'Segoe UI'),
        decoration:
            InputDecoration(
            border: InputBorder.none, hintText: 'Enter a title or add one', hintStyle: TextStyle(color: Constants.softColor.withOpacity(0.6)),),
        onFieldSubmitted: (_) {},
        //validator: (title) => title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: titleController,
      );

  Widget buildDetailInput() => TextFormField(
      maxLines: 2,
          style: TextStyle(
              color: Constants.softColor, fontSize: 14, fontFamily: 'Segoe UI'),
          decoration:
              InputDecoration(border: InputBorder.none, hintText: 'Details', hintStyle: TextStyle(color: Constants.softColor)),
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
        );},
  );

  Widget buildDuration(colorScheme) => Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: GestureDetector(
      onTap: ()async {
        Duration? durationHour = await showDurationPicker(
            context: context,
            initialTime: selectedDurationHour!,
            baseUnit: BaseUnit.hour
        );
        if(durationHour == null) return;
        setState(() {
          selectedDurationHour = durationHour;
        });
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Icon(Icons.timelapse_rounded, color: colorScheme.primary,),
          ),
          Text('Duration', style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold, fontSize: 16),),
          const SizedBox(width: 15,),
          Expanded(
            child: durationDropdown(colorScheme),
          ),
        ],
      ),
    ),
  );

  Widget durationDropdown(colorScheme) {
    return Row(
      children: [
        TextButton(
            onPressed: () async {
              Duration? durationHour = await showDurationPicker(
                  context: context,
                  initialTime: selectedDurationHour!,
                  baseUnit: BaseUnit.hour
              );
              if(durationHour == null) return;
              setState(() {
                selectedDurationHour = durationHour;
              });
            },
            child: Text('${selectedDurationHour!.inHours} hours',
              style: TextStyle(color: colorScheme.onBackground, fontSize: 16),)),
        //SizedBox(width: 8),
        TextButton(
            onPressed: () async {
              await showMinutePickerDialog(context);
            },
            child: Text('${selectedDurationMinute.toString()} minutes',
                style: TextStyle(color: colorScheme.onBackground, fontSize: 16))),
      ],
    );
  }

  Future<void> showMinutePickerDialog(BuildContext context) async {
    int? result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Center(child: Text('Pick Minutes')),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, 0),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(child: Text('0',
                    style: TextStyle(color: Constants.softColor, fontSize: 30, fontFamily: 'Segoe UI'),)),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context, 30),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Center(
                      child: Text('30',
                    style: TextStyle(color: Constants.softColor, fontSize: 30, fontFamily: 'Segoe UI'),)
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectedDurationMinute = result;
      });
    }
  }


  Widget buildFrom(colorScheme) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Row(
          children: [
            Expanded(
              flex: 1,
              child: IconButton(icon: Icon(Icons.arrow_forward, color: colorScheme.primary),
                onPressed: () {
                setState(() {
                  selectedDateObjects = [];
                  selectedDays.fillRange(0, selectedNextWeekDays.length, false);
                  selectedNextWeekDays.fillRange(0, selectedNextWeekDays.length, false);
                  isChecked = false;
                  isCheckedNextWeek = false;
                });
                pickFromDateTime(pickDate: true);
                },),
            ),

            Expanded(
              flex: 3,
              child: selectedDateObjects.isNotEmpty ? const Center(child: Text("-")) : buildDropdownField(
                  text: Utils.toDate(fromDate), onClicked: () => pickFromDateTime(pickDate: true)),
            ),
            Expanded(
              flex: 2,
                child: buildDropdownField(
                    text: Utils.toTime(fromDate), onClicked: () => pickFromDateTime(pickDate: false))
            ),
          ],
        ),
  );

  Widget buildTo() => Padding(
    padding: const EdgeInsets.only(left: 14.0),
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: Icon(Icons.arrow_back, color: Constants.themePurple,),
        ),

        Expanded(
          flex: 3,
          child: buildDropdownField(
              text: Utils.toDate(toDate), onClicked: () => pickToDateTime(pickDate: true)),
        ),
        Expanded(
            flex: 2,
            child: buildDropdownField(
                text: Utils.toTime(toDate), onClicked: () => pickToDateTime(pickDate: false))
        ),
      ],
    ),
  );

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if(date == null) return;

    if(date.isAfter(toDate)) {
        toDate = DateTime(date.year, date.month, date.day, date.hour, date.minute);
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
    if(date == null) return;

    if(date.isBefore(fromDate)) {
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
}) async {
    if (pickDate) {
      final date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate ?? DateTime(2021, 8),
          lastDate: DateTime(2101));
      if(date==null) return null;
      final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
      return date.add(time);
    } else {
      final timeOfDay = await showIntervalTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate),
          interval: 30,
          visibleStep: VisibleStep.thirtieths,
      );

      if(timeOfDay == null) return null;

      final date = DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }

  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) => Builder(
    builder: (context) {
      ColorScheme colorScheme = Theme.of(context).colorScheme;
      return ListTile(
              title: Text(text, style: TextStyle(color: colorScheme.onBackground),),
              onTap: onClicked,
            );
    }
  );


  Widget dayPicker() => Builder(
    builder: (context) {
      var screenSize = MediaQuery.of(context).size;
      final width = screenSize.width;
      double tileWidth = width/10.3 ;
      return SizedBox(
          height: 60,
          child: daysThisWeek ? ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(7, (index) {

              return InkWell(
                onTap: () {
                  setState(() {
                      selectedDays[index] = !selectedDays[index];
                      selectedDays[index] ? selectedDateObjects.add(
                          currentWeekDays[index]) : selectedDateObjects.remove(
                          currentWeekDays[index]);
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
                      color: selectedDays[index] ? Colors.deepPurple : Colors.grey,
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
          ): ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(7, (index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedNextWeekDays[index] = !selectedNextWeekDays[index];
                    selectedNextWeekDays[index] ? selectedDateObjects.add(
                        nextWeekDays[index]) : selectedDateObjects.remove(
                        nextWeekDays[index]);
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
                      color: selectedNextWeekDays[index] ? Colors.deepPurple : Colors.grey,
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
    }
  );

  String _getDayAbbreviation(int index) {
    final daysOfWeek = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
    return daysOfWeek[index];
  }

  List<DateTime> _getWeekDays(DateTime currentDate) {
// Find the first day of the current week (assuming Monday is the start of the week)
    DateTime firstDayOfWeek = currentDate.subtract(
        Duration(days: currentDate.weekday-1));
    List<DateTime> weekDays = List.generate(
        7, (index) => firstDayOfWeek.add(Duration(days: index)));

    return weekDays;
  }

  List<DateTime> _getNextWeekDays(DateTime currentDate) {
// Find the first day of the current week (assuming Monday is the start of the week)
    DateTime firstDayOfNextWeek = currentDate.add(const Duration(days: 7)).subtract(
        Duration(days: currentDate.weekday-1));
    List<DateTime> weekDays = List.generate(
        7, (index) => firstDayOfNextWeek.add(Duration(days: index)));

    return weekDays;
  }
}

