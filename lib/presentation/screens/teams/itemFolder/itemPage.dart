import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/teamMembers/teamMemberUserList.dart';
import 'package:silverhome/presentation/models/teamMembers/teamMembersRoleModel.dart';
import 'package:silverhome/presentation/screens/TEST/customerTest.dart';
import 'package:silverhome/presentation/screens/TEST/test.dart';
import 'package:silverhome/presentation/screens/teams/repository/teamMembersService.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'dart:html';

import '../../../models/landlord_models/landlord_profile_state.dart';

typedef VoidCallName = void Function(PropertyDataList propertyData);
typedef VoidCallDetails = void Function(PropertyDataList propertyData);
typedef VoidCallEdit = void Function(PropertyDataList propertyData);
typedef VoidCallDuplicat = void Function(PropertyDataList propertyData);
typedef VoidCallActive = void Function(PropertyDataList propertyData, int pos);
typedef VoidCallInActive = void Function(PropertyDataList propertyData, int pos);
typedef VoidCallIsPublish = void Function(PropertyDataList propertyData, int pos, bool flag);

class TeamMembersItem extends StatefulWidget {
  final VoidCallName _callbackPropertyName;
  final VoidCallDetails _callbackDetails;
  final VoidCallEdit _callbackEdit;
  final VoidCallDuplicat _callbackDuplicat;
  final VoidCallActive _callbackActive;
  final VoidCallInActive _callbackInActive;
  final VoidCallIsPublish _callbackIsPublish;
  TeamMemberUserListModel listdata;

  TeamMembersItem({
    required TeamMemberUserListModel listdata1,
    required VoidCallName onPressName,
    required VoidCallDetails onPressDetails,
    required VoidCallEdit onPresseEdit,
    required VoidCallDuplicat onPresseDuplicat,
    required VoidCallActive onPresseActive,
    required VoidCallInActive onPresseInActive,
    required VoidCallIsPublish onPresseIsPublish,
  })  : listdata = listdata1,
        _callbackPropertyName = onPressName,
        _callbackDetails = onPressDetails,
        _callbackEdit = onPresseEdit,
        _callbackDuplicat = onPresseDuplicat,
        _callbackActive = onPresseActive,
        _callbackInActive = onPresseInActive,
        _callbackIsPublish = onPresseIsPublish;

  @override
  _TeamMembersItemState createState() => _TeamMembersItemState();
}

class _TeamMembersItemState extends State<TeamMembersItem> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 249,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(TeamMemberUserListModel listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.data!.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          height: 40,
          color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata.data![Index], Index),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(DatumTeamUser model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueProperty(model));
    result.add(_datavalueUnit(model));
    result.add(_datavalueCity(model));
    result.add(_datavalueCountry(model));
    result.add(_datavaluePropertyType(model));
    // result.add(_datavalueVacancy(model));
    result.add(_datavalueActiveInactive(model, Index));
    result.add(_actionPopup(model));
    /* result.add(_datavalueStatus(model));
    result.add(_datavalueActiveInactive(model, Index));
    result.add(_datavalueIsPublished(model, Index));
    result.add(_actionPopupCopy(model));
    result.add(_actionPopup(model));*/

    return result;
  }

  Widget _datavalueProperty(DatumTeamUser model) {
    return InkWell(
      onTap: () {
        // widget._callbackPropertyName(model);
      },
      child: Container(
        height: 40,
        width: width / 8,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.firstName.toString(),
          child: Text(
            model.firstName.toString(),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueUnit(DatumTeamUser model) {
    return Container(
      height: 40,
      width: width / 7,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.email.toString(),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCity(DatumTeamUser model) {
    return Container(
      height: 40,
      width: width / 8,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.roleName.toString(),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCountry(DatumTeamUser model) {
    return Container(
      height: 40,
      width: width / 10,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.activatedAt == null ? "No result" : model.activatedAt.toString(),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluePropertyType(DatumTeamUser model) {
    return Container(
      height: 40,
      width: width / 13,
      //width: width / 20,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.lastLoggedIn == null ? "No result" : model.lastLoggedIn.toString(),
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueVacancy(TeamMember model) {
    return Container(
      height: 40,
      width: width / 15,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.isEnabled.toString(), //model.province!,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueStatus(PropertyDataList model) {
    return Container(
      height: 40,
      width: width / 14.5,
      margin: EdgeInsets.only(left: 0),
      alignment: Alignment.center,
      child: model.propDrafting != 3 || !model.isAgreedTandC!
          ? SvgPicture.asset("assets/images/pro_progress_new.svg")
          : SvgPicture.asset("assets/images/pro_complated_new.svg"),
    );
  }

  Widget _datavalueActiveInactive(DatumTeamUser model, int index) {
    bool? valueOff = model.isEnabled;
    return StatefulBuilder(builder: (context, setState) {
      print("value22: " + valueOff.toString());
      return Container(
        height: 40,
        width: width / 11,
        margin: EdgeInsets.only(left: 15),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterSwitch(
              width: 55.0,
              height: 25.0,
              valueFontSize: 10.0,
              toggleSize: 20.0,
              value: valueOff!,
              borderRadius: 30.0,
              padding: 2.0,
              activeColor: myColor.propertyOn,
              activeText: "ON",
              activeTextColor: myColor.white,
              inactiveColor: myColor.gray,
              inactiveText: "OFF",
              inactiveTextColor: myColor.white,
              showOnOff: true,
              onToggle: (val) {
                if (val == true) {
                  valueOff = false;
                } else {
                  valueOff = true;
                }
                valueOff = !valueOff!;

                print("value: " + val.toString());
                /*  if (val) {
                // widget._callbackActive(model, index);
              } else {
                //    widget._callbackInActive(model, index);
              }*/

                TeamMemberService().activeAndInactiveMembers(context, model.id.toString(), valueOff!);

                setState(() {});
              },
            ),
            Expanded(child: Container())
          ],
        ),
      );
    });
  }

  Widget _datavalueIsPublished(PropertyDataList model, int index) {
    return Container(
      height: 40,
      width: width / 13,
      margin: EdgeInsets.only(left: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlutterSwitch(
            width: 55.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 20.0,
            value: model.isPublished!,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: myColor.propertyOn,
            activeText: "ON",
            activeTextColor: myColor.white,
            inactiveColor: myColor.gray,
            inactiveText: "OFF",
            inactiveTextColor: myColor.white,
            showOnOff: true,
            onToggle: (val) {
              if (val) {
                widget._callbackIsPublish(model, index, val);
              } else {
                widget._callbackIsPublish(model, index, val);
              }
            },
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _actionPopupCopy(PropertyDataList model) {
    return Expanded(
        flex: 1,
        child: ConnectState<LandlordProfileState>(
            map: (state) => state.profileState,
            where: notIdentical,
            builder: (profileState) {
              return GestureDetector(
                  onTap: () {
                    print("value: " + profileState!.CustomerFeatureListingURL.toString());

                    String urlDate = Weburl.CustomerFeaturedPage;
                    var urlBase = window.location.href;

                    final startIndex = urlBase.indexOf("#/");
                    String endIndex = urlBase.substring(0, startIndex + 2);

                    print("sresult: " + endIndex.toString());
                    String url = endIndex +
                        "" +
                        "sharedproperties" +
                        "." +
                        profileState!.CustomerFeatureListingURL.toString() +
                        "." +
                        model.id.toString();

                    print("CustomerFeaturedPage" + url);

                    Helper.copyToClipboardHack(context, url);
//kkk
                    /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerFeaturedlistPageTest(
                                  LID: profileState!.CustomerFeatureListingURL.toString(),
                                  idProperties: model.id.toString(),
                                )));*/
                  },
                  child: Container(
                      height: 28,
                      margin: EdgeInsets.only(left: 10, right: 20),
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 40,
                        width: 20,
                        margin: EdgeInsets.only(right: 5),
                        child: Icon(Icons.copy),
                      ))
                  /* PopupMenuButton(
            onSelected: (value) {
              /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerPropertyDetailsPage(LID: /*Prefs.getString(PrefsName.Customer_OwnerID)*/ model.id.toString())),
              );*/
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerFeaturedlistPage(
                          LID: model.id.toString(),
                        )),
              );
            },
            child: 
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 2,
                child: Text(
                  GlobleString.PH_ACT_Edit,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          )),*/
                  );
            }));
  }

  Widget _actionPopup(DatumTeamUser model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        margin: EdgeInsets.only(left: 10, right: 20),
        alignment: Alignment.centerRight,
        child: /* model.propDrafting != 3 || !model.isAgreedTandC!*/ true
            ? PopupMenuButton(
                onSelected: (value) {
                  /* if (value == 1) {
                    widget._callbackDetails(model);
                  } else if (value == 2) {
                    widget._callbackEdit(model);
                  } else if (value == 3) {
                    widget._callbackDuplicat(model);
                  }*/
                },
                child: Container(
                  height: 40,
                  width: 20,
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(Icons.more_vert),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      GlobleString.PH_ACT_Edit,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              )
            : PopupMenuButton(
                onSelected: (value) {
                  /*  if (value == 1) {
                    widget._callbackDetails(model);
                  } else if (value == 2) {
                    widget._callbackEdit(model);
                  } else if (value == 3) {
                    widget._callbackDuplicat(model);
                  }*/
                },
                child: Container(
                  height: 40,
                  width: 20,
                  margin: EdgeInsets.only(right: 5),
                  child: Icon(Icons.more_vert),
                ),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.PH_ACT_ViewDetails,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      GlobleString.PH_ACT_Edit,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Text(
                      GlobleString.PH_ACT_Duplicate,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
