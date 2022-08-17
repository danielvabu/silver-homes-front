import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:archive/archive.dart' as webarc;
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddinfo_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddoccupant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyaddreference_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancycurrenttenant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyemployment_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyform_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyperson_actions.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/domain/entities/maintenance_details.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/domain/entities/tenancy_additional_info.dart';
import 'package:silverhome/domain/entities/tenancy_additional_reference.dart';
import 'package:silverhome/domain/entities/tenancy_additionaloccupants.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/domain/entities/tenancy_employment_information.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/screens/landlord/property/add_edit_property.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/reference_dialog/multiple_reference_details_dialog.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

class CustomeWidget {
  static late OverlayEntry loader;
  static double ssheight = 0, sswidth = 0;
  static var font_medium, font_demi, font_regular, font_bold;

  static Widget FunnelCountBox(String text, String count) {
    return Container(
      //height: 25,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 14, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: MyStyles.Medium(18, myColor.text_color),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: myColor.FV_Count),
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                count,
                style: MyStyles.Medium(13, myColor.text_color),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget TenantsTabWidget(String title, int selecttab, int tabindex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tabindex == 1
                    ? Container(
                        height: 34,
                        margin: EdgeInsets.only(top: 3),
                        alignment: Alignment.centerRight,
                      )
                    : Container(
                        height: 34,
                        margin: EdgeInsets.only(top: 3, right: 2),
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/tab_arrow.png',
                          width: 15,
                          height: 34,
                          color: selecttab == (tabindex - 1)
                              ? myColor.blue
                              : myColor.TA_tab_devide,
                          fit: BoxFit.contain,
                        ),
                      ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      title,
                      style: selecttab == tabindex
                          ? MyStyles.SemiBold(12, myColor.blue)
                          : MyStyles.Medium(12, myColor.text_color),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                tabindex == 7
                    ? Container(
                        height: 34,
                        margin: EdgeInsets.only(top: 3, right: 2),
                        alignment: Alignment.centerRight,
                        child: Image.asset(
                          'assets/images/tab_arrow.png',
                          width: 15,
                          height: 34,
                          color: selecttab == 7
                              ? myColor.blue
                              : myColor.TA_tab_devide,
                          fit: BoxFit.contain,
                        ),
                      )
                    : Container(
                        height: 34,
                        margin: EdgeInsets.only(top: 3),
                        alignment: Alignment.centerRight,
                      )
              ],
            ),
            selecttab == tabindex
                ? tabindex == 7
                    ? Container(
                        height: 2,
                        margin: EdgeInsets.only(top: 33, right: 15),
                        color: myColor.blue,
                      )
                    : Container(
                        height: 2,
                        margin: EdgeInsets.only(top: 33),
                        color: myColor.blue,
                      )
                : Container(
                    height: 2,
                    color: Colors.transparent,
                  ),
          ],
        )
      ],
    );
  }

  static Widget AdminTabWidget(String title, int selecttab, int tabindex) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(6),
          child: Text(
            title,
            style: selecttab == tabindex
                ? MyStyles.SemiBold(12, myColor.blue)
                : MyStyles.Medium(12, myColor.text_color),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        selecttab == tabindex
            ? Container(
                height: 3,
                color: myColor.blue,
              )
            : Container(
                height: 3,
                color: Colors.transparent,
              ),
      ],
    );
  }

  static Widget TenantsStutas(String count, String title) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.only(right: 10),
        elevation: 0,
        shadowColor: myColor.application_boreder,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: myColor.TA_Border, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                count,
                style: MyStyles.Bold(25, myColor.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: MyStyles.Medium(14, myColor.statustitle),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget PropertyStutas(String count, String title) {
    return Expanded(
      child: Card(
        margin: EdgeInsets.only(right: 10),
        elevation: 0,
        shadowColor: myColor.application_boreder,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: myColor.TA_Border, width: 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                count,
                style: MyStyles.Bold(25, myColor.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: MyStyles.Medium(14, myColor.statustitle),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget AddNewLead() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            GlobleString.LL_New_Lead,
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AddNewMember() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            GlobleString.TM_New_Member,
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AddNewRequest() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            GlobleString.BT_Man_AddNewRequest,
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AttechDoc() {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: myColor.Circle_main, width: 1.5),
      ),
      child: Text(
        GlobleString.TVD_Upload,
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }

  static Widget DesebleAttechDoc() {
    return Container(
      height: 30,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: myColor.disablecolor, width: 1.5),
      ),
      child: Text(
        GlobleString.TVD_Upload,
        style: MyStyles.Medium(14, myColor.disablecolor),
      ),
    );
  }

  static Widget AttechDocFileView(String file) {
    return file == ""
        ? Expanded(
            child: Text(
              "",
              style: MyStyles.Medium(12, myColor.blue),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          )
        : Expanded(
            child: Text(
              file,
              overflow: TextOverflow.ellipsis,
              style: MyStyles.Medium(12, myColor.blue),
              textAlign: TextAlign.start,
              maxLines: 2,
            ),
          );
  }

  static Widget AttechDocFileCheck(String file) {
    return Container(
      child: file == ""
          ? Container(
              width: 20,
              height: 20,
            )
          : Image.asset(
              "assets/images/ic_circle_check.png",
              width: 20,
              height: 20,
              alignment: Alignment.topLeft,
            ),
    );
  }

  static Widget LenghtOFTenancy(String name, int selected, int index) {
    return Container(
      height: 30,
      width: 150,
      //padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(width: 1, color: myColor.TA_Border),
        color: selected == index ? myColor.TA_tab_text : Colors.transparent,
      ),
      child: Text(
        name,
        style: MyStyles.Medium(
            13, selected == index ? myColor.white : myColor.text_color),
      ),
    );
  }

  static Widget FillButton(double height, String title, bool isActive) {
    return Container(
      height: 35,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: isActive ? myColor.Circle_main : myColor.disablecolor,
      ),
      child: Text(
        title,
        style: MyStyles.Medium(14, myColor.white),
      ),
    );
  }

  static Widget LeaseButton(String name) {
    return Container(
      height: 30,
      width: 120,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: myColor.Circle_main, width: 1.5),
      ),
      child: Text(
        name,
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }

  static Widget SaveAndNext(String name) {
    return Container(
      height: 35,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Text(
        name,
        style: MyStyles.Medium(14, myColor.white),
      ),
    );
  }

  static Widget TenantBackButton() {
    return Container(
      height: 35,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: myColor.Circle_main, width: 1.5),
      ),
      child: Text(
        GlobleString.Back,
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }

  static Widget AddNewProperty() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            GlobleString.PP_Add_New_Property,
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AddEventTypes() {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            'Add Event Type',
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AddNewButton(String title) {
    return Container(
      height: 32,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.Circle_main,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            title,
            style: MyStyles.Regular(14, myColor.white),
          ),
        ],
      ),
    );
  }

  static Widget AddNewButtonFillOut(String title) {
    return Container(
      height: 32,
      width: 176,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: myColor.Circle_main, width: 0.5),
        color: myColor.white,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: myColor.Circle_main,
              size: 20,
            ),
          ),
          Text(
            title,
            style: MyStyles.Medium(14, myColor.Circle_main),
          ),
        ],
      ),
    );
  }

  /*Funnel Status*/
  static Widget FNL_TenancyApplicationStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              "assets/images/ic_fnl_tntapp.png",
              width: 20,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GlobleString.FL_Tenancy_Application,
                style: MyStyles.Medium(13, myColor.text_color),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "1 JAN",
                style: MyStyles.Medium(11, myColor.fnl_status_date),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        CustomeWidget.FNL_STATUS_NOTSTART()
      ],
    );
  }

  static Widget FNL_DocumentVerificationStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              "assets/images/ic_fnl_docvarif.png",
              width: 20,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GlobleString.FL_Document_Verification,
                style: MyStyles.Medium(13, myColor.text_color),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "1 JAN",
                style: MyStyles.Medium(11, myColor.fnl_status_date),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        CustomeWidget.FNL_STATUS_NOTSTART()
      ],
    );
  }

  static Widget FNL_ReferenceChecksStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              "assets/images/ic_fnl_refercheck.png",
              width: 20,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GlobleString.FL_Reference_Checks,
                style: MyStyles.Medium(13, myColor.text_color),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "1 JAN",
                style: MyStyles.Medium(11, myColor.fnl_status_date),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        CustomeWidget.FNL_STATUS_RECEIVE()
      ],
    );
  }

  static Widget FNL_LeaseAgreementStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Image.asset(
              "assets/images/ic_fnl_leaseagree.png",
              width: 20,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                GlobleString.FL_Lease_Agreement,
                style: MyStyles.Medium(13, myColor.text_color),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                "1 JAN",
                style: MyStyles.Medium(11, myColor.fnl_status_date),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        CustomeWidget.FNL_STATUS_SENT()
      ],
    );
  }

  static Widget FNL_STATUS_NOTSTART() {
    return Container(
      height: 25,
      width: 65,
      decoration: BoxDecoration(
        color: myColor.fnl_status_notstart_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_NotStarted,
        style: MyStyles.Medium(10, myColor.fnl_status_notstart),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget FNL_STATUS_RECEIVE() {
    return Container(
      height: 25,
      width: 65,
      decoration: BoxDecoration(
        color: myColor.fnl_status_receive_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_Received,
        style: MyStyles.Medium(10, myColor.fnl_status_receive),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget FNL_STATUS_SENT() {
    return Container(
      height: 25,
      width: 65,
      decoration: BoxDecoration(
        color: myColor.fnl_status_sent_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_Sent,
        style: MyStyles.Medium(10, myColor.fnl_status_sent),
        textAlign: TextAlign.center,
      ),
    );
  }

  /*Table Status*/

  static Widget TBL_TenancyApplicationStatus() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor.TA_status_Border, width: 2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Image.asset(
                      "assets/images/ic_fnl_tntapp.png",
                      width: 18,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GlobleString.FL_Tenancy_Application,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "1 JAN",
                    style: MyStyles.Regular(12, myColor.fnl_status_date),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TBL_STATUS_NOTSTART(),
          ],
        ),
      ),
    );
  }

  static Widget TBL_DocumentVerificationStatus() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor.TA_status_Border, width: 2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Image.asset(
                      "assets/images/ic_fnl_docvarif.png",
                      width: 18,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GlobleString.FL_Document_Verification,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "1 JAN",
                    style: MyStyles.Regular(12, myColor.fnl_status_date),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TBL_STATUS_RECEIVE(),
          ],
        ),
      ),
    );
  }

  static Widget TBL_ReferenceChecksStatus() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor.TA_status_Border, width: 2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Image.asset(
                      "assets/images/ic_fnl_refercheck.png",
                      width: 20,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GlobleString.FL_Reference_Checks,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "1 JAN",
                    style: MyStyles.Regular(12, myColor.fnl_status_date),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TBL_STATUS_SENT(),
          ],
        ),
      ),
    );
  }

  static Widget TBL_LeaseAgreementStatus() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: myColor.white,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: myColor.TA_status_Border, width: 2),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {},
                  child: Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Image.asset(
                      "assets/images/ic_fnl_leaseagree.png",
                      width: 20,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GlobleString.FL_Lease_Agreement,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Text(
                    "1 JAN",
                    style: MyStyles.Regular(12, myColor.fnl_status_date),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            TBL_STATUS_NOTSTART(),
          ],
        ),
      ),
    );
  }

  static Widget TBL_STATUS_NOTSTART() {
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color: myColor.fnl_status_notstart_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_NotStarted,
        style: MyStyles.Medium(12, myColor.fnl_status_notstart),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget TBL_STATUS_RECEIVE() {
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color: myColor.fnl_status_receive_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_Received,
        style: MyStyles.Medium(12, myColor.fnl_status_receive),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget TBL_STATUS_SENT() {
    return Container(
      height: 30,
      width: 80,
      decoration: BoxDecoration(
        color: myColor.fnl_status_sent_bg,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: Text(
        GlobleString.FL_status_Sent,
        style: MyStyles.Medium(12, myColor.fnl_status_sent),
        textAlign: TextAlign.center,
      ),
    );
  }

  static LeaseSigne(BuildContext context, CallBack callback) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return MessageDialogBox(
          buttontitle: GlobleString.LeaseStatus_yes,
          title: GlobleString.LeaseStatus_msg,
          onPressed: () async {
            Navigator.of(context1).pop();
            callback(true);
          },
        );
      },
    );
  }

  static getPropertyDetailsByPropertyID(
      BuildContext context, String propId) async {
    final _store = getIt<AppStore>();

    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getPropertyRestriction(context, propId,
        (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateRestrictionlist(restrictionlist));
        _store.dispatch(UpdateSummeryRestrictionlist(restrictionlist));
      } else {
        _store.dispatch(UpdateRestrictionlist([]));
        _store.dispatch(UpdateSummeryRestrictionlist([]));
      }
    });

    ApiManager().getPropertyImagesDSQ(context, propId,
        (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(UpdatePropertyImageList(PropertyImageMediaInfolist));
        _store.dispatch(
            UpdateSummeryPropertyImageList(PropertyImageMediaInfolist));
      } else {
        _store.dispatch(UpdatePropertyImageList([]));
        _store.dispatch(UpdateSummeryPropertyImageList([]));
      }
    });

    ApiManager().getPropertyAmanityUtility(context, propId,
        (status, responce, amenitieslist, utilitylist) async {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(UpdatePropertyAmenitiesList(amenitieslist));
        _store.dispatch(UpdatePropertyUtilitiesList(utilitylist));
        _store.dispatch(UpdateSummeryPropertyAmenitiesList(amenitieslist));
        _store.dispatch(UpdateSummeryPropertyUtilitiesList(utilitylist));
      } else {
        _store.dispatch(UpdatePropertyAmenitiesList([]));
        _store.dispatch(UpdatePropertyUtilitiesList([]));
        _store.dispatch(UpdateSummeryPropertyAmenitiesList([]));
        _store.dispatch(UpdateSummeryPropertyUtilitiesList([]));
        await ApiManager().getPropertyFeaturelist(context);
      }
    });

    await ApiManager().getPropertyDetails(context, propId,
        (status, responce, propertyData) async {
      if (status) {
        await ApiManager().bindPropertyData(propertyData!);

        AddEditProperty.isValueUpdate = false;
        await Prefs.setBool(PrefsName.PropertyEdit, true);
        await Prefs.setBool(PrefsName.PropertyEditMode, true);
        await Prefs.setString(PrefsName.PropertyID, propId);
        await Prefs.setBool(PrefsName.PropertyAgreeTC, true);

        await Prefs.setBool(PrefsName.PropertyStep1, true);
        await Prefs.setBool(PrefsName.PropertyStep2, true);
        await Prefs.setBool(PrefsName.PropertyStep3, true);

        _store.dispatch(UpdatePropertyForm(4));
        _store.dispatch(UpdateAddEditProperty());

        loader.remove();
      } else {
        loader.remove();
      }
    });
  }

  static FunnelDataCSVFile(BuildContext context, String propertyid) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getPropertyWiseLead(
        context, Prefs.getString(PrefsName.OwnerID), propertyid,
        (status, message, allListData) {
      if (status) {
        loader.remove();
        createFunnelDataCSVFile(allListData);
      } else {
        ToastUtils.showCustomToast(context, GlobleString.Blank_export, false);
        loader.remove();
      }
    });
  }

  static createFunnelDataCSVFile(List<TenancyApplication> allListData) async {
    String csv;
    List<List<dynamic>> csvList = [];

    List csvHeaderTitle = [];
    csvHeaderTitle.add("ID");
    csvHeaderTitle.add("Applicant Name");
    csvHeaderTitle.add("Property Name");
    csvHeaderTitle.add("Rating");
    csvHeaderTitle.add("Application Sent");
    csvHeaderTitle.add("Application Received");
    csvHeaderTitle.add("DocumentS Request Sent");
    csvHeaderTitle.add("Documents Received");
    csvHeaderTitle.add("Questionnaires Sent");
    csvHeaderTitle.add("Questionnaires Received");
    csvHeaderTitle.add("Agreement Sent");
    csvHeaderTitle.add("Agreement Received");
    csvHeaderTitle.add("Application Status");

    csvList.add(csvHeaderTitle);

    for (var data in allListData.toSet()) {
      List row = [];
      row.add(data.id);
      row.add(data.applicantName);
      row.add(data.propertyName);
      row.add(data.rating.toString());
      row.add(data.applicationSentDate);
      row.add(data.applicationReceivedDate);
      row.add(data.docRequestSentDate);
      row.add(data.docReceivedDate);
      row.add(data.referenceRequestSentDate);
      row.add(data.referenceRequestReceivedDate);
      row.add(data.agreementSentDate);
      row.add(data.agreementReceivedDate);
      row.add(data.applicationStatus != null
          ? data.applicationStatus!.displayValue.toString()
          : "");

      csvList.add(row);
    }

    csv = const ListToCsvConverter().convert(csvList);

    String filename = "FunnelLeads_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".csv";

    // prepare
    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;

    html.document.body!.children.add(anchor);
    anchor.click();
  }

  static EditApplicant(BuildContext context, String id) async {
    if (true) {
      await clearTenancyApplicationState();

      await Prefs.setString(PrefsName.TCF_ApplicationID, "");
      await Prefs.setString(PrefsName.TCF_ApplicantID, id);
      await Prefs.setBool(PrefsName.TCF_EditApplicant, true);
      Navigator.of(context).pushNamed(RouteNames.TenancyApplicationform);
    }
  }

  static clearTenancyApplicationState() {
    final _store = getIt<AppStore>();
    _store.dispatch(UpdateTFAdditionalInfoTenancyStartDate(null));
    _store.dispatch(UpdateTFAdditionalInfoisSmoking(false));
    _store.dispatch(UpdateTFAdditionalInfoIspets(false));
    _store.dispatch(UpdateTFAdditionalInfoisVehical(false));
    _store.dispatch(UpdateTFAdditionalInfoComment(""));
    _store.dispatch(UpdateTFAdditionalInfoLenthOfTenancy(null));

    _store.dispatch(UpdateTFPersonPersonID(""));
    _store.dispatch(UpdateTFPersonFirstname(""));
    _store.dispatch(UpdateTFPersonLastname(""));
    _store.dispatch(UpdateTFPersonEmail(""));
    _store.dispatch(UpdateTFPersonPhoneNumber(""));
    _store.dispatch(UpdateTFPersonCountryCode("CA"));
    _store.dispatch(UpdateTFPersonDialCode("+1"));
    _store.dispatch(UpdateTFPersonStory(""));
    _store.dispatch(UpdateTFPersonDateofBirth(null));

    _store.dispatch(UpdateTenacyFormAddress(""));
    _store.dispatch(UpdateTenacyFormIndex(1));

    _store.dispatch(UpdateTFAddOccupantlist(<TenancyAdditionalOccupant>[]));
    _store.dispatch(
        UpdateTFAddLiveServerOccupantlist(<TenancyAdditionalOccupant>[]));
    _store.dispatch(UpdateTFAddOccupantNotApplicable(false));

    _store.dispatch(
        UpdateTFAdditionalReferencelist(<TenancyAdditionalReference>[]));
    _store.dispatch(UpdateTFAdditionalLiveServerReferencelist(
        <TenancyAdditionalReference>[]));
    _store.dispatch(UpdateTFAdditionalReferenceisAutherize(false));
    _store.dispatch(UpdateTFAdditionalReferenceisTermsCondition(false));

    _store.dispatch(UpdateTFCurrenttenantCurrentTenancyID(""));
    _store.dispatch(UpdateTFCurrenttenantCurrentLandLordID(""));
    _store.dispatch(UpdateTFCurrenttenantIsUpdate(true));
    _store.dispatch(UpdateTFCurrenttenantSuiteUnit(""));
    _store.dispatch(UpdateTFCurrenttenantAddress(""));
    _store.dispatch(UpdateTFCurrenttenantCity(""));
    _store.dispatch(UpdateTFCurrenttenantProvince(""));
    _store.dispatch(UpdateTFCurrenttenantPostalcode(""));
    _store.dispatch(UpdateTFCurrenttenantisReference(false));
    _store.dispatch(UpdateTFCurrenttenantFirstname(""));
    _store.dispatch(UpdateTFCurrenttenantLastname(""));
    _store.dispatch(UpdateTFCurrenttenantEmail(""));
    _store.dispatch(UpdateTFCurrenttenantPhonenumber(""));
    _store.dispatch(UpdateTFCurrenttenantCode("CA"));
    _store.dispatch(UpdateTFCurrenttenantDailCode("+1"));
    _store.dispatch(UpdateTFCurrenttenantStartDate(null));
    _store.dispatch(UpdateTFCurrenttenantEndDate(null));

    _store.dispatch(UpdateTFEmploymentothersourceincome(""));
    _store.dispatch(UpdateTFEmploymentlinkedprofile(""));
    _store.dispatch(UpdateTFEmploymentanualincomestatus(null));
    _store.dispatch(UpdateTFEmploymentempstatus(null));
    _store.dispatch(UpdateTFEmploymentEmploymentID(""));
    _store.dispatch(
        UpdateTFEmploymentlistoccupation(<TenancyEmploymentInformation>[]));

    _store.dispatch(UpdateTFAdditionalInfoPetslist(<Pets>[]));
    _store.dispatch(UpdateTFAdditionalInfoVehicallist(<Vehical>[]));
  }

  static FillQuestion(BuildContext context, String id) async {
    if (true) {
      await Prefs.setBool(PrefsName.RC_FillOUT, true);
      await Prefs.setString(PrefsName.RC_Referenceid, id);
      Navigator.of(context).pushNamed(RouteNames.ReferenceQuestionnaire);
    }
  }

  static ReferencePreview(BuildContext context, String id) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ApiManager().getReferenceListApplicantWise(context, id,
        (status, responce, messege) async {
      if (status) {
        loader.remove();
        if (responce.length > 0) {
          List<LeadReference> leaditemlist = <LeadReference>[];
          //leadlist.addAll(responce);

          for (var data in responce.toSet()) {
            if (data.questionnaireReceivedDate != null &&
                data.questionnaireReceivedDate != "") {
              leaditemlist.add(data);
            }
          }

          if (leaditemlist.length > 0) {
            showDialog(
              barrierColor: Colors.black45,
              context: context,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return MultipleReferenceDetailsDialog(
                  onPressedClose: () {
                    Navigator.of(context).pop();
                  },
                  leadlist: leaditemlist,
                );
              },
            );
          }
        } else {
          ToastUtils.showCustomToast(
              context, GlobleString.DCR_No_reference, false);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.DCR_No_reference, false);
      }
    });
  }

  static PropertySummaryImageZip(
      BuildContext context, List<PropertyImageMediaInfo> images) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    webarc.Archive archive = webarc.Archive();
    List<String> namestring = [];
    try {
      for (PropertyImageMediaInfo img in images) {
        try {
          var res = await get(Uri.parse(Weburl.image_API + img.id.toString()),
              headers: {
                'Authorization':
                    'bearer ' + Prefs.getString(PrefsName.userTokan),
                'ApplicationCode': Weburl.API_CODE,
              });

          String filename = Helper.FileName(img.url!);

          String newfilename = Helper.CopyAddFilename(namestring, filename);

          namestring.add(newfilename);

          var file = webarc.ArchiveFile.string(
              newfilename, String.fromCharCodes(res.bodyBytes));

          archive.addFile(file);

          print("file add");
        } catch (e) {}
      }
    } catch (e) {
      print("fileerror: $e");
    }

    webarc.OutputStream stream =
        webarc.OutputStream(byteOrder: webarc.LITTLE_ENDIAN);

    var bytes;
    String zipname = "properties_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString();

    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      webarc.TarEncoder tarEncoder = webarc.TarEncoder();
      bytes = tarEncoder.encode(archive, output: stream);
      zipname += ".tar";
    } else {
      webarc.ZipEncoder encode = webarc.ZipEncoder();
      bytes = encode.encode(
        archive,
        level: webarc.Deflate.DEFAULT_COMPRESSION,
        output: stream,
        modified: DateTime.now(),
      );
      zipname += ".zip";
    }

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(bytes!)}")
      ..setAttribute("download", zipname)
      ..click();
    loader.remove();
  }

  static MaintenancePdfgenerate(
      BuildContext context, MaintenanceDetails maintenanceDetails) async {
    final pdf = pw.Document(
      author: "Silver Home",
      pageMode: PdfPageMode.fullscreen,
      title: "Maintenance Request",
    );

    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");

    pw.MemoryImage companyImage;
    try {
      var res = await get(
          Uri.parse(Weburl.image_API +
              maintenanceDetails.Company_logo!.id.toString()),
          headers: {
            'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
            'ApplicationCode': Weburl.API_CODE,
          });
      companyImage = pw.MemoryImage(res.bodyBytes);
    } catch (e) {
      print("ImageException: $e");
      companyImage = pw.MemoryImage(
          (await rootBundle.load('assets/images/silverhome.png'))
              .buffer
              .asUint8List());
    }

    ssheight = MediaQuery.of(context).size.height;
    sswidth = MediaQuery.of(context).size.width;

    pdf.addPage(
      pw.MultiPage(
          maxPages: 100,
          /* footer: (footercontext) {
          return pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(footercontext.pageNumber.toString(),style: pw.TextStyle(fontSize: 12,color: PdfColors.black))
              ]
          );
        },*/
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.all(10),
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Container(
                  color: PdfColor.fromHex("#FBFBFB"),
                  child: header(maintenanceDetails, companyImage)),
              pw.Padding(
                padding: pw.EdgeInsets.all(15),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    children: [
                      propertyDetails(maintenanceDetails),
                      pw.SizedBox(height: 15),
                      maintenaceRequest(maintenanceDetails),
                      pw.SizedBox(height: 15),
                      contactDetails(maintenanceDetails),
                      pw.SizedBox(height: 15),
                      // vendorDetails(maintenanceDetails),
                      if (maintenanceDetails.maintenanceVendorlist!.length > 0)
                        pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            GlobleString.Mant_view_VendorDetails,
                            style: pw.TextStyle(
                              color: PdfColors.black,
                              font: pw.Font.ttf(font_demi),
                              fontSize: 14,
                            ),
                            textAlign: pw.TextAlign.left,
                          ),
                        ),
                      pw.SizedBox(height: 10),
                      for (int i = 0;
                          i < maintenanceDetails.maintenanceVendorlist!.length;
                          i++)
                        vendorDetailsView(i, maintenanceDetails)
                    ]),
              ),
            ];
          }),
    );

    String filename = "maintenance_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".pdf";

    Uint8List pdfInBytes = await pdf.save();
    webarc.Archive archive = webarc.Archive();
    var pdffile =
        webarc.ArchiveFile.string(filename, String.fromCharCodes(pdfInBytes));
    archive.addFile(pdffile);

    List<String> namestring = [];

    try {
      for (PropertyMaintenanceImages img
          in maintenanceDetails.maintenanceImageslist!) {
        try {
          var res = await get(
              Uri.parse(Weburl.image_API + img.mediaId!.id.toString()),
              headers: {
                'Authorization':
                    'bearer ' + Prefs.getString(PrefsName.userTokan),
                'ApplicationCode': Weburl.API_CODE,
              });

          String filename = Helper.FileName(img.mediaId!.url!);

          String newfilename = Helper.CopyAddFilename(namestring, filename);

          namestring.add(newfilename);

          var file = webarc.ArchiveFile.string(
              newfilename, String.fromCharCodes(res.bodyBytes));
          archive.addFile(file);
        } catch (e) {}
      }
    } catch (e) {
      print("fileerror: $e");
    }

    webarc.OutputStream stream =
        webarc.OutputStream(byteOrder: webarc.LITTLE_ENDIAN);

    String zipname = "maintenance_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString();
    var bytes;
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      webarc.TarEncoder tarEncoder = webarc.TarEncoder();
      bytes = tarEncoder.encode(archive, output: stream);
      zipname += ".tar";
    } else {
      webarc.ZipEncoder encode = webarc.ZipEncoder();
      bytes = encode.encode(
        archive,
        level: webarc.Deflate.DEFAULT_COMPRESSION,
        output: stream,
        modified: DateTime.now(),
      );
      zipname += ".zip";
    }

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(bytes!)}")
      ..setAttribute("download", zipname)
      ..click();
  }

  static pw.Widget header(
      MaintenanceDetails maintenanceDetails, pw.MemoryImage img) {
    // maintenanceDetails.Company_logo.url
    return pw.Container(
      height: 80,
      decoration: pw.BoxDecoration(
        //borderRadius: pw.BorderRadius.circular(0),
        //color: PdfColor.fromInt(0xffFAFAFA),
        color: PdfColor.fromHex("F8F9F9"),
        //border: pw.Border.all(color: PdfColor.fromHex("#979797"), width: 1),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Expanded(
              child: pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Image(
                    img,
                    width: 150,
                  ))),
          pw.Expanded(
            child: pw.Container(
              alignment: pw.Alignment.center,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    GlobleString.Mant_view_MaintenanceRequest,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 13,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Text(
                    maintenanceDetails.RequestName!,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 13,
                    ),
                    textAlign: pw.TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Container(
              alignment: pw.Alignment.centerRight,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Container(
                            height: 25,
                            width: 50,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              GlobleString.Mant_view_Status,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                font: pw.Font.ttf(font_medium),
                                fontSize: 9,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.SizedBox(
                            width: 5,
                          ),
                          pw.Container(
                            height: 25,
                            width: 100,
                            alignment: pw.Alignment.center,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(5),
                              border: pw.Border.all(
                                  color: PdfColor.fromInt(0xFF979797),
                                  width: 1),
                              color: PdfColor.fromHex("#FFFFFF"),
                            ),
                            child: pw.Text(
                              maintenanceDetails.Status != null
                                  ? maintenanceDetails.Status!.displayValue
                                  : "",
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                font: pw.Font.ttf(font_medium),
                                fontSize: 9,
                              ),
                            ),
                          )
                        ],
                      ),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.start,
                        children: [
                          pw.Container(
                            height: 25,
                            width: 50,
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              GlobleString.Mant_view_Priority,
                              style: pw.TextStyle(
                                color: PdfColors.black,
                                font: pw.Font.ttf(font_medium),
                                fontSize: 9,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.SizedBox(
                            width: 5,
                          ),
                          pw.Container(
                            height: 25,
                            width: 100,
                            alignment: pw.Alignment.center,
                            decoration: pw.BoxDecoration(
                              borderRadius: pw.BorderRadius.circular(5),
                              border: pw.Border.all(
                                  color: PdfColor.fromInt(0xff25AFBF),
                                  width: 1),
                              color: PdfColor.fromInt(0xffD5EDEF),
                            ),
                            child: pw.Text(
                              maintenanceDetails.Priority != null
                                  ? maintenanceDetails.Priority!.displayValue
                                  : "",
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xff25AFBF),
                                font: pw.Font.ttf(font_medium),
                                fontSize: 10,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget propertyDetails(MaintenanceDetails mDetailsState) {
    return pw.Container(
      //width: sswidth,
      decoration: pw.BoxDecoration(
        //color: PdfColor.fromInt(0xd6b7485),
        color: PdfColor.fromHex("E5E7E9"),
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Text(
                  GlobleString.Mant_view_PropertyDetails,
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    font: pw.Font.ttf(font_demi),
                    fontSize: 14,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Text(
                  GlobleString.Mant_view_PropertyName +
                      " " +
                      mDetailsState.PropertyName! +
                      "" +
                      (mDetailsState.Suite_Unit!.isNotEmpty
                          ? " - " + mDetailsState.Suite_Unit!
                          : ""),
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    font: pw.Font.ttf(font_medium),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
                pw.SizedBox(
                  height: 5,
                ),
                pw.Text(
                  GlobleString.Mant_view_Address +
                      " " +
                      mDetailsState.Property_Address!,
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    font: pw.Font.ttf(font_medium),
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget maintenaceRequest(MaintenanceDetails mDetailsState) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColor.fromInt(0xFF979797), width: 1.0),
        borderRadius: pw.BorderRadius.circular(0.0),
        color: PdfColors.white,
      ),
      padding: pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text(
            GlobleString.Mant_view_MaintenanceRequestInformation,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_demi),
              fontSize: 12,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.SizedBox(
            height: 10,
          ),
          pw.Text(
            GlobleString.Mant_view_RequestName +
                " " +
                mDetailsState.RequestName!,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_medium),
              fontSize: 10,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
            GlobleString.Mant_view_Category +
                " " +
                (mDetailsState.Category != null
                    ? mDetailsState.Category!.displayValue
                    : ""),
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_medium),
              fontSize: 10,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
            GlobleString.Mant_view_Describetheissue,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_medium),
              fontSize: 10,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.SizedBox(
            height: 5,
          ),
          pw.Text(
            mDetailsState.Describe_Issue!,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_regular),
              fontSize: 9,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.SizedBox(
            height: 10,
          ),
          pw.Text(
            GlobleString.Mant_view_FilesUploaded,
            style: pw.TextStyle(
              color: PdfColors.black,
              font: pw.Font.ttf(font_medium),
              fontSize: 10,
            ),
            textAlign: pw.TextAlign.left,
          ),
          pw.ListView.builder(
            itemCount: mDetailsState.maintenanceImageslist!.length,
            itemBuilder: (pw.Context ctxt, int index) {
              PropertyMaintenanceImages maintenanceimage =
                  mDetailsState.maintenanceImageslist![index];
              return pw.Container(
                margin: pw.EdgeInsets.only(top: 5, bottom: 5),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      maintenanceimage.mediaId != null
                          ? Helper.FileNameWithTime(
                              maintenanceimage.mediaId!.url!)
                          : "",
                      style: pw.TextStyle(
                        color: PdfColors.blue,
                        font: pw.Font.ttf(font_regular),
                        fontSize: 9,
                      ),
                      textAlign: pw.TextAlign.left,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  static pw.Widget contactDetails(MaintenanceDetails mDetailsState) {
    return pw.Container(
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Container(
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(0.0),
                //color: PdfColor.fromInt(0x334b74ff),
                color: PdfColor.fromHex("E9EDFB"),
              ),
              padding: pw.EdgeInsets.all(10),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Text(
                    GlobleString.Mant_view_LandlordContactDetails,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_demi),
                      fontSize: 14,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                  pw.SizedBox(
                    height: 10,
                  ),
                  pw.Text(
                    GlobleString.Mant_view_FullName +
                        " " +
                        mDetailsState.Owner_firstname! +
                        " " +
                        mDetailsState.Owner_lastname!,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 12,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Text(
                    GlobleString.Mant_view_Email +
                        " " +
                        mDetailsState.Owner_email!,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 12,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                  pw.SizedBox(
                    height: 5,
                  ),
                  pw.Text(
                    GlobleString.Mant_view_Phone +
                        " " +
                        mDetailsState.Owner_mobile!,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 12,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          pw.SizedBox(
            width: 10,
          ),
          pw.Expanded(
            child: pw.Container(
              height: 100,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(0.0),
                //color: PdfColor.fromInt(0x14efbb34),
                color: PdfColor.fromHex("FFF9E9"),
              ),
              padding: pw.EdgeInsets.all(10),
              child: mDetailsState.Applicant_ID != ""
                  ? pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Text(
                          GlobleString.Mant_view_TenantContactDetails,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            font: pw.Font.ttf(font_demi),
                            fontSize: 14,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.SizedBox(
                          height: 10,
                        ),
                        pw.Text(
                          GlobleString.Mant_view_FullName +
                              " " +
                              Helper.checkNull(
                                  mDetailsState.Applicant_firstname) +
                              " " +
                              Helper.checkNull(
                                  mDetailsState.Applicant_lastname),
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            font: pw.Font.ttf(font_medium),
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          GlobleString.Mant_view_Email +
                              " " +
                              Helper.checkNull(mDetailsState.Applicant_email),
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            font: pw.Font.ttf(font_medium),
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                        pw.SizedBox(
                          height: 5,
                        ),
                        pw.Text(
                          GlobleString.Mant_view_Phone +
                              " " +
                              Helper.checkNull(mDetailsState.Applicant_mobile),
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            font: pw.Font.ttf(font_medium),
                            fontSize: 12,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    )
                  : pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          GlobleString.Maintenance_property_vacant,
                          style: pw.TextStyle(
                            color: PdfColors.black,
                            font: pw.Font.ttf(font_demi),
                            fontSize: 14,
                          ),
                          textAlign: pw.TextAlign.left,
                        ),
                      ],
                    ),
            ),
          )
        ],
      ),
    );
  }

  static pw.Widget vendorDetailsView(
      int index, MaintenanceDetails mDetailsState) {
    MaintenanceVendor vendordata = mDetailsState.maintenanceVendorlist![index];
    return pw.Container(
      alignment: pw.Alignment.centerLeft,
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            height: 0.5,
            color: PdfColor.fromInt(0xFF979797),
          ),
          pw.Container(
            height: 25,
            margin: pw.EdgeInsets.only(top: 5, bottom: 5),
            alignment: pw.Alignment.center,
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    //width: sswidth / 5,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      vendordata.companyName!,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF010B32),
                        font: pw.Font.ttf(font_demi),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    //width: sswidth / 7,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      vendordata.category != null
                          ? vendordata.category!.displayValue
                          : "",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF010B32),
                        font: pw.Font.ttf(font_demi),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    //width: sswidth / 4,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      vendordata.email!,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF010B32),
                        font: pw.Font.ttf(font_demi),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                pw.Expanded(
                  flex: 1,
                  child: pw.Container(
                    //width: sswidth / 7,
                    padding: pw.EdgeInsets.only(left: 10),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      vendordata.mobileNumber!,
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        color: PdfColor.fromInt(0xFF010B32),
                        font: pw.Font.ttf(font_demi),
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.Container(
            width: sswidth,
            decoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.circular(0.0),
              //color: PdfColor.fromInt(0xd6b7485),
              // color: PdfColor.fromInt(0x1bbfc1c1),
              color: PdfColor.fromHex("E5E7E9"),
            ),
            padding: pw.EdgeInsets.all(10),
            margin: pw.EdgeInsets.only(top: 5, bottom: 10),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  GlobleString.Mant_view_Instructions,
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(0xFF010B32),
                    font: pw.Font.ttf(font_demi),
                    fontSize: 10,
                  ),
                ),
                pw.SizedBox(
                  height: 3,
                ),
                pw.Text(
                  vendordata.Instruction!,
                  textAlign: pw.TextAlign.left,
                  style: pw.TextStyle(
                    color: PdfColor.fromInt(0xFF010B32),
                    font: pw.Font.ttf(font_regular),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if ((mDetailsState.maintenanceVendorlist!.length - 1) < index)
            pw.Container(
              height: 0.5,
              color: PdfColor.fromInt(0xd6b7485),
            )
          else
            pw.Container(
              height: 0.5,
              color: PdfColor.fromInt(0x00000000),
            )
        ],
      ),
    );
  }

  static pw.Widget vendorDetails(MaintenanceDetails mDetailsState) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Text(
          GlobleString.Mant_view_VendorDetails,
          style: pw.TextStyle(
            color: PdfColors.black,
            font: pw.Font.ttf(font_demi),
            fontSize: 14,
          ),
          textAlign: pw.TextAlign.left,
        ),
        pw.SizedBox(
          height: 10,
        ),
        pw.ListView.builder(
          itemCount: mDetailsState.maintenanceVendorlist!.length,
          itemBuilder: (pw.Context ctxt, int index) {
            MaintenanceVendor vendordata =
                mDetailsState.maintenanceVendorlist![index];
            return pw.Container(
              alignment: pw.Alignment.centerLeft,
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Container(
                    height: 0.5,
                    color: PdfColor.fromInt(0xFF979797),
                  ),
                  pw.Container(
                    height: 25,
                    margin: pw.EdgeInsets.only(top: 5, bottom: 5),
                    alignment: pw.Alignment.center,
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      children: [
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            //width: sswidth / 5,
                            padding: pw.EdgeInsets.only(left: 10),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              vendordata.companyName!,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF010B32),
                                font: pw.Font.ttf(font_demi),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            //width: sswidth / 7,
                            padding: pw.EdgeInsets.only(left: 10),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              vendordata.category != null
                                  ? vendordata.category!.displayValue
                                  : "",
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF010B32),
                                font: pw.Font.ttf(font_demi),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Container(
                            //width: sswidth / 4,
                            padding: pw.EdgeInsets.only(left: 10),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              vendordata.email!,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF010B32),
                                font: pw.Font.ttf(font_demi),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Container(
                            //width: sswidth / 7,
                            padding: pw.EdgeInsets.only(left: 10),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              vendordata.mobileNumber!,
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                color: PdfColor.fromInt(0xFF010B32),
                                font: pw.Font.ttf(font_demi),
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  pw.Container(
                    width: sswidth,
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(0.0),
                      color: PdfColor.fromInt(0xd6b7485),
                    ),
                    padding: pw.EdgeInsets.all(10),
                    margin: pw.EdgeInsets.only(top: 5, bottom: 10),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.start,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          GlobleString.Mant_view_Instructions,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFF010B32),
                            font: pw.Font.ttf(font_demi),
                            fontSize: 10,
                          ),
                        ),
                        pw.SizedBox(
                          height: 3,
                        ),
                        pw.Text(
                          vendordata.Instruction!,
                          textAlign: pw.TextAlign.left,
                          style: pw.TextStyle(
                            color: PdfColor.fromInt(0xFF010B32),
                            font: pw.Font.ttf(font_regular),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((mDetailsState.maintenanceVendorlist!.length - 1) < index)
                    pw.Container(
                      height: 0.5,
                      color: PdfColor.fromInt(0xd6b7485),
                    )
                  else
                    pw.Container(
                      height: 0.5,
                      color: PdfColor.fromInt(0x00000000),
                    )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
