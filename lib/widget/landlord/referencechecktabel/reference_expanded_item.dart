import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_dialog_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_questionnaire_details_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/emailtemplet/referencerequest_dialogbox.dart';
import 'package:silverhome/widget/Landlord/reference_dialog/reference_details_dialog.dart';
import 'package:silverhome/widget/message_dialogbox.dart';

import '../../searchdropdown/dropdown_search.dart';
import '../customewidget.dart';

class ReferenceExpandedItem extends StatefulWidget {
  final VoidCallback _callbackback;
  List<LeadReference> listdata;
  TenancyApplication referencedata;

  ReferenceExpandedItem({
    required List<LeadReference> listdata1,
    required TenancyApplication referencedata,
    required VoidCallback onPressed,
  })  : listdata = listdata1,
        referencedata = referencedata,
        _callbackback = onPressed;

  @override
  _ReferenceExpandedItemState createState() => _ReferenceExpandedItemState();
}

class _ReferenceExpandedItemState extends State<ReferenceExpandedItem> {
  static List<String> statuslist = [];
  String statusValue = "";
  final _store = getIt<AppStore>();
  double height = 0, width = 0;

  @override
  void initState() {
    statuslist.clear();
    statuslist.add(GlobleString.SendToReference);
    statuslist.add(GlobleString.FillOutManually);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return ListviewBuid(widget.listdata);
  }

  Widget ListviewBuid(List<LeadReference> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: Colors.transparent,
        thickness: 0,
        height: 0,
      ),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Row(
          children: [
            Container(
              height: 40,
              color: Colors.transparent,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[Index], Index),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _tableData(LeadReference model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueName(model.referenceName!));
    result.add(_datavalueRelationship(model.relationship!));
    result.add(_datavaluePhoneNumber(model.phoneNumber!));
    result.add(_datavalueEmail(model.toEmail!));
    result.add(_datavalueSentDate(model));
    result.add(_datavalueReceiveDate(model.questionnaireReceivedDate!));

    if (model.questionnaireReceivedDate != null &&
        model.questionnaireReceivedDate != "") {
      result.add(
          _datavalueTitleClickWithWidth("View Response", 160, model, Index));
    } else {
      result.add(_reviewstatusdropdown(model, Index));
    }
    if (model.questionnaireReceivedDate != null &&
        model.questionnaireReceivedDate != "") {
      result.add(_datavalueEdit("Edit", 50, model, Index));
    } else {
      result.add(_datavalueNon("", 50));
    }

    return result;
  }

  Widget _datavalueTitleClickWithWidth(
      String text, double widthv, LeadReference model, int Index) {
    return InkWell(
      onTap: () {
        _dailogReferenceQuestionSingle(model.referenceId.toString());
      },
      child: Container(
        height: 40,
        width: widthv,
        padding: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _reviewstatusdropdown(LeadReference model, int Index) {
    return Container(
      height: 28,
      width: 160,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      // ignore: missing_required_param
      child: DropdownSearch<String>(
        mode: Mode.MENU,
        popupBackgroundColor: myColor.white,
        defultHeight: 100,
        showSelectedItems: true,
        items: statuslist,
        textstyle: MyStyles.Medium(12, myColor.Circle_main),
        //label: "Menu mode",
        hint: GlobleString.CheckReference,
        showSearchBox: false,
        selectedItem:
            statusValue != "" ? statusValue : GlobleString.CheckReference,
        isFilteredOnline: true,
        onChanged: (value) {
          statusValue = value!;
          if (value.contains(GlobleString.SendToReference)) {
            _dailogRequestReference(model, Index);
          } else {
            CustomeWidget.FillQuestion(context, model.referenceId.toString());
          }
        },
      ),
    );
  }

  Widget _datavalueEdit(
      String text, double widthv, LeadReference model, int Index) {
    return InkWell(
      onTap: () {
        CustomeWidget.FillQuestion(context, model.referenceId.toString());
      },
      child: Container(
        height: 40,
        width: widthv,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        color: Colors.transparent,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueNon(String text, double widthv) {
    return Container(
      height: 40,
      width: widthv,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.blue),
      ),
    );
  }

  Widget _datavalueName(String text) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Tooltip(
        message: text,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: MyStyles.Medium(12, myColor.Circle_main),
        ),
      ),
    );
  }

  Widget _datavalueRelationship(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Tooltip(
        message: text,
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          textAlign: TextAlign.start,
          style: MyStyles.Medium(12, myColor.Circle_main),
        ),
      ),
    );
  }

  Widget _datavaluePhoneNumber(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueEmail(String text) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueSentDate(LeadReference model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        model.questionnaireSentDate != null && model.questionnaireSentDate != ""
            ? new DateFormat("dd-MMM-yyyy")
                .format(DateTime.parse(model.questionnaireSentDate.toString()))
                .toString()
            : model.questionnaireReceivedDate != null &&
                    model.questionnaireReceivedDate != ""
                ? "N/A"
                : "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueReceiveDate(String text) {
    return Container(
      height: 40,
      width: width / 7,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      color: Colors.transparent,
      child: Text(
        text != null && text != ""
            ? new DateFormat("dd-MMM-yyyy")
                .format(DateTime.parse(text))
                .toString()
            : "",
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  _dailogRequestReference(LeadReference dmodel, int Index) async {
    LeadReference model = dmodel;
    model.check = false;
    List<LeadReference> tenancyleadlist = <LeadReference>[];
    tenancyleadlist.add(model);

    _store.dispatch(UpdateRCDisAllCheck(false));

    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ReferenceRequestDialogbox(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedSave: () {
            Navigator.of(context).pop();
            _showSuceessReferenceRequest();
          },
          leadReferenceitems: tenancyleadlist,
          applicantionId: widget.referencedata.id.toString(),
          applicantionname: widget.referencedata.applicantName.toString(),
        );
      },
    );
  }

  _showSuceessReferenceRequest() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          title: GlobleString.DCR_success,
          onPressed: () async {
            Navigator.of(context).pop();

            referencecallApi();
          },
          buttontitle: GlobleString.DCR_success_close,
        );
      },
    );
  }

  referencecallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateLLRCisloding(true));
    _store.dispatch(UpdateLLRCReferenceCheckslist(<TenancyApplication>[]));
    _store
        .dispatch(UpdateLLRCfilterReferenceCheckslist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "4";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getApplicantReferenceCheckList(context, filterjson);
  }

  _dailogReferenceQuestionSingle(String referenceId) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ClearAllState();

    ApiManager().getReferenceDetailsAPISingle(context, referenceId,
        (status, responce) {
      if (status) {
        loader.remove();

        showDialog(
          barrierColor: Colors.black45,
          context: context,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return ReferenceDetailsDialog(
              onPressedClose: () {
                Navigator.of(context).pop();
              },
            );
          },
        );
      } else {
        Helper.Log("respoce", responce);
        loader.remove();
      }
    });
  }

  ClearAllState() {
    _store.dispatch(UpdateRQDetailsLenthTenancy(1));
    _store.dispatch(UpdateRQDetailsCleanlinessRating(0));
    _store.dispatch(UpdateRQDetailsCommunicationRating(0));
    _store.dispatch(UpdateRQDetailsRespectfulnessRating(0));
    _store.dispatch(UpdateRQDetailsPaymentPunctualityRating(0));
    _store.dispatch(UpdateRQDetailsYesNo(false));
    _store.dispatch(UpdateRQDetailsReasonDeparture(""));
    _store.dispatch(UpdateRQDetailsOtherComments(""));
    _store.dispatch(UpdateRQDetailsPropertyName(""));
    _store.dispatch(UpdateRQDetailsApplicantName(""));
    _store.dispatch(UpdateRQDetailsReferenceName(""));
    _store.dispatch(UpdateRQDetailsReferenceRelationShip(""));
    _store.dispatch(UpdateRQDetailsReferenceEmail(""));
    _store.dispatch(UpdateRQDetailsReferencePhone(""));
  }
}
