import 'dart:ui';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/provider/appointment_provider.dart';
import 'package:weekplanner/utils.dart';
import 'package:weekplanner/widgets/choose_event_widget.dart';
import 'package:weekplanner/widgets/color_listview_widget.dart';
import '../model/Events.dart';
import '../model/MyAppointment.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key, this.appointment, this.eventTemplate, this.iconFromEdit}) : super(key: key);

  final MyAppointment? appointment;
  final Events? eventTemplate;
  final IconData? iconFromEdit;


  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  //final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  Color backgroundColor = Colors.deepPurple;
  bool isChecked = false;
  late bool isEditing;
  late bool isRecurrenceEnabled;
  IconData icon = Icons.square_rounded;
  List<bool> selectedDays = [false, false, false, false, false, false, false];
  List<DateTime> currentWeekDays = [];
  List<DateTime> selectedDateObjects = [];
  Duration? selectedDurationHour = Duration(hours: 2);
  int selectedDurationMinute = 0;


  @override
  void initState() {
    super.initState();
    widget.appointment != null ? isEditing = true : isEditing = false;
    if(widget.eventTemplate != null) {
      final eventTemplate = widget.eventTemplate!;

      titleController.text = eventTemplate.subject;
      DateTime fromDateWithExactMinute = DateTime.now();
      fromDate = Utils.roundOffMinute(fromDateWithExactMinute);
      toDate = fromDate.add(Duration(hours: 2));
      isRecurrenceEnabled = false;
      backgroundColor = widget.eventTemplate!.color;
      icon = widget.eventTemplate!.icon;
      currentWeekDays = _getWeekDays(DateTime.now());
    }

    if (widget.appointment == null) {
      isRecurrenceEnabled = false;
      DateTime fromDateWithExactMinute = DateTime.now();
      fromDate = Utils.roundOffMinute(fromDateWithExactMinute);
      toDate = fromDate.add(Duration(hours: 2));
      currentWeekDays = _getWeekDays(DateTime.now());
    } else {
      final event = widget.appointment!;

      titleController.text = event.subject;
      fromDate = event.startTime;
      toDate = event.endTime;
      isRecurrenceEnabled = widget.appointment!.recurrenceRule == null ? false : true;
      backgroundColor = widget.appointment!.color;
      icon = widget.iconFromEdit!;
      currentWeekDays = _getWeekDays(DateTime.now());
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Constants.softColor,
        ),
        actions: [
          IconButton(
              onPressed: (){
                if(isRecurrenceEnabled) {
                  saveWeeklyEvent();
                }else{
                  saveForm();
                }
              },
              icon: Icon(
                Icons.check,
                color: Constants.themePurple,
              ))
        ],
        title: Text(
          "ADD PLAN",
          style: TextStyle(color: Constants.softColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(27),
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(icon, color: Constants.softColor,),
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
                  Expanded(
                    flex: 2,
                      child: Column(
                        children: [
                          IconButton(
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChooseEvent()));
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
                  color: Color(0XFF383838),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(Icons.palette, color: Constants.softColor,),
                        ),
                        Text('Color', style: TextStyle(
                            color: Constants.softColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Segoe UI'),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 38.0, vertical: 5),
                      child: ColorListView(
                        selectedColor: backgroundColor,
                          onColorSelected: (Color color){
                            setState(() {
                              backgroundColor = color;
                            });
                          }),
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
                  color: Color(0xFF383838),
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
                              color: Constants.softColor,
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
                        title: Text('Repeat Each Week'),
                        trailing: Switch(
                          value: isRecurrenceEnabled,
                          onChanged: (value) {
                            setState(() {
                              print(value);
                              isRecurrenceEnabled = value;
                            });
                          },
                        ),
                      ),
                    ),
                    isEditing ? const Center() : Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Divider(color: Constants.themePurple,),
                    ),
                    isEditing ? const Center() : Padding(
                      padding: const EdgeInsets.only(left: 13.0, right: 13.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Days", style: TextStyle(
                              color: Constants.softColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Segoe UI'),),
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
      Text('Everyday'),
      Checkbox(
        activeColor: Colors.deepPurple,
        checkColor: Constants.softColor,
        value: isChecked,
        onChanged: (value) {
          setState(() {
            isChecked = value!;
            isChecked ? selectedDays.fillRange(0, selectedDays.length, true) : selectedDays.fillRange(0, selectedDays.length, false);
            isChecked ? selectedDateObjects = List.from(currentWeekDays) : selectedDateObjects = [];

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
      );
      provider.editEvent(editedEvent, widget.appointment!);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      provider.addEvent(event, icon);
      Navigator.popUntil(context, (route) => route.isFirst);
    }

  }



  Future saveWeeklyEvent() async {
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
    );

    final isEditing = widget.appointment != null;

    if(isEditing) {
      final editedEvent = MyAppointment(
        id: widget.appointment!.id,
        subject: titleController.text,
        notes: detailController.text,
        startTime: fromDate,
        endTime: toDate,
        icon: icon,
        color: backgroundColor,
      );
      provider.editEvent(editedEvent, widget.appointment!);

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      provider.addEvent(event, icon);
      Navigator.popUntil(context, (route) => route.isFirst);
    }

  }



  Widget buildTitle() => TextFormField(
        style: TextStyle(
            color: Constants.softColor, fontSize: 20, fontFamily: 'Segoe UI'),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Title', hintStyle: TextStyle(color: Constants.softColor)),
        onFieldSubmitted: (_) {},
        //validator: (title) => title != null && title.isEmpty ? 'Title can not be empty' : null,
        controller: titleController,
      );

  Widget buildDetailInput() => TextFormField(
        style: TextStyle(
            color: Constants.softColor, fontSize: 14, fontFamily: 'Segoe UI'),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Details'),
        onFieldSubmitted: (_) {},
        controller: detailController,
      );

  Widget buildDateTimePicker() => Column(
        children: [
          buildFrom(),
          buildDuration(),
          //buildTo(),
        ],
      );

  Widget buildDuration() => Padding(padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Icon(Icons.timelapse_rounded, color: Constants.themePurple,),
        ),
        Text('Duration', style: TextStyle(color: Constants.themePurple, fontWeight: FontWeight.bold, fontSize: 16),),
        const SizedBox(width: 15,),
        Expanded(
          child: durationDropdown(),
        ),
      ],
    ),
  );

  /////////////////////////////////////////////////////////////////

  Widget durationDropdown() {
    return Row(
      children: [
        TextButton(
            onPressed: () async {
              Duration? durationHour = await showDurationPicker(
                  context: context,
                  initialTime: Duration(hours: 1),
                  baseUnit: BaseUnit.hour
              );
              if(durationHour == null) return;
              setState(() {
                selectedDurationHour = durationHour;
              });
            },
            child: Text('${selectedDurationHour!.inHours} hours',
              style: TextStyle(color: Constants.softColor, fontSize: 16),)),
        //SizedBox(width: 8),
        TextButton(
            onPressed: () async {
              await showMinutePickerDialog(context);
            },
            child: Text('${selectedDurationMinute.toString()} minutes',
                style: TextStyle(color: Constants.softColor, fontSize: 16))),
      ],
    );
  }

  Future<void> showMinutePickerDialog(BuildContext context) async {
    int? result = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Center(child: Text('Pick Minutes')),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context, 0),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Center(child: Text('0',
                    style: TextStyle(color: Constants.softColor, fontSize: 30, fontFamily: 'Segoe UI'),)),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pop(context, 30),
                child: Container(
                  child: Center(child: Text('30',
                    style: TextStyle(color: Constants.softColor, fontSize: 30, fontFamily: 'Segoe UI'),)),
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


  Widget buildFrom() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4.0),
    child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Icon(Icons.arrow_forward, color: Constants.themePurple,),
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
  }) =>
      ListTile(
        title: Text(text),
        onTap: onClicked,
      );

  Widget dayPicker() => SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(7, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedDays[index] = !selectedDays[index];
                selectedDays[index] ? selectedDateObjects.add(currentWeekDays[index]) : selectedDateObjects.remove(currentWeekDays[index]);
                selectedDateObjects.length == 7 ? isChecked = true  : isChecked = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: selectedDays[index] ? Colors.deepPurple : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    _getDayAbbreviation(index),
                    style: TextStyle(
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
}

