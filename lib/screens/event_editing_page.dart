import 'package:flutter/material.dart';
import 'package:weekplanner/constants.dart';
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

  @override
  void initState() {
    super.initState();

    if (widget.event == null) {
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
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
              onPressed: () => (),
              icon: Icon(
                Icons.check,
                color: Constants.primaryColor,
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
              padding: const EdgeInsets.only(top: 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Constants.lightGrey,
                  borderRadius: BorderRadius.circular(11.0),
                  border:
                      Border.all(width: 1.0, color: const Color(0xff707070)),
                ),
                height: 66,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13.0),
              child: Text(
                "Or go custom",
                style: TextStyle(
                    color: Constants.softColor,
                    fontSize: 18,
                    fontFamily: 'Segoe UI'),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: buildTitle(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18.0,
                      ),
                      child: buildDetailInput(),
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
                            fontSize: 22,
                            fontFamily: 'Segoe UI')
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
                height: 256,
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
                              fontSize: 22,
                              fontFamily: 'Segoe UI'),),
                            ],
                      ),
                    ),
                    buildDateTimePicker(),
                  ],
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget buildTitle() => TextFormField(
        style: TextStyle(
            color: Constants.softColor, fontSize: 22, fontFamily: 'Segoe UI'),
        decoration:
            InputDecoration(border: InputBorder.none, hintText: 'Title'),
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
          //buildTo(),
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
                      color: const Color(0xffbfb528),
                      borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Text('From', style: TextStyle(
                        color: Constants.softColor,
                        fontSize: 14,
                        fontFamily: 'Segoe UI'),),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 2,
              child: buildDropdownField(
                  text: Utils.toDate(fromDate), onClicked: () {}),
            ),
            Expanded(
              flex: 2,
                child: buildDropdownField(
                    text: Utils.toTime(fromDate), onClicked: () {})),
          ],
        ),
  );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      ListTile(
        title: Text(text),
        onTap: onClicked,
      );
}
