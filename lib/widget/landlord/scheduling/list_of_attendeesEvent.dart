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
import 'package:silverhome/presentation/models/landlord_models/slots_list_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/customewidget.dart';

class ListOfAttendeesEvent extends StatefulWidget {
  @override
  State<ListOfAttendeesEvent> createState() => _ListOfAttendeesEventState();
  final id;
  //late List<Slots> s1 = [];

  ListOfAttendeesEvent(this.id);
}

class _ListOfAttendeesEventState extends State<ListOfAttendeesEvent> {
  double height = 0, width = 0, ancho = 0;
  late List<bool> press = [];
  Slots? pressDetail;
  late List dias = [];
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

  late Map slots = {};
  int myRating = 0;
  String myRatingView = "";
  apimanager(String search, int pageNo, String SortField, int saquence,
      int ftime) async {
    EventTypesListReqtokens reqtokens = EventTypesListReqtokens();
    reqtokens.Name = widget.id;
    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_EventTypesSlots1;
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
  void initState() {
    init();
    apimanager("", 1, "ID", 0, 0);

    super.initState();
  }

  void data1(List<Slots> listado) {
    List<Slots> unico = [];

    for (int i = 0; i < listado.length; i++) {
      Slots ns = Slots(
          eventTypesData: listado[i].eventTypesData,
          eventTypesDataId: listado[i].eventTypesDataId,
          date_start: listado[i].date_start,
          date_end: listado[i].date_end,
          name: listado[i].name,
          email: listado[i].email,
          state: listado[i].state,
          fname: listado[i].fname,
          lname: listado[i].lname,
          phone: listado[i].phone,
          isOpen: false);

      unico.add(ns);
    }

    for (int i = 0; i < unico.length; i++) {
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
  }

  void init() async {
    await Prefs.init();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 240;
    ancho = (width / 100) - 0.1;
    return Align(
      alignment: const Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.all(30),
            child: ConnectState<SlotsListState>(
                map: (state) => state.slotsListState,
                where: notIdentical,
                builder: (slotsListState) {
                  data1(slotsListState!.eventtypeslist);
                  return ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 900,
                      maxWidth: 900,
                      /*        minHeight: 900,
                        maxHeight: 900 */
                    ),
                    child: Container(
                      /*   height: 500, */
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.0),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
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
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          if (Prefs.getString(PrefsName
                                                  .BT_CompanyLogoURL) !=
                                              null)
                                            Container(
                                              width: 60.0,
                                              height: 50.0,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                color: myColor.white,
                                              ),
                                              child: Image.network(
                                                Prefs.getString(PrefsName
                                                    .BT_CompanyLogoURL),
                                                fit: BoxFit.contain,
                                                width: 148,
                                                height: 148,
                                              ),
                                            ),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Text(
                                                  GlobleString
                                                      .CAL_List_of_Attendees,
                                                  style: MyStyles.Bold(
                                                      22, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                                const SizedBox(height: 5.0),
                                                Text(
                                                  slotsListState!
                                                          .eventtypeslist[0]
                                                          .eventTypesData!
                                                          .name ??
                                                      "",
                                                  style: MyStyles.Bold(
                                                      17, myColor.text_color),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            child: Container(),
                                            style: ElevatedButton.styleFrom(
                                                shape: const CircleBorder(),
                                                backgroundColor: color1[
                                                    slotsListState!
                                                        .eventtypeslist[0]
                                                        .eventTypesData!
                                                        .color],
                                                padding:
                                                    const EdgeInsets.all(15)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20.0),
                                    Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(30.0),
                                      child: Column(
                                        children: [
                                          Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 30.0,
                                                      vertical: 20.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 2.0),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0)),
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .CAL_Event_Details,
                                                        style: MyStyles.Bold(20,
                                                            myColor.text_color),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 20.0),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .CAL_Event_Type_Name,
                                                        style: MyStyles.Bold(16,
                                                            myColor.text_color),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(slotsListState!
                                                              .eventtypeslist[0]
                                                              .eventTypesData!
                                                              .name ??
                                                          ""),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .CAL_Event_Description,
                                                        style: MyStyles.Bold(16,
                                                            myColor.text_color),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(slotsListState!
                                                              .eventtypeslist[0]
                                                              .eventTypesData!
                                                              .description ??
                                                          ""),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .CAL_Property_Name,
                                                        style: MyStyles.Bold(16,
                                                            myColor.text_color),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(slotsListState!
                                                              .eventtypeslist[0]
                                                              .eventTypesData!
                                                              .location ??
                                                          ""),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10.0),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        GlobleString
                                                            .CAL_Location,
                                                        style: MyStyles.Bold(16,
                                                            myColor.text_color),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Text(slotsListState!
                                                              .eventtypeslist[0]
                                                              .eventTypesData!
                                                              .location ??
                                                          ""),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString.CAL_Time_Zone,
                                                style: MyStyles.Bold(
                                                    15, myColor.text_color),
                                              ),
                                              const SizedBox(width: 5.0),
                                              Text(
                                                "Pacific Standard Time (PST)",
                                                style: MyStyles.Bold(
                                                    15, myColor.text_color),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20.0),
                                          for (int i = 0; i < dias.length; i++)
                                            slots[dias[i]].length <= 0
                                                ? SizedBox.shrink()
                                                : Column(
                                                    children: [
                                                      Container(
                                                        color: myColor
                                                            .TA_table_header,
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 20,
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                    ponerfecha(
                                                                        dias[i]
                                                                            .toString()),
                                                                    style: const TextStyle(
                                                                        color: myColor
                                                                            .text_color,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                const SizedBox(
                                                                    width: 10),
                                                              ],
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                setState(() {
                                                                  if (press[
                                                                      i]) {
                                                                    press[i] =
                                                                        false;
                                                                  } else {
                                                                    press[i] =
                                                                        true;
                                                                  }
                                                                });
                                                              },
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            15,
                                                                        right:
                                                                            10),
                                                                height: 40,
                                                                width: 30,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Image.asset(
                                                                  press[i]
                                                                      ? "assets/images/circle_up.png"
                                                                      : "assets/images/circle_down.png",

                                                                  height: 19,
                                                                  //width: 20,
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (press[i] == true)
                                                        slots[dias[i]].length <=
                                                                0
                                                            ? SizedBox.shrink()
                                                            : Container(
                                                                child: Column(
                                                                  children: [
                                                                    for (int j =
                                                                            0;
                                                                        j < slots[dias[i]].length;
                                                                        j++)
                                                                      Column(
                                                                        children: [
                                                                          Container(
                                                                            color: j % 2 == 0
                                                                                ? myColor.TA_dark
                                                                                : myColor.TA_light,
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                                                                            child:
                                                                                Row(
                                                                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const SizedBox(width: 20),
                                                                                SizedBox(width: 150.0, child: Text("${DateFormat.jm().format(DateTime.parse(slots[dias[i]][j].date_start ?? ""))} - ${DateFormat.jm().format(DateTime.parse(slots[dias[i]][j].date_end ?? ""))}")),
                                                                                const SizedBox(width: 10.0),
                                                                                SizedBox(width: 375.0, child: Text(slots[dias[i]][j].name ?? "", maxLines: 3)),
                                                                                const SizedBox(width: 8),
                                                                                const SizedBox(
                                                                                  width: 165.0,
                                                                                  child: Text(GlobleString.ET_Confirmed, style: TextStyle(color: myColor.CAL_green)),
                                                                                ),
                                                                                const SizedBox(width: 8),
                                                                                Expanded(
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      if (pressDetail != null && (pressDetail!.email == slots[dias[i]][j].email && pressDetail!.fname == slots[dias[i]][j].fname && pressDetail!.lname == slots[dias[i]][j].lname)) {
                                                                                        pressDetail = null;
                                                                                      } else {
                                                                                        pressDetail = slots[dias[i]][j];
                                                                                      }

                                                                                      setState(() {});
                                                                                    },
                                                                                    child: Container(
                                                                                      margin: const EdgeInsets.only(left: 15, right: 10),
                                                                                      height: 40,
                                                                                      width: 30,
                                                                                      alignment: Alignment.center,
                                                                                      child: Image.asset(
                                                                                        pressDetail != null && (pressDetail!.email == slots[dias[i]][j].email && pressDetail!.fname == slots[dias[i]][j].fname && pressDetail!.lname == slots[dias[i]][j].lname) ? "assets/images/circle_up.png" : "assets/images/circle_down.png",
                                                                                        height: 19,
                                                                                        alignment: Alignment.center,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          pressDetail != null && (pressDetail!.email == slots[dias[i]][j].email && pressDetail!.fname == slots[dias[i]][j].fname && pressDetail!.lname == slots[dias[i]][j].lname)
                                                                              ? Column(
                                                                                  children: [
                                                                                    Container(
                                                                                      color: j % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                                                                                      width: double.infinity,
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          const Divider(),
                                                                                          const SizedBox(height: 5.0),
                                                                                          Column(
                                                                                            children: [
                                                                                              Row(
                                                                                                children: [
                                                                                                  const SizedBox(width: 160),
                                                                                                  const Text(GlobleString.ET_Last_Name, style: TextStyle(color: myColor.text_color, fontWeight: FontWeight.bold)),
                                                                                                  const SizedBox(width: 8.0),
                                                                                                  Text(slots[dias[i]][j].lname ?? ""),
                                                                                                ],
                                                                                              ),
                                                                                              const SizedBox(height: 10.0),
                                                                                              Row(
                                                                                                children: [
                                                                                                  const SizedBox(width: 160),
                                                                                                  const Text(GlobleString.ET_Email, style: TextStyle(color: myColor.text_color, fontWeight: FontWeight.bold)),
                                                                                                  const SizedBox(width: 8.0),
                                                                                                  Text(slots[dias[i]][j].email ?? ""),
                                                                                                ],
                                                                                              ),
                                                                                              const SizedBox(height: 10.0),
                                                                                              Row(
                                                                                                children: [
                                                                                                  const SizedBox(width: 160),
                                                                                                  const Text(GlobleString.ET_Phone, style: TextStyle(color: myColor.text_color, fontWeight: FontWeight.bold)),
                                                                                                  const SizedBox(width: 8.0),
                                                                                                  Text(slots[dias[i]][j].phone ?? ""),
                                                                                                ],
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(height: 5.0),
                                                                                          const Divider(),
                                                                                          const SizedBox(height: 5.0),
                                                                                          Text(
                                                                                            GlobleString.LMV_AV_Rating,
                                                                                            style: MyStyles.Medium(14, myColor.text_color),
                                                                                          ),
                                                                                          const SizedBox(height: 5.0),
                                                                                          RatingBar.builder(
                                                                                            initialRating: 0,
                                                                                            allowHalfRating: false,
                                                                                            glow: false,
                                                                                            itemBuilder: (context, index) => const Icon(
                                                                                              Icons.star,
                                                                                              color: myColor.blue,
                                                                                            ),
                                                                                            onRatingUpdate: (llega) {
                                                                                              myRating = llega as int;
                                                                                            },
                                                                                            itemCount: 5,
                                                                                            itemSize: 25.0,
                                                                                            unratedColor: myColor.TA_Border,
                                                                                            direction: Axis.horizontal,
                                                                                          ),
                                                                                          const SizedBox(height: 10.0),
                                                                                          Text(
                                                                                            GlobleString.LMV_AV_Note,
                                                                                            style: MyStyles.Medium(14, myColor.text_color),
                                                                                            textAlign: TextAlign.start,
                                                                                          ),
                                                                                          const SizedBox(height: 5.0),
                                                                                          TextFormField(
                                                                                            //initialValue: addVendorState.Note,
                                                                                            textAlign: TextAlign.start,
                                                                                            style: MyStyles.Medium(14, myColor.text_color),
                                                                                            maxLines: 4,
                                                                                            maxLength: 10000,
                                                                                            inputFormatters: [
                                                                                              LengthLimitingTextInputFormatter(10000),
                                                                                            ],
                                                                                            decoration: const InputDecoration(
                                                                                                focusedBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(color: myColor.blue, width: 2.0),
                                                                                                ),
                                                                                                enabledBorder: OutlineInputBorder(
                                                                                                  borderSide: BorderSide(color: myColor.gray, width: 1.0),
                                                                                                ),
                                                                                                isDense: true,
                                                                                                contentPadding: EdgeInsets.all(10),
                                                                                                fillColor: myColor.white,
                                                                                                filled: true),
                                                                                            onChanged: (llega) {
                                                                                              myRatingView = llega;
                                                                                            },
                                                                                          ),
                                                                                          const SizedBox(height: 10.0),
                                                                                          Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            children: [
                                                                                              InkWell(
                                                                                                onTap: () async {
                                                                                                  TenancyApplicationPersonID person1 = TenancyApplicationPersonID();
                                                                                                  person1.person_id = slots[dias[i]][j].person_id;
                                                                                                  TenancyApplicationUpdateRating2 updaterating = TenancyApplicationUpdateRating2();
                                                                                                  updaterating.Rating = myRating as double?;
                                                                                                  updaterating.Note = myRatingView;

                                                                                                  await ApiManager().UpdateRatingApplication(context, person1, updaterating, (status, responce) async {
                                                                                                    //if (status) {leadcallApi();}
                                                                                                  });
                                                                                                  Navigator.of(context).pop();
                                                                                                },
                                                                                                child: CustomeWidget.AddSimpleButton(GlobleString.SAVE),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                          const SizedBox(height: 15.0),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )
                                                                              : SizedBox.shrink()
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                      const SizedBox(
                                                          height: 20.0),
                                                    ],
                                                  ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      //},
                    ),
                  );
                })),
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
