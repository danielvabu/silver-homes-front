import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
//import 'package:silverhome/domain/actions/Event_action/add_Event_action.dart';
import 'package:silverhome/domain/entities/citydata.dart';
import 'package:silverhome/domain/entities/countrydata.dart';
import 'package:silverhome/domain/entities/statedata.dart';
//import 'package:silverhome/presentation/models/Event/add_Event_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../alert_dialogbox.dart';

class AddEventDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;
  static bool changeData = false;

  AddEventDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _AddEventDialogBoxState createState() => _AddEventDialogBoxState();
}

class _AddEventDialogBoxState extends State<AddEventDialogBox> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  final FocusNode focus = FocusNode();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  bool change = false;

  @override
  void initState() {
    apimanager();
    AddEventDialogBox.changeData = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      change = true;
      AddEventDialogBox.changeData = true;
    }
  }

  void apimanager() async {
    await Prefs.init();

    List<SystemEnumDetails> Categorylist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);
    //_store.dispatch(UpdateADV_Categorylist(Categorylist));
  }

  TextEditingController dateCtl = TextEditingController();
  TextEditingController timeCtl = TextEditingController();
  TextEditingController timeECtl = TextEditingController();

  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);

  String eventTitle = "";
  String eventType = GlobleString.EVENT_Event;
  String eventDate = "";
  String eventTime = "";
  String eventEndTime = "";
  String eventDescription = "";

  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data:
              ThemeData(primarySwatch: MaterialColor(0xFF010B32, Helper.color)),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final fini = pickedDate.toLocal().toString().split(" ");
      dateCtl.text = eventDate = fini[0];
    }
  }

  Future<void> _selectTime1(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data:
              ThemeData(primarySwatch: MaterialColor(0xFF010B32, Helper.color)),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      final hini = pickedTime.hour.toString().padLeft(2, '0') +
          ":" +
          pickedTime.minute.toString().padLeft(2, '0');
      timeCtl.text = eventTime = hini;
    }
  }

  Future<void> _selectTime2(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data:
              ThemeData(primarySwatch: MaterialColor(0xFF010B32, Helper.color)),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      final hini = pickedTime.hour.toString().padLeft(2, '0') +
          ":" +
          pickedTime.minute.toString().padLeft(2, '0');
      timeECtl.text = eventEndTime = hini;
    }
  }

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
                minWidth: 500, maxWidth: 500, minHeight: 400, maxHeight: 400),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Colors.white,
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
                            if (!AddEventDialogBox.changeData) {
                              widget._callbackClose();
                              return;
                            }
                            showDialog(
                              context: context,
                              barrierColor: Colors.black45,
                              useSafeArea: true,
                              barrierDismissible: false,
                              builder: (BuildContext context1) {
                                return AlertDialogBox(
                                  title: GlobleString.ADV_back_to_msg,
                                  positiveText:
                                      GlobleString.ADV_back_to_msg_yes,
                                  negativeText: GlobleString.ADV_back_to_msg_NO,
                                  onPressedYes: () {
                                    Navigator.of(context1).pop();
                                    //checkValidation(context, addEventState!);
                                  },
                                  onPressedNo: () {
                                    Navigator.of(context1).pop();
                                    widget._callbackClose();
                                  },
                                );
                              },
                            );
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      GlobleString.CALENDAR_Add_New_Event,
                                      style: MyStyles.Medium(
                                          20, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: FocusScope(
                                node: _focusScopeNode,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Text(
                                                  GlobleString.EVENT_Title,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: TextFormField(
                                                  initialValue: "",
                                                  textAlign: TextAlign.start,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  decoration: const InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      myColor
                                                                          .blue,
                                                                  width: 2)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: myColor
                                                                          .gray,
                                                                      width:
                                                                          1.0)),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true),
                                                  onChanged: (value) {
                                                    eventTitle = value;
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Text(
                                                  GlobleString
                                                      .CALENDAR_Event_Type,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                height: 30,
                                                width: Size.infinite.width,
                                                child: DropdownSearch(
                                                  mode: Mode.MENU,
                                                  focuscolor: myColor.blue,
                                                  focusWidth: 2,
                                                  items: const [
                                                    GlobleString.EVENT_Event,
                                                    GlobleString.EVENT_Task,
                                                    GlobleString.EVENT_Reminder
                                                  ],
                                                  textstyle: MyStyles.Medium(
                                                      12, myColor.black),
                                                  defultHeight: 3 * 35,
                                                  hint: GlobleString
                                                      .EVENT_Event_Type,
                                                  showSearchBox: false,
                                                  selectedItem:
                                                      GlobleString.EVENT_Event,
                                                  isFilteredOnline: true,
                                                  onChanged: (value) {
                                                    eventType =
                                                        value.toString();
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 0.0),
                                                child: Text(
                                                  GlobleString.EVENT_Date,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: TextFormField(
                                                  controller: dateCtl,
                                                  textAlign: TextAlign.start,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  decoration: const InputDecoration(
                                                      hintText: "yyyy-mm-dd",
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      myColor
                                                                          .blue,
                                                                  width: 2)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: myColor
                                                                          .gray,
                                                                      width:
                                                                          1.0)),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true),
                                                  onTap: () {
                                                    _selectDate1(context);
                                                  },
                                                  readOnly: true,
                                                  //onChanged: (value) {eventDate = value;},
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Text(
                                                  GlobleString.EVENT_Start_Time,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: TextFormField(
                                                  controller: timeCtl,
                                                  textAlign: TextAlign.start,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  decoration: const InputDecoration(
                                                      hintText: "hh:mm",
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      myColor
                                                                          .blue,
                                                                  width: 2)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: myColor
                                                                          .gray,
                                                                      width:
                                                                          1.0)),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true),
                                                  readOnly: true,
                                                  onTap: () {
                                                    _selectTime1(context);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: Text(
                                                  GlobleString.EVENT_End_Time,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: TextFormField(
                                                  controller: timeCtl,
                                                  textAlign: TextAlign.start,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  decoration: const InputDecoration(
                                                      hintText: "hh:mm",
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      myColor
                                                                          .blue,
                                                                  width: 2)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: myColor
                                                                          .gray,
                                                                      width:
                                                                          1.0)),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true),
                                                  readOnly: true,
                                                  onTap: () {
                                                    _selectTime2(context);
                                                  },
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8.0,
                                                    vertical: 0.0),
                                                child: Text(
                                                  GlobleString
                                                      .EVENT_Description,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              const SizedBox(height: 5.0),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 0.0),
                                                child: TextFormField(
                                                  initialValue: "",
                                                  textAlign: TextAlign.start,
                                                  style: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  decoration: const InputDecoration(
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color:
                                                                      myColor
                                                                          .blue,
                                                                  width: 2)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: myColor
                                                                          .gray,
                                                                      width:
                                                                          1.0)),
                                                      isDense: true,
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      fillColor: myColor.white,
                                                      filled: true),
                                                  onChanged: (value) {
                                                    eventDescription = value;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15.0),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!AddEventDialogBox.changeData) {
                                        widget._callbackClose();
                                        return;
                                      }
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black45,
                                        useSafeArea: true,
                                        barrierDismissible: false,
                                        builder: (BuildContext context1) {
                                          return AlertDialogBox(
                                            title: GlobleString.ADV_back_to_msg,
                                            positiveText: GlobleString
                                                .ADV_back_to_msg_yes,
                                            negativeText:
                                                GlobleString.ADV_back_to_msg_NO,
                                            onPressedYes: () {
                                              Navigator.of(context1).pop();
                                              //checkValidation(context, addEventState);
                                            },
                                            onPressedNo: () {
                                              Navigator.of(context1).pop();
                                              widget._callbackClose();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          color: myColor.white,
                                          border: Border.all(
                                              color: myColor.Circle_main,
                                              width: 1)),
                                      child: Text(
                                        GlobleString.NL_Close,
                                        style: MyStyles.Medium(
                                            14, myColor.Circle_main),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      checkValidation(context);
                                    },
                                    child: Container(
                                      height: 35,
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        color: myColor.Circle_main,
                                      ),
                                      child: Text(
                                        GlobleString.NL_SAVE,
                                        style:
                                            MyStyles.Medium(14, myColor.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkValidation(BuildContext context) {
    if (eventTitle == null || eventTitle.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.EVENT_No_Title, false);
    } else if (eventDate == null || eventDate.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.EVENT_No_Date, false);
    } else if (eventTime == null || eventTime.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.EVENT_No_Time, false);
    } else if (eventEndTime == null || eventEndTime.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.EVENT_No_EndTime, false);
    } else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);
      MyEvent entraid = MyEvent();
      entraid.event_type_id = 0;
      //entraid.person_id = Prefs.getString(PrefsName.OwnerID);
      entraid.event_title = eventTitle;
      entraid.event_kat = eventType;
      entraid.date_start = eventDate + ' ' + eventTime;
      entraid.date_end = eventDate + ' ' + eventEndTime;
      entraid.event_desc = eventDescription;
      List<MyEvent> eventolist = [];
      eventolist.add(entraid);
      eventCall(eventolist);
      //widget._callbackSave();
      //loader.remove();
    }
  }

  eventCall(eventolist) {
    ApiManager().InsetNewEventAPI(context, eventolist, (error, respoce) {
      if (error) {
        ToastUtils.showCustomToast(
            context, GlobleString.EVENT_Event_Success, true);
        loader.remove();
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
