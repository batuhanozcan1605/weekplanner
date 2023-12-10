import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekplanner/constants.dart';
import 'package:weekplanner/provider/event_provider.dart';
import 'package:weekplanner/utils.dart';
import '../model/event.dart';

class EventEditingPage extends StatefulWidget {
  const EventEditingPage({Key? key, this.event}) : super(key: key);

  final Event? event;

  @override
  State<EventEditingPage> createState() => _EventEditingPageState();
}

class _EventEditingPageState extends State<EventEditingPage> {
  //final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool isChecked = false;

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final event = widget.event!;

      titleController.text = event.title;
      fromDate = event.from;
      toDate = event.to;
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
              onPressed: saveForm,
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

            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: 115,
                decoration: BoxDecoration(
                  color: Constants.lightGrey,
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
                            child: buildTitle(),
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
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Segoe UI'),
                        )
                      ],
                    )
                    //Color circles
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
                height: 350,
                decoration: BoxDecoration(
                  color: const Color(0xff74736f),
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13.0),
                      child: Row(
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
                          myCheckBox()
                        ],
                      ),
                    )
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

    final event = Event(
        title: titleController.text,
        detail: detailController.text,
        icon: '',
        from: fromDate,
        to: toDate,
      isAllDay: false,
      isRepetitive: false,
    );

    final isEditing = widget.event != null;
    final provider = Provider.of<EventProvider>(context, listen: false);

    if(isEditing) {
      provider.editEvent(event, widget.event!);

      Navigator.pop(context);
    } else {
      provider.addEvent(event);
      Navigator.pop(context);
    }

  }

  Widget buildTitle() => TextFormField(
        style: TextStyle(
            color: Constants.softColor, fontSize: 20, fontFamily: 'Segoe UI'),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Title',),
        onFieldSubmitted: (_) => saveForm(),
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
      final timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(initialDate));

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
}


