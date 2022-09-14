import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/slots.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/widget/Landlord/customewidget.dart';

class ViewEvent extends StatefulWidget {
  final int id;
  final String from;
  final List<Slots> listado;
  late List<Slots> s1 = [];
  ViewEvent(this.id, this.from, this.listado);
  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
  @override
  void initState() {
    init();
    widget.s1 = widget.listado
        .where((e) =>
            e.date_start == widget.from && e.eventTypesDataId == widget.id)
        .toList();

    super.initState();
  }

  void init() async {
    await Prefs.init();
  }

  Map color1 = {
    "grey": Colors.grey,
    "red": Colors.red,
    "orange": Colors.orange,
    "yellow": Colors.yellow,
    "green": Colors.green,
    "cyan": Colors.cyan,
    "blue": Colors.blue,
    "deepPurple": Colors.deepPurple,
    "purple": Colors.purple,
    "pink": Colors.pink
  };
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 450, maxHeight: 450),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: myColor.CM_Lead_fill,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.clear, size: 25),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15.0,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Container(),
                                          style: ElevatedButton.styleFrom(
                                              shape: const CircleBorder(),
                                              backgroundColor: color1[widget
                                                  .s1[0].eventTypesData!.color],
                                              padding:
                                                  const EdgeInsets.all(12)),
                                        ),
                                      ),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.s1[0].eventTypesData!.name ??
                                              "",
                                          style: MyStyles.Bold(
                                              22, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 45.0),
                                      Container(
                                        width: 530,
                                        child: Text(ponerfecha(
                                            widget.s1[0].date_start ?? "")),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Text(widget
                                          .s1[0].eventTypesData!.description ??
                                      ""),
                                  const SizedBox(height: 10.0),
                                  if (widget.s1[0].eventTypesData!.range != 0)
                                    Row(
                                      children: [
                                        const SizedBox(width: 45.0),
                                        Container(
                                          width: 530,
                                          child: (widget.s1[0].eventTypesData!
                                                      .relation ??
                                                  false)
                                              ? Text(GlobleString.ET_One_on_one)
                                              : Text(GlobleString.ET_Group),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child:
                                              Icon(Icons.location_on_outlined)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        width: 530,
                                        child: Text(widget.s1[0].eventTypesData!
                                                .location ??
                                            ""),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0),
                                  if (widget.s1[0].eventTypesData!.range != 0)
                                    Row(
                                      children: [
                                        const SizedBox(
                                            width: 15.0,
                                            child: Icon(Icons
                                                .supervisor_account_outlined)),
                                        const SizedBox(width: 30.0),
                                        Container(
                                          width: 530,
                                          child: Text(
                                              widget.s1.length.toString() +
                                                  " " +
                                                  GlobleString.Guests),
                                        ),
                                      ],
                                    ),
                                  const SizedBox(height: 20.0),
                                  if (widget.s1[0].eventTypesData!.range != 0)
                                    for (int i = 0; i < widget.s1.length; i++)
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const SizedBox(width: 45.0),
                                              SizedBox(
                                                  width: 30.0,
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                        widget.s1[i].email![0]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.white)),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            shape:
                                                                CircleBorder(),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12),
                                                            primary:
                                                                Colors.grey),
                                                  )),
                                              const SizedBox(width: 10.0),
                                              Container(
                                                child: Text(
                                                  widget.s1[i].email.toString(),
                                                  maxLines: 3,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                        ],
                                      ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child:
                                              Icon(Icons.notifications_none)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        child: Text("60 minutes before"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  if (widget.s1[0].eventTypesData!.range != 0)
                                    for (int i = 0; i < widget.s1.length; i++)
                                      Row(
                                        children: [
                                          const SizedBox(
                                              width: 15.0,
                                              child:
                                                  Icon(Icons.calendar_today)),
                                          const SizedBox(width: 30.0),
                                          Container(
                                            child: Text(widget.s1[i].name!),
                                          ),
                                        ],
                                      ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //},
            ),
          ),
        ),
      ),
    );
  }

  String ponerfecha(String date) {
    DateTime fecha = DateFormat("yyyy-MM-dd").parse(date);
    dynamic dayData =
        '{ "1" : "Monday", "2" : "Tuesday", "3" : "Wednesday", "4" : "Thursday ", "5" : "Friday", "6" : "Saturday ", "7" : "Sunday" }';

    dynamic monthData =
        '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "Jun", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

    return json.decode(dayData)['${fecha.weekday}'] +
        " - " +
        json.decode(monthData)['${fecha.month}'] +
        " " +
        fecha.day.toString() +
        ", " +
        fecha.year.toString();
    //  date.year.toString();
  }
}
