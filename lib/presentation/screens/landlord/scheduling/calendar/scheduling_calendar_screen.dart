import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';

import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';

import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';

import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/scheduling/addEventTypes_dialogbox.dart';
import 'package:silverhome/widget/toggle_switch.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class SchedulingCalendarScreen extends StatefulWidget {
  @override
  _SchedulingCalendarState createState() => _SchedulingCalendarState();
}

class _SchedulingCalendarState extends State<SchedulingCalendarScreen> {
  double height = 0, width = 0, ancho = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  late Timer? _timer = null;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    await Prefs.init();
    updatecount();
    updateState();
    apimanager("", 1, "ID", 0, 0);
  }

  void updatecount() {
    //_store.dispatch(UpdateLLVendor_status_TotalVendor(0));

    //ApiManager().getVendorCount(context, Prefs.getString(PrefsName.OwnerID));
  }

  updateState() async {
    //_store.dispatch(UpdateLLVendor_SearchText(""));
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    //VendorListReqtokens reqtokens = new VendorListReqtokens();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 240;
    ancho = width / 100;
    print(ancho);

    final muestraElListado = false;

    return Container(
      height: height,
      width: width,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                width: width,
                height: height - 45,
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: myColor.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: myColor.application_boreder, width: 1),
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 260,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: myColor.TA_Border,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: "",
                                    onChanged: (value) async {},
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintStyle: MyStyles.Medium(
                                          14, myColor.hintcolor),
                                      contentPadding: EdgeInsets.all(10),
                                      isDense: true,
                                      hintText: GlobleString.CALENDAR_Search,
                                    ),
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8, right: 5),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            onTap: () {
                              openDialogAddEvent();
                            },
                            child: CustomeWidget.AddNewButton(
                                GlobleString.CALENDAR_Create),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10.0),
                      Row(
                        children: [
                          _togglebutton(),
                          const SizedBox(width: 10.0),
                          _actionPopup()
                        ],
                      ),
                    ],
                  ),
                  if (muestraElListado)
                    // ignore: dead_code
                    Column(
                      children: [
                        const SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Today'),
                                Text('<'),
                                Text('>'),
                                Text('Agosto'),
                              ],
                            ),
                            SizedBox(width: 10),
                            Text('Yo creo que quitar esta row'),
                            SizedBox(width: 10),
                            Row(
                              children: [
                                Icon(Icons.settings),
                                Text('Week'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0),
                        const Divider(),
                        const SizedBox(height: 5.0),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  const SizedBox(height: 55.0),
                                  Container(
                                    width: 160,
                                    height: 160,
                                    child: SfCalendar(
                                      view: CalendarView.month,
                                      cellBorderColor: Colors.white,
                                      firstDayOfWeek: 1,
                                      headerHeight: 0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: SfCalendar(
                                  //dataSource: MeetingDataSource(_getDataSource()),
                                  view: CalendarView.week,
                                  firstDayOfWeek: 1,
                                  headerHeight: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else
                    Column(children: [
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Time Zone: Pacific Standar Time (PST)',
                              style: TextStyle(
                                  color: myColor.text_color,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 10.0),
                          Row(
                            children: [
                              Text(GlobleString.CALENDAR_Expand_All,
                                  style: TextStyle(
                                      color: myColor.email_color,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(width: 15.0),
                              Text(GlobleString.CALENDAR_Collapse_All,
                                  style: TextStyle(
                                      color: myColor.email_color,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        color: myColor.TA_table_header,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text('Wednesday - June 8, 2022',
                                    style: TextStyle(
                                        color: myColor.text_color,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Text('(3 scheduled slots)',
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            InkWell(
                              onTap: () {
                                //if(model.isexpand!){widget.listdata[index].isexpand=false;}else{widget.listdata[index].isexpand=true;}
                                //setState(() {});
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 15, right: 10),
                                height: 40,
                                width: 30,
                                alignment: Alignment.center,
                                child: Image.asset(
                                  //isexpand!? "assets/images/circle_up.png" : "assets/images/circle_down.png",
                                  "assets/images/circle_down.png",
                                  height: 19,
                                  //width: 20,
                                  alignment: Alignment.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: myColor.drawselectcolor2,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(width: ancho * 5, child: const Text(" ")),
                            SizedBox(
                              width: ancho * 15,
                              child: const Text(GlobleString.CALENDAR_Time,
                                  style: TextStyle(
                                      color: myColor.text_color,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: ancho * 26,
                              child: const Text(
                                  GlobleString.CALENDAR_Event_Type,
                                  style: TextStyle(
                                      color: myColor.text_color,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: ancho * 20,
                              child: const Text(GlobleString.CALENDAR_Attendees,
                                  style: TextStyle(
                                      color: myColor.text_color,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(
                              width: ancho * 27,
                              child: const Text(GlobleString.CALENDAR_Location,
                                  style: TextStyle(
                                      color: myColor.text_color,
                                      fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: ancho * 2, child: const Text(" "))
                          ],
                        ),
                      ),
                      Container(
                        //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                        color: myColor.TA_light,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ancho * 4,
                              child: Icon(
                                Icons.circle,
                                color: Colors.yellow,
                                size: 17.0,
                              ),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 14,
                                child: Text('10:00 - 10:20 AM')),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 25,
                                child: Text('Showings - 867 Hamilton Street',
                                    maxLines: 3)),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 19, child: Text('Multiple (3)')),
                            SizedBox(width: ancho),
                            SizedBox(
                              width: ancho * 26,
                              child: Text(
                                  '867 Hamilton Street, Vancouver, BC, V6B 7H8, Canada',
                                  maxLines: 3),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 2, child: _actionEventPopup()),
                          ],
                        ),
                      ),
                      Container(
                        //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                        color: myColor.TA_dark,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ancho * 4,
                              child: Icon(
                                Icons.circle,
                                color: Colors.yellow,
                                size: 17.0,
                              ),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 14,
                                child: Text('4:00 - 4:20 PM')),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 25,
                                child: Text('Showings - 123 Main Street',
                                    maxLines: 3)),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 19, child: Text('Hillary Duff')),
                            SizedBox(width: ancho),
                            SizedBox(
                              width: ancho * 26,
                              child: Text(
                                  '123 Main Street, Vancouver, BC, V3D 7K2, Canada',
                                  maxLines: 3),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 2, child: _actionEventPopup()),
                          ],
                        ),
                      ),
                      Container(
                        //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                        color: myColor.TA_light,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: Row(
                          children: [
                            SizedBox(
                              width: ancho * 4,
                              child: Icon(
                                Icons.circle,
                                color: Colors.yellow,
                                size: 17.0,
                              ),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 14,
                                child: Text('10:00 - 10:20 AM')),
                            SizedBox(width: ancho),
                            SizedBox(
                              width: ancho * 25,
                              child: Text('Showings - 867 Hamilton Street',
                                  maxLines: 3),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 19, child: Text('Multiple (3)')),
                            SizedBox(width: ancho),
                            SizedBox(
                              width: ancho * 26,
                              child: Text(
                                  '867 Hamilton Street, Vancouver, BC, V6B 7H8, Canada',
                                  maxLines: 3),
                            ),
                            SizedBox(width: ancho),
                            SizedBox(
                                width: ancho * 2, child: _actionEventPopup()),
                          ],
                        ),
                      ),
                    ]),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    return meetings;
  }

  Widget _togglebutton() {
    return Container(
      width: 243,
      decoration: BoxDecoration(
        border: Border.all(
          color: myColor.text_color,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ToggleSwitch(
        minWidth: 120.0,
        minHeight: 32.0,
        fontSize: 14.0,
        cornerRadius: 5,
        initialLabelIndex: 1,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [
          GlobleString.CALENDAR_ListView,
          GlobleString.CALENDAR_CalendarView
        ],
        onToggle: (index) {},
        totalSwitches: 2,
      ),
    );
  }

  Widget _actionPopup() {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {},
        child: Container(
          height: 40,
          width: 20,
          margin: EdgeInsets.only(right: 5),
          child: Icon(Icons.more_vert),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 1,
              child: Text(
                GlobleString.Export,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                "No se que mas",
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                "nunca importar",
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ];
        },
      ),
    );
  }

  Widget _actionEventPopup() {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {},
        child: Container(
          height: 40,
          width: 20,
          margin: EdgeInsets.only(right: 5),
          child: Icon(Icons.more_vert),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 1,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_View_Event,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_View_Attendees,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 3,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_Edit_Event,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 4,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Text(
                GlobleString.CALENDAR_Edit_Event_Type,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 5,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_Delete,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ];
        },
      ),
    );
  }

  void openDialogAddEvent() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AddEventDialogBox(
          onPressedSave: () async {
            Navigator.of(context1).pop();
            init();
          },
          onPressedClose: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }
}

Widget scheduleViewHeaderBuilder(
    buildContext, ScheduleViewMonthHeaderDetails details) {
  final String monthName = getMonthName(details.date.month);
  return Stack(
    children: [
      Text('Today'),
      Text(
        monthName + ' npi ' + details.date.year.toString(),
        style: TextStyle(fontSize: 18),
      )
    ],
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}

String getMonthName(int month) {
  if (month == 01) {
    return 'January';
  } else if (month == 02) {
    return 'February';
  } else if (month == 03) {
    return 'March';
  } else if (month == 04) {
    return 'April';
  } else if (month == 05) {
    return 'May';
  } else if (month == 06) {
    return 'June';
  } else if (month == 07) {
    return 'July';
  } else if (month == 08) {
    return 'August';
  } else if (month == 09) {
    return 'September';
  } else if (month == 10) {
    return 'October';
  } else if (month == 11) {
    return 'November';
  } else {
    return 'December';
  }
}
