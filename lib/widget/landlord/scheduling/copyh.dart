import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_actions.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/customewidget.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class Copyh extends StatefulWidget {
  final String? day;
  EventTypesState eventtypesData;
  @override
  State<Copyh> createState() => _CopyhState();
  Copyh(this.eventtypesData, this.day);
}

class _CopyhState extends State<Copyh> {
  final _store = getIt<AppStore>();
  List<String> days = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  String selectdat = "";

  @override
  void initState() {
    //updateCount();
    init();
    days.remove(widget.day);
  }

//updateCount() {
//  ApiManager().updateEventTypesStatusCount(context);
//}

  void init() async {
    await Prefs.init();
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
                minWidth: 700, maxWidth: 700, minHeight: 160, maxHeight: 160),
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
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      GlobleString.Copy_Linkday,
                                      style:
                                          MyStyles.Bold(22, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Container(
                                        width: 530,
                                        child: DropdownSearch<String>(
                                          key: UniqueKey(),
                                          mode: Mode.MENU,
                                          errorcolor: myColor.errorcolor,
                                          focuscolor: myColor.blue,
                                          focusWidth: 2,
                                          popupBackgroundColor: myColor.white,
                                          items: days,
                                          defultHeight: 80,
                                          textstyle: MyStyles.Medium(
                                              14, myColor.text_color),
                                          hint: "Select",
                                          showSearchBox: false,
                                          isFilteredOnline: true,
                                          onChanged: (value) {
                                            selectdat = value!;
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      InkWell(
                                        onTap: () {
                                          List newdays = [];
                                          List newdays2 = [];
                                          List h1 = [];
                                          List h2 = [];
                                          if (widget.day == "Sunday") {
                                            h1 = widget.eventtypesData.sunh1;
                                            h2 = widget.eventtypesData.sunh2;
                                          }
                                          if (widget.day == "Monday") {
                                            h1 = widget.eventtypesData.monh1;
                                            h2 = widget.eventtypesData.monh2;
                                          }
                                          if (widget.day == "Tuesday") {
                                            h1 = widget.eventtypesData.tueh1;
                                            h2 = widget.eventtypesData.tueh2;
                                          }

                                          if (widget.day == "Wednesday") {
                                            h1 = widget.eventtypesData.wedh1;
                                            h2 = widget.eventtypesData.wedh2;
                                          }
                                          if (widget.day == "Thursday") {
                                            h1 = widget.eventtypesData.thuh1;
                                            h2 = widget.eventtypesData.thuh2;
                                          }

                                          if (widget.day == "Friday") {
                                            h1 = widget.eventtypesData.frih1;
                                            h2 = widget.eventtypesData.frih2;
                                          }
                                          if (widget.day == "Saturday") {
                                            h1 = widget.eventtypesData.sath1;
                                            h2 = widget.eventtypesData.sath2;
                                          }
                                          for (int i = 0; i < h1.length; i++) {
                                            newdays.add(h1[i]);
                                          }

                                          for (int i = 0; i < h2.length; i++) {
                                            newdays2.add(h2[i]);
                                          }

                                          if (selectdat == "Sunday") {
                                            _store.dispatch(UpdateSun(true));
                                            _store
                                                .dispatch(Updatsunh1(newdays));
                                            _store
                                                .dispatch(Updatsunh2(newdays2));
                                          }

                                          if (selectdat == "Monday") {
                                            _store.dispatch(UpdateMon(true));
                                            _store
                                                .dispatch(Updatmonh1(newdays));
                                            _store
                                                .dispatch(Updatmonh2(newdays2));
                                          }
                                          if (selectdat == "Tuesday") {
                                            _store.dispatch(Updatetue(true));
                                            _store
                                                .dispatch(Updattueh1(newdays));
                                            _store
                                                .dispatch(Updattueh2(newdays2));
                                          }
                                          if (selectdat == "Wednesday") {
                                            _store.dispatch(Updatewed(true));
                                            _store
                                                .dispatch(Updatwedh1(newdays));
                                            _store
                                                .dispatch(Updatwedh2(newdays2));
                                          }
                                          if (selectdat == "Thursday") {
                                            _store.dispatch(Updatethu(true));
                                            _store
                                                .dispatch(Updatthuh1(newdays));
                                            _store
                                                .dispatch(Updatthuh2(newdays2));
                                          }
                                          if (selectdat == "Friday") {
                                            _store.dispatch(Updatefri(true));
                                            _store
                                                .dispatch(Updatfrih1(newdays));
                                            _store
                                                .dispatch(Updatfrih2(newdays2));
                                          }
                                          if (selectdat == "Saturday") {
                                            _store.dispatch(Updatesat(true));
                                            _store
                                                .dispatch(Updatsath1(newdays));
                                            _store
                                                .dispatch(Updatsath2(newdays2));
                                          }
                                        },
                                        child: CustomeWidget.AddSimpleButton(
                                            GlobleString.Copy_Linkdaybutton),
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
}
