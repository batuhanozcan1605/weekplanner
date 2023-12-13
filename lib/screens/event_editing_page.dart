import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:interval_time_picker/interval_time_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/provider/event_provider.dart';
import 'package:weekplanner/utils.dart';
import 'package:weekplanner/widgets/color_listview_widget.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key, this.appointment}) : super(key: key);

  final Appointment? appointment;

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
  late bool isRecurrenceEnabled;
  List<bool> selectedDays = [false, false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();

    if (widget.appointment == null) {
      isRecurrenceEnabled = false;
      DateTime fromDateWithExactMinute = DateTime.now();
      fromDate = Utils.roundOffMinute(fromDateWithExactMinute);
      toDate = fromDate.add(Duration(hours: 2));
    } else {
      final event = widget.appointment!;

      titleController.text = event.subject;
      fromDate = event.startTime;
      toDate = event.endTime;
      isRecurrenceEnabled = widget.appointment!.recurrenceRule == null ? false : true;
      backgroundColor = widget.appointment!.color;
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
                                  child: Icon(Icons.square_rounded, color: Constants.softColor,),
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
                              onPressed: (){},
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
                  color: Constants.lightGrey,
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
                height: 73,
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
                  color: const Color(0xff74736f),
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
                      padding: const EdgeInsets.all(14.0),
                      child: Divider(color: Constants.themePurple,),
                    ),
                    Padding(
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: dayPicker(),
                    ),
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
          });
        },
      ),
    ],
  );

  Future saveForm() async {

    final event = Appointment(
      subject: titleController.text,
      notes: detailController.text,
      startTime: fromDate,
      endTime: toDate,
      color: backgroundColor,
    );

    final isEditing = widget.appointment != null;
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    if(isEditing) {
      provider.editEvent(event, widget.appointment!);

      Navigator.pop(context);
    } else {
      provider.addEvent(event, Icons.square_rounded);
      Navigator.pop(context);
    }

  }

  Future saveWeeklyEvent() async {
    String days = Utils.dayAbbreviation(fromDate);

    final event = Appointment(
      subject: titleController.text,
      notes: detailController.text,
      startTime: fromDate,
      endTime: toDate,
      color: backgroundColor,
      recurrenceRule: 'FREQ=WEEKLY;BYDAY=$days',
    );

    final isEditing = widget.appointment != null;
    final provider = Provider.of<AppointmentProvider>(context, listen: false);

    if(isEditing) {
      provider.editEvent(event, widget.appointment!);

      Navigator.pop(context);
    } else {
      provider.addEvent(event, Icons.square_rounded);
      Navigator.pop(context);
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
          buildTo(),
        ],
      );

  Widget buildFrom() => Padding(
    padding: const EdgeInsets.only(left: 14.0),
    child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: Constants.themePurple,
                      borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: buildDropdownField(
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
          child: Row(
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  border: Border.all(width: 1.0, color: Constants.themePurple,),
                ),
              )
            ],
          ),
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

}

