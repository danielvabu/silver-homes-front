import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/admin_action/admin_setting_action.dart';
import 'package:silverhome/presentation/models/admin_models/admin_setting_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager_admin.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

class AdminSettingScreen extends StatefulWidget {
  @override
  _AdminSettingScreenState createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  late OverlayEntry loader;

  @override
  void initState() {
    apiManager();
    super.initState();
  }

  apiManager() async {
    await Prefs.init();
    _store.dispatch(UpdateAdminSettingisLoading(true));
    await ApiManagerAdmin().UnderMaintenanceDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 20,
      padding: EdgeInsets.all(20),
      color: myColor.white,
      child: ConnectState<AdminSettingState>(
          map: (state) => state.adminSettingState,
          where: notIdentical,
          builder: (adminSettingState) {
            return adminSettingState!.isloading!
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        GlobleString.NAV_Under_Maintenance,
                        style: MyStyles.SemiBold(20, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: width,
                        decoration: BoxDecoration(
                          color: myColor.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: myColor.application_boreder, width: 2),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  GlobleString.NAV_Under_WibsiteMaintenance,
                                  style:
                                      MyStyles.Medium(14, myColor.text_color),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  child: FlutterSwitch(
                                    width: 65.0,
                                    height: 30.0,
                                    valueFontSize: 12.0,
                                    toggleSize: 20.0,
                                    value: adminSettingState.isMaintenance!,
                                    borderRadius: 30.0,
                                    padding: 4.0,
                                    activeColor: Colors.lightGreen,
                                    activeText: "Yes",
                                    activeTextColor: myColor.white,
                                    inactiveColor: myColor.gray,
                                    inactiveText: "No",
                                    inactiveTextColor: myColor.white,
                                    showOnOff: true,
                                    onToggle: (val) {
                                      _store.dispatch(
                                          UpdateAdminSettingisMaintenance(val));
                                    },
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              GlobleString.NAV_Under_titleMaintenance,
                              style: MyStyles.Medium(
                                14,
                                adminSettingState.isMaintenance!
                                    ? myColor.text_color
                                    : myColor.disablecolor,
                              ),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: adminSettingState.title,
                              textAlign: TextAlign.start,
                              readOnly: !adminSettingState.isMaintenance!,
                              style: MyStyles.Medium(
                                  14,
                                  adminSettingState.isMaintenance!
                                      ? myColor.text_color
                                      : myColor.disablecolor),
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50),
                              ],
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: adminSettingState.isMaintenance!
                                            ? myColor.gray
                                            : myColor.disablecolor,
                                        width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: adminSettingState.isMaintenance!
                                            ? myColor.gray
                                            : myColor.disablecolor,
                                        width: 1.0),
                                  ),
                                  hoverColor: myColor.white,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(12),
                                  fillColor: myColor.white,
                                  filled: true),
                              onChanged: (value) {
                                _store.dispatch(UpdateAdminSettingTitle(value));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              GlobleString.NAV_Under_InstructionMaintenance,
                              style: MyStyles.Medium(
                                  14,
                                  adminSettingState.isMaintenance!
                                      ? myColor.text_color
                                      : myColor.disablecolor),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: adminSettingState.instruction,
                              textAlign: TextAlign.start,
                              maxLines: 4,
                              readOnly: !adminSettingState.isMaintenance!,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(400),
                              ],
                              style: MyStyles.Medium(
                                  14,
                                  adminSettingState.isMaintenance!
                                      ? myColor.text_color
                                      : myColor.disablecolor),
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: adminSettingState.isMaintenance!
                                            ? myColor.gray
                                            : myColor.disablecolor,
                                        width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: adminSettingState.isMaintenance!
                                            ? myColor.gray
                                            : myColor.disablecolor,
                                        width: 1.0),
                                  ),
                                  hoverColor: myColor.white,
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(12),
                                  fillColor: myColor.white,
                                  filled: true),
                              onChanged: (value) {
                                _store.dispatch(
                                    UpdateAdminSettingInstruction(value));
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [saveandnext(adminSettingState)],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
    );
  }

  Widget saveandnext(AdminSettingState adminSettingState) {
    return InkWell(
      onTap: () {
        validation(adminSettingState);
      },
      child: CustomeWidget.SaveAndNext(GlobleString.TA_Save),
    );
  }

  void validation(AdminSettingState adminSettingState) {
    if (adminSettingState.title == null || adminSettingState.title.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.Under_Maintenance_error_title, false);
    } else if (adminSettingState.instruction == null ||
        adminSettingState.instruction.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.Under_Maintenance_error_instrution, false);
    } else {
      if (adminSettingState.ID == 0) {
        insertMaintenance(adminSettingState);
      } else {
        UpdateMaintenance(adminSettingState);
      }
    }
  }

  insertMaintenance(AdminSettingState adminSettingState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    WebSiteMaintenance webSiteMaintenance = new WebSiteMaintenance();
    webSiteMaintenance.Status = adminSettingState.isMaintenance;
    webSiteMaintenance.Maintenance_Instruction = adminSettingState.instruction;
    webSiteMaintenance.Maintenance_Title = adminSettingState.title;

    ApiManagerAdmin().InsetNewUnderMaintenance(context, webSiteMaintenance,
        (error, respoce) {
      if (error) {
        loader.remove();
        apiManager();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }

  UpdateMaintenance(AdminSettingState adminSettingState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    CommonID commonID = new CommonID();
    commonID.ID = adminSettingState.ID.toString();

    WebSiteMaintenance webSiteMaintenance = new WebSiteMaintenance();
    webSiteMaintenance.Status = adminSettingState.isMaintenance;
    webSiteMaintenance.Maintenance_Instruction = adminSettingState.instruction;
    webSiteMaintenance.Maintenance_Title = adminSettingState.title;

    ApiManagerAdmin().UpdateUnderMaintenance(
        context, commonID, webSiteMaintenance, (error, respoce) {
      if (error) {
        loader.remove();
        apiManager();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
