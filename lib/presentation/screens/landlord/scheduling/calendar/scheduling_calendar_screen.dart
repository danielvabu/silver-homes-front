import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/domain/entities/slots.dart';
import 'package:silverhome/presentation/models/landlord_models/slots_list_state.dart';
import 'package:silverhome/widget/landlord/scheduling/list_of_attendees.dart';
import 'package:silverhome/widget/landlord/scheduling/share_link.dart';
import 'package:silverhome/widget/landlord/scheduling/view_event.dart';

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
import 'package:silverhome/widget/landlord/scheduling/addEvent_dialogbox.dart';
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
  int muestraElListado = 0;
  late List dias = [];
  late List<bool> press = [];
  late Map slots = {};
  late List<Map> unique = [];
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
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    await Prefs.init();
    apimanager("", 1, "ID", 0, 0);
  }

  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    EventTypesListReqtokens reqtokens = EventTypesListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_EventTypesSlots;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = true;
    dsqQuery.eventTypesListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("EventTypesSlots", filterjson);

    await ApiManager().getEventTypesSlots(context, filterjson, ftime);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 240;
    ancho = (width / 100) - 0.1;
    print(ancho);

    return Container(
      height: height,
      width: width,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: ConnectState<SlotsListState>(
                map: (state) => state.slotsListState,
                where: notIdentical,
                builder: (slotsListState) {
                  return Column(
                    children: [
                      Container(
                        width: width,
                        height: height - 45,
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: myColor.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: myColor.application_boreder, width: 1),
                        ),
                        child: Column(children: [
                          Container(
                            width: double.infinity,
                            child: Row(
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
                                                contentPadding:
                                                    EdgeInsets.all(10),
                                                isDense: true,
                                                hintText: GlobleString
                                                    .CALENDAR_Search,
                                              ),
                                              style: MyStyles.Medium(
                                                  14, myColor.text_color),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                left: 8, right: 5),
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
                                    // _actionPopup()
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (muestraElListado == 0)
                            Container(
                              width: double.infinity,
                              height: height - 103,
                              child: Column(
                                children: [
                                  const SizedBox(height: 15.0),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     Row(
                                  //       children: [
                                  //         Text('Today'),
                                  //         Text('<'),
                                  //         Text('>'),
                                  //         Text('Agosto'),
                                  //       ],
                                  //     ),
                                  //     SizedBox(width: 10),
                                  //     Text('Yo creo que quitar esta row'),
                                  //     SizedBox(width: 10),
                                  //     Row(
                                  //       children: [
                                  //         Icon(Icons.settings),
                                  //         Text('Week'),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  const SizedBox(height: 5.0),
                                  const Divider(),
                                  const SizedBox(height: 5.0),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                            onTap:
                                                (CalendarTapDetails details) {
                                              dynamic appointment =
                                                  details.appointments;
                                              DateTime date = details.date!;
                                              CalendarElement element =
                                                  details.targetElement;

                                              openDialogViewEvent(
                                                  details.appointments![0].id,
                                                  details
                                                      .appointments![0].froms,
                                                  slotsListState!
                                                      .eventtypeslist);
                                            },
                                            dataSource: MeetingDataSource(
                                                _getDataSource(slotsListState!
                                                    .eventtypeslist)),
                                            view: CalendarView.week,
                                            firstDayOfWeek: 1,
                                            headerHeight: 0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Container(
                              width: double.infinity,
                              height: height - 103,
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0, vertical: 4.0),
                                child: Column(children: [
                                  const SizedBox(height: 20.0),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Time Zone: Pacific Standar Time (PST)',
                                          style: TextStyle(
                                              color: myColor.text_color,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 10.0),
                                      Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                for (int i = 0;
                                                    i < dias.length;
                                                    i++) {
                                                  press[i] = true;
                                                }
                                              });
                                            },
                                            child: Text(
                                                GlobleString
                                                    .CALENDAR_Expand_All,
                                                style: TextStyle(
                                                    color: myColor.email_color,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          const SizedBox(width: 15.0),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                for (int i = 0;
                                                    i < dias.length;
                                                    i++) {
                                                  press[i] = false;
                                                }
                                              });
                                            },
                                            child: Text(
                                                GlobleString
                                                    .CALENDAR_Collapse_All,
                                                style: TextStyle(
                                                    color: myColor.email_color,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  for (int i = 0; i < dias.length; i++)
                                    Column(
                                      children: [
                                        Container(
                                          color: myColor.TA_table_header,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      ponerfecha(
                                                          dias[i].toString()),
                                                      style: const TextStyle(
                                                          color: myColor
                                                              .text_color,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                      '(' +
                                                          slots[dias[i]]
                                                              .length
                                                              .toString() +
                                                          ' scheduled slots)',
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ],
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  //if(model.isexpand!){widget.listdata[index].isexpand=false;}else{widget.listdata[index].isexpand=true;}
                                                  setState(() {
                                                    if (press[i]) {
                                                      press[i] = false;
                                                    } else {
                                                      press[i] = true;
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 15, right: 10),
                                                  height: 40,
                                                  width: 30,
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    press[i]
                                                        ? "assets/images/circle_up.png"
                                                        : "assets/images/circle_down.png",

                                                    height: 19,
                                                    //width: 20,
                                                    alignment: Alignment.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
// Este container es el que se debe desplegar o esconder
                                        if (press[i] == true)
                                          Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  color:
                                                      myColor.drawselectcolor2,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                          width: ancho * 5,
                                                          child:
                                                              const Text(" ")),
                                                      SizedBox(
                                                        width: ancho * 15,
                                                        child: const Text(
                                                            GlobleString
                                                                .CALENDAR_Time,
                                                            style: TextStyle(
                                                                color: myColor
                                                                    .text_color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      SizedBox(
                                                        width: ancho * 26,
                                                        child: const Text(
                                                            GlobleString
                                                                .CALENDAR_Event_Type,
                                                            style: TextStyle(
                                                                color: myColor
                                                                    .text_color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      SizedBox(
                                                        width: ancho * 20,
                                                        child: const Text(
                                                            GlobleString
                                                                .CALENDAR_Attendees,
                                                            style: TextStyle(
                                                                color: myColor
                                                                    .text_color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      SizedBox(
                                                        width: ancho * 27,
                                                        child: const Text(
                                                            GlobleString
                                                                .CALENDAR_Location,
                                                            style: TextStyle(
                                                                color: myColor
                                                                    .text_color,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                      ),
                                                      SizedBox(
                                                          width: ancho * 2,
                                                          child:
                                                              const Text(" "))
                                                    ],
                                                  ),
                                                ),
                                                for (int j = 0;
                                                    j < slots[dias[i]].length;
                                                    j++)
                                                  Container(
                                                    color: j % 2 == 0
                                                        ? myColor.TA_dark
                                                        : myColor.TA_light,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 0,
                                                        vertical: 5),
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: ancho * 4,
                                                          child: Icon(
                                                            Icons.circle,
                                                            color: color1[slots[
                                                                    dias[i]][j]
                                                                .eventTypesData
                                                                .color],
                                                            size: 17.0,
                                                          ),
                                                        ),
                                                        SizedBox(width: ancho),
                                                        SizedBox(
                                                            width: ancho * 14,
                                                            child: Text(DateFormat
                                                                        .jm()
                                                                    .format(DateTime.parse(
                                                                        slots[dias[i]][j]
                                                                            .date_start)) +
                                                                " - " +
                                                                DateFormat.jm().format(
                                                                    DateTime.parse(
                                                                        slots[dias[i]][j]
                                                                            .date_end)))),
                                                        SizedBox(width: ancho),
                                                        SizedBox(
                                                            width: ancho * 25,
                                                            child: Text(
                                                                slots[dias[i]]
                                                                        [j]
                                                                    .eventTypesData
                                                                    .name,
                                                                maxLines: 3)),
                                                        SizedBox(width: ancho),
                                                        SizedBox(
                                                            width: ancho * 19,
                                                            child: Text(attendens(
                                                                slots[dias[i]]
                                                                        [j]
                                                                    .eventTypesDataId,
                                                                slots[dias[i]]
                                                                        [j]
                                                                    .date_start,
                                                                slotsListState!
                                                                    .eventtypeslist))),
                                                        SizedBox(width: ancho),
                                                        SizedBox(
                                                          width: ancho * 26,
                                                          child: Text(
                                                              slots[dias[i]][j]
                                                                  .eventTypesData
                                                                  .location,
                                                              maxLines: 3),
                                                        ),
                                                        SizedBox(width: ancho),
                                                        SizedBox(
                                                            width: ancho * 2,
                                                            child: _actionEventPopup(
                                                                slots[dias[i]]
                                                                    [j],
                                                                slotsListState!
                                                                    .eventtypeslist)),
                                                      ],
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        const SizedBox(height: 20.0),
                                      ],
                                    ),
                                ]),
                              ),
                            ),
                        ]),
                      ),
                    ],
                  );
                })),
      ),
    );
  }

  List<Meeting> _getDataSource(List<Slots> listado) {
    final List<Meeting> meetings = <Meeting>[];
    List<Slots> unico = [];

    for (int i = 0; i < listado.length; i++) {
      // int count = 0;
      // for (var element in listado) {
      //   if (element.date_start == listado[i].date_start &&
      //       element.eventTypesDataId == listado[i].eventTypesDataId) {
      //     count++;
      //   }
      // }
      List<Slots> filteredList = unico
          .where((e) =>
              e.date_start == listado[i].date_start &&
              e.eventTypesDataId == listado[i].eventTypesDataId)
          .toList();
      if (filteredList.length > 0) {
      } else {
        Slots ns = Slots(
            eventTypesData: listado[i].eventTypesData,
            eventTypesDataId: listado[i].eventTypesDataId,
            date_start: listado[i].date_start,
            date_end: listado[i].date_end,
            name: "",
            email: "",
            state: listado[i].state);

        unico.add(ns);
      }
    }

    for (int i = 0; i < unico.length; i++) {
      Color color = Colors.white;
      String nombreevento = unico[i].eventTypesData!.name! +
          " " +
          unico[i].eventTypesData!.location!;
      if (unico[i].eventTypesData!.color == "grey") {
        color = Colors.grey;
      }
      if (unico[i].eventTypesData!.color == "red") {
        color = Colors.red;
      }
      if (unico[i].eventTypesData!.color == "orange") {
        color = Colors.orange;
      }
      if (unico[i].eventTypesData!.color == "yellow") {
        color = Colors.yellow;
      }
      if (unico[i].eventTypesData!.color == "green") {
        color = Colors.green;
      }
      if (unico[i].eventTypesData!.color == "cyan") {
        color = Colors.cyan;
      }
      if (unico[i].eventTypesData!.color == "blue") {
        color = Colors.blue;
      }
      if (unico[i].eventTypesData!.color == "deepPurple") {
        color = Colors.deepPurple;
      }
      if (unico[i].eventTypesData!.color == "purple") {
        color = Colors.purple;
      }
      if (unico[i].eventTypesData!.color == "pink") {
        color = Colors.pink;
      }
      meetings.add(Meeting(
          unico[i].eventTypesDataId ?? 0,
          nombreevento,
          DateTime.parse(unico[i].date_start ?? ""),
          DateTime.parse(unico[i].date_end ?? ""),
          unico[i].date_start!,
          color,
          false));
      String fecha = DateFormat("yyyy-MM-dd")
          .format(DateTime.parse(unico[i].date_start ?? ""));
      dias.add(fecha);
    }
    dias = dias.toSet().toList();
    for (int i = 0; i < dias.length; i++) {
      slots[dias[i]] = unico
          .where((element) =>
              DateFormat("yyyy-MM-dd")
                  .format(DateTime.parse(element.date_start!))
                  .toString() ==
              dias[i])
          .toList();

      press.add(false);
    }
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
        initialLabelIndex: muestraElListado,
        activeBgColor: [myColor.text_color],
        activeFgColor: Colors.white,
        inactiveBgColor: Colors.white,
        inactiveFgColor: myColor.text_color,
        labels: [
          GlobleString.CALENDAR_CalendarView,
          GlobleString.CALENDAR_ListView
        ],
        onToggle: (index) {
          setState(() {
            muestraElListado = index;
          });
        },
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

  Widget _actionEventPopup(Slots slot, List<Slots> lista) {
    return Container(
      height: 32,
      width: 30,
      child: PopupMenuButton(
        onSelected: (value) {
          if (value == 1) {
            openDialogViewEvent(
                slot.eventTypesDataId!, slot.date_start!, lista);
          }
          if (value == 2) {
            openDialogListAttendees(slot, lista);
          }
        },
        child: Container(
          height: 40,
          width: 20,
          margin: const EdgeInsets.only(right: 5),
          child: const Icon(Icons.more_vert),
        ),
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 1,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_View_Event,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            if (slot.eventTypesData!.range != 0)
              PopupMenuItem(
                value: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
                child: Text(
                  GlobleString.CALENDAR_View_Attendees,
                  style: MyStyles.Regular(12, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            PopupMenuItem(
              value: 3,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
              child: Text(
                GlobleString.CALENDAR_Edit_Event,
                style: MyStyles.Regular(12, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            if (slot.eventTypesData!.range != 0)
              PopupMenuItem(
                value: 4,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                child: Text(
                  GlobleString.CALENDAR_Edit_Event_Type,
                  style: MyStyles.Regular(12, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            PopupMenuItem(
              value: 5,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
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

  void openDialogListAttendees(Slots slot, List<Slots> lista) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ListOfAttendees(slot, lista);
      },
    );
  }

  void openDialogShareLink() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return Container();
      },
    );
  }

  void openDialogViewEvent(int id, String from, List<Slots> listado) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ViewEvent(id, from, listado);
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
  Meeting(this.id, this.eventName, this.from, this.to, this.froms,
      this.background, this.isAllDay);
  int id;
  String eventName;
  DateTime from;
  DateTime to;
  String froms;
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

String attendens(int id, String date, List<Slots> listado) {
  String atten = "";
  List<Slots> verl = listado
      .where((element) =>
          element.date_start! == date && element.eventTypesDataId == id)
      .toList();
  if (verl.length > 1) {
    atten = "Multiple(" + verl.length.toString() + ")";
  } else {
    atten = verl[0].name!;
  }
  return atten;
}
