import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/editlead_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/emailtemplet/documentrequest_dialogbox.dart';
import 'package:silverhome/widget/Landlord/emailtemplet/invitetoapply_dialogbox.dart';
import 'package:silverhome/widget/Landlord/emailtemplet/referencerequest_dialogbox.dart';
import 'package:silverhome/widget/Landlord/funnelview/active_tenant_cardview_widget.dart';
import 'package:silverhome/widget/Landlord/funnelview/applicant_cardview_widget.dart';
import 'package:silverhome/widget/Landlord/funnelview/lead_cardview_widget.dart';
import 'package:silverhome/widget/Landlord/funnelview/reference_checked_cardview_widget.dart';
import 'package:silverhome/widget/Landlord/lead_dialog/editlead_dialogbox.dart';
import 'package:silverhome/widget/Landlord/reference_dialog/check_reference_confirm_dialog.dart';
import 'package:silverhome/widget/Landlord/reference_dialog/check_reference_list_dialog.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/emailtemplet/leasesend_dialogbox.dart';
import 'package:silverhome/widget/landlord/lead_dialog/leadinfo_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

import '../../../presentation/models/landlord_models/funnelview_state.dart';
import '../customewidget.dart';
import '../preview_Lease_dialogbox.dart';
import '../preview_documents_dialogbox.dart';
import '../ratingupdate_dialogbox.dart';
import 'document_varified_cardview_widget.dart';
import 'lease_sent_cardview_widget.dart';

class FunnelViewScreen extends StatefulWidget {
  PropertyData? selectpropertyValue;

  FunnelViewScreen({
    PropertyData? propertyValue,
  }) : selectpropertyValue = propertyValue;

  @override
  _FunnelViewScreenState createState() => _FunnelViewScreenState();
}

class _FunnelViewScreenState extends State<FunnelViewScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  ScrollController? _controller;
  late OverlayEntry loader;

  @override
  void initState() {
    _controller = ScrollController();
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();
    finnleviewcallapi();
  }

  finnleviewcallapi() async {
    if (widget.selectpropertyValue != null) {
      await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);

      FilterReqtokens reqtokens = new FilterReqtokens();
      reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
      reqtokens.IsArchived = "0";
      reqtokens.Prop_ID = widget.selectpropertyValue!.ID!;

      FilterData filterData = new FilterData();
      filterData.DSQID = Weburl.DSQ_CommonView;
      filterData.LoadLookupValues = true;
      filterData.LoadRecordInfo = true;
      filterData.Reqtokens = reqtokens;

      String filterjson = jsonEncode(filterData);

      await ApiManager().getPropertyWiseFunnel(context, filterjson);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 222,
      margin: EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), border: Border.all(color: Colors.transparent, width: 1)),
      child: widget.selectpropertyValue != null
          ? Container(
              width: width,
              height: height - 222,
              child: SingleChildScrollView(
                primary: false,
                scrollDirection: Axis.horizontal,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _leadView(),
                      _applicantView(),
                      _docmentvarifyView(),
                      _referencescheckedView(),
                      _leasesentView(),
                      _activetenantView(),
                    ],
                  ),
                ),
              ),
            )
          : Container(
              width: width,
              decoration: BoxDecoration(color: myColor.white),
              alignment: Alignment.topCenter,
              child: Text(
                GlobleString.Blank_funnel,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: MyStyles.Medium(14, myColor.navy_blue),
              ),
            ),
    );
  }

  Widget _leadView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(right: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient1, myColor.linear_gradient2],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_Lead, funnelviewstate!.lead_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.leadlist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return LeadCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.leadlist[Index],
                        onNext: (int index) {
                          TenancyApplication lead = funnelviewstate.leadlist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().Applicant.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onPrevious: (int index) {},
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.leadlist[Index];

                          OpenRetingDialog(lead);
                        },
                        callbackInvite: () {
                          _dailogInviteApply(funnelviewstate.leadlist[Index]);
                        },
                        callbackLeadInfo: () {
                          _dailogOpenLeadInfo(funnelviewstate.leadlist[Index]);
                        },
                        callbackEditLead: () {
                          _dailogOpenEditLead(funnelviewstate.leadlist[Index]);
                        },
                        callbackArchive: () {
                          _dailogSetArchive(funnelviewstate.leadlist[Index]);
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.leadlist[Index].applicationReceivedDate != null &&
                              funnelviewstate.leadlist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.leadlist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.leadlist[Index].agreementReceivedDate != null &&
                              funnelviewstate.leadlist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.leadlist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.leadlist[Index].docRequestSentDate != null &&
                              funnelviewstate.leadlist[Index].docRequestSentDate != "" &&
                              funnelviewstate.leadlist[Index].docReceivedDate != null &&
                              funnelviewstate.leadlist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.leadlist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.leadlist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.leadlist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.leadlist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _applicantView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient2, myColor.linear_gradient3],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_Applicants, funnelviewstate!.applicant_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.applicantlist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return ApplicantCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.applicantlist[Index],
                        onNext: (int index) {
                          TenancyApplication lead = funnelviewstate.applicantlist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().DocVarify.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onPrevious: (int index) {
                          TenancyApplication lead = funnelviewstate.applicantlist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().Lead.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.applicantlist[Index];

                          OpenRetingDialog(lead);
                        },
                        onPressedRequestdocuments: () {
                          _dailogRequestDocument(funnelviewstate.applicantlist[Index]);
                        },
                        onPressedEditapplicant: () {
                          CustomeWidget.EditApplicant(context, funnelviewstate.applicantlist[Index].applicantId.toString());
                        },
                        onPressedArchive: () {
                          _dailogSetArchive(funnelviewstate.applicantlist[Index]);
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.applicantlist[Index].applicationReceivedDate != null &&
                              funnelviewstate.applicantlist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.applicantlist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.applicantlist[Index].agreementReceivedDate != null &&
                              funnelviewstate.applicantlist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.applicantlist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.applicantlist[Index].docRequestSentDate != null &&
                              funnelviewstate.applicantlist[Index].docRequestSentDate != "" &&
                              funnelviewstate.applicantlist[Index].docReceivedDate != null &&
                              funnelviewstate.applicantlist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.applicantlist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.applicantlist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.applicantlist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.applicantlist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _docmentvarifyView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient3, myColor.linear_gradient4],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_Documents_Varified, funnelviewstate!.documentvarify_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.documentvarifylist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return DocumentVarifiedCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.documentvarifylist[Index],
                        onNext: (int index) {
                          TenancyApplication lead = funnelviewstate.documentvarifylist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().ReferenceCheck.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onPrevious: (int index) {
                          TenancyApplication lead = funnelviewstate.documentvarifylist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().Applicant.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.documentvarifylist[Index];

                          OpenRetingDialog(lead);
                        },
                        onPressedCheckReferences: () {
                          TenancyApplication lead = funnelviewstate.documentvarifylist[Index];

                          _dailogReferenceConfirmDialog(lead);
                        },
                        onPressedEditapplicant: () {
                          CustomeWidget.EditApplicant(context, funnelviewstate.documentvarifylist[Index].applicantId.toString());
                        },
                        onPressedArchive: () {
                          _dailogSetArchive(funnelviewstate.documentvarifylist[Index]);
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.documentvarifylist[Index].applicationReceivedDate != null &&
                              funnelviewstate.documentvarifylist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.documentvarifylist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.documentvarifylist[Index].agreementReceivedDate != null &&
                              funnelviewstate.documentvarifylist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.documentvarifylist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.documentvarifylist[Index].docRequestSentDate != null &&
                              funnelviewstate.documentvarifylist[Index].docRequestSentDate != "" &&
                              funnelviewstate.documentvarifylist[Index].docReceivedDate != null &&
                              funnelviewstate.documentvarifylist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.documentvarifylist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.documentvarifylist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.documentvarifylist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.documentvarifylist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _referencescheckedView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient4, myColor.linear_gradient5],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_References_Checked, funnelviewstate!.referencecheck_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.referencechecklist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return ReferenceCheckedCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.referencechecklist[Index],
                        onNext: (int index) {
                          TenancyApplication lead = funnelviewstate.referencechecklist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().LeaseSent.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onPrevious: (int index) {
                          TenancyApplication lead = funnelviewstate.referencechecklist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().DocVarify.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.referencechecklist[Index];

                          OpenRetingDialog(lead);
                        },
                        onPressedSendLease: () {
                          _dialogSendLeaseRequest(funnelviewstate.referencechecklist[Index]);
                        },
                        onPressedEditapplicant: () {
                          CustomeWidget.EditApplicant(context, funnelviewstate.referencechecklist[Index].applicantId.toString());
                        },
                        onPressedArchive: () {
                          _dailogSetArchive(funnelviewstate.referencechecklist[Index]);
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.referencechecklist[Index].applicationReceivedDate != null &&
                              funnelviewstate.referencechecklist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.referencechecklist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.referencechecklist[Index].agreementReceivedDate != null &&
                              funnelviewstate.referencechecklist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.referencechecklist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.referencechecklist[Index].docRequestSentDate != null &&
                              funnelviewstate.referencechecklist[Index].docRequestSentDate != "" &&
                              funnelviewstate.referencechecklist[Index].docReceivedDate != null &&
                              funnelviewstate.referencechecklist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.referencechecklist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.referencechecklist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.referencechecklist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.referencechecklist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _leasesentView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient5, myColor.linear_gradient6],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_Lease_Sent, funnelviewstate!.leasesent_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.leasesentlist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return LeaseSentCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.leasesentlist[Index],
                        onNext: (int index) {
                          TenancyApplication lead = funnelviewstate.leasesentlist[Index];
                          _dailogSetActiveTenant(lead);
                        },
                        onPrevious: (int index) {
                          TenancyApplication lead = funnelviewstate.leasesentlist[Index];

                          ApiManager().funUpdateStatus(
                              context, lead.id.toString(), eApplicationStatus().ReferenceCheck.toString(), widget.selectpropertyValue!.ID!,
                              (status, responce) async {
                            if (status) {}
                          });
                        },
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.leasesentlist[Index];

                          OpenRetingDialog(lead);
                        },
                        onPressedActivateTenant: () {
                          TenancyApplication lead = funnelviewstate.leasesentlist[Index];
                          _dailogSetActiveTenant(lead);
                        },
                        onPressedEditapplicant: () {
                          CustomeWidget.EditApplicant(context, funnelviewstate.leasesentlist[Index].applicantId.toString());
                        },
                        onPressedArchive: () {
                          _dailogSetArchive(funnelviewstate.leasesentlist[Index]);
                        },
                        onPressedPreviewLease: () {
                          TenancyApplication model = funnelviewstate.leasesentlist[Index];
                          if (model.agreementReceivedDate != null && model.agreementReceivedDate != "") {
                            _dailogPreviewLease(model);
                          } else {
                            ToastUtils.showCustomToast(context, GlobleString.lease_not_available, false);
                          }
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.leasesentlist[Index].applicationReceivedDate != null &&
                              funnelviewstate.leasesentlist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.leasesentlist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.leasesentlist[Index].agreementReceivedDate != null &&
                              funnelviewstate.leasesentlist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.leasesentlist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.leasesentlist[Index].docRequestSentDate != null &&
                              funnelviewstate.leasesentlist[Index].docRequestSentDate != "" &&
                              funnelviewstate.leasesentlist[Index].docReceivedDate != null &&
                              funnelviewstate.leasesentlist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.leasesentlist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.leasesentlist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.leasesentlist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.leasesentlist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _activetenantView() {
    return ConnectState<FunnelViewState>(
        map: (state) => state.funnelViewState,
        where: notIdentical,
        builder: (funnelviewstate) {
          return Container(
            width: 300,
            margin: EdgeInsets.only(left: 5),
            decoration: BoxDecoration(color: myColor.FV_Background),
            child: Column(
              children: [
                Container(
                  height: 3,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.topRight,
                      colors: [myColor.linear_gradient6, myColor.linear_gradient7],
                      //tileMode: TileMode.repeated,
                    ),
                  ),
                ),
                CustomeWidget.FunnelCountBox(GlobleString.FVH_Active_Tenant, funnelviewstate!.activetenent_count.toString()),
                Container(
                  height: height - 268,
                  margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: funnelviewstate.activetenantlist.length,
                    itemBuilder: (BuildContext ctxt, int Index) {
                      return ActiveTenantCardViewWidget(
                        alllistdata: funnelviewstate.alllistdata,
                        pos: Index,
                        dmodel1: funnelviewstate.activetenantlist[Index],
                        onNext: (int index) {},
                        onPrevious: (int index) {
                          TenancyApplication lead = funnelviewstate.activetenantlist[Index];

                          _dailogRemoveActiveTenant(lead);

                          /*   ApiManager().funUpdateStatus(
                              context,
                              lead.id.toString(),
                              eApplicationStatus().LeaseSent.toString(),
                              widget.selectpropertyValue!.ID!,
                                  (status, responce) async {
                                if (status) {
                                  ApiManager().updateTenancyStatusCount(context);
                                }
                              });*/
                        },
                        onRating: (int index) {
                          TenancyApplication lead = funnelviewstate.activetenantlist[Index];

                          OpenRetingDialog(lead);
                        },
                        onPressedACArchive: () {
                          //_dailogSetArchiveActiveTenant(funnelviewstate.activetenantlist[Index]);
                          _dailogTerminanteTenant(funnelviewstate.activetenantlist[Index]);
                        },
                        onPressedInviteTenant: () {
                          _dailogTenantInvite(funnelviewstate.activetenantlist[Index]);
                        },
                        onPressedACEditTenet: () {
                          CustomeWidget.EditApplicant(context, funnelviewstate.activetenantlist[Index].applicantId.toString());
                        },
                        callbackTenancyApplicationIcon: () {
                          if (funnelviewstate.activetenantlist[Index].applicationReceivedDate != null &&
                              funnelviewstate.activetenantlist[Index].applicationReceivedDate != "") {
                            openTenancyApplicationDetails(funnelviewstate.activetenantlist[Index], funnelviewstate);
                          }
                        },
                        callbackLeaseAgreementIcon: () {
                          if (funnelviewstate.activetenantlist[Index].agreementReceivedDate != null &&
                              funnelviewstate.activetenantlist[Index].agreementReceivedDate != "") {
                            _dailogPreviewLease(funnelviewstate.activetenantlist[Index]);
                          }
                        },
                        callbackDocumentVerificationIcon: () {
                          if (funnelviewstate.activetenantlist[Index].docRequestSentDate != null &&
                              funnelviewstate.activetenantlist[Index].docRequestSentDate != "" &&
                              funnelviewstate.activetenantlist[Index].docReceivedDate != null &&
                              funnelviewstate.activetenantlist[Index].docReceivedDate != "") {
                            _dailogPreviewDoc(funnelviewstate.activetenantlist[Index]);
                          }
                        },
                        callbackReferenceChecksIcon: () {
                          if (funnelviewstate.activetenantlist[Index].referenceRequestReceivedDate != null &&
                              funnelviewstate.activetenantlist[Index].referenceRequestReceivedDate != "") {
                            CustomeWidget.ReferencePreview(context, funnelviewstate.activetenantlist[Index].id.toString());
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  OpenRetingDialog(TenancyApplication lead) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return RatingUpdateDialogBox(
          title: "",
          ratingcomment: lead.note!,
          positiveText: GlobleString.DLR_Save,
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
          ratingset: lead.rating!,
          onPressedYes: (double rating, String ratingraview) async {
            TenancyApplicationID updateid = new TenancyApplicationID();
            updateid.ID = lead.applicantId.toString();

            TenancyApplicationUpdateRating updaterating = new TenancyApplicationUpdateRating();
            updaterating.Rating = rating;
            updaterating.Note = ratingraview;

            await ApiManager().UpdateRatingApplication(context, updateid, updaterating, (status, responce) async {
              if (status) {
                if (widget.selectpropertyValue != null) {
                  await finnleviewcallapi();
                }
              }
            });

            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  _dailogSetArchive(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogBox(
          title: GlobleString.ARC_delete_msg,
          positiveText: GlobleString.ARC_delete_yes,
          negativeText: GlobleString.ARC_delete_NO,
          onPressedYes: () async {
            Navigator.of(context).pop();

            TenancyApplicationID updateid = new TenancyApplicationID();
            updateid.ID = model.id.toString();

            TenancyApplicationUpdateArchive updateArchive = new TenancyApplicationUpdateArchive();
            updateArchive.IsArchived = "1";

            await ApiManager().UpdateArchiveApplication(context, updateid, updateArchive, (status, responce) async {
              if (status) {
                if (widget.selectpropertyValue != null) {
                  await finnleviewcallapi();
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _dailogSetArchiveActiveTenant(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.Button_OK,
          title: GlobleString.ARC_ACTenant_msg,
          onPressed: () async {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  _dailogTerminanteTenant(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogBox(
          title: GlobleString.ARC_terminante_msg,
          negativeText: GlobleString.ARC_terminante_NO,
          positiveText: GlobleString.ARC_terminante_yes,
          onPressedYes: () {
            Navigator.of(context).pop();
            terminateTenant(model);
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  terminateTenant(TenancyApplication model) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().terminateTenancyWorkflow(context, model.applicantId.toString(), (status, responce) async {
      if (status) {
        loader.remove();
        await finnleviewcallapi();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  openTenancyApplicationDetails(TenancyApplication lead, FunnelViewState funnelViewState) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < funnelViewState.alllistdata.length; i++) {
      if (funnelViewState.alllistdata[i].applicationSentDate != null &&
          funnelViewState.alllistdata[i].applicationSentDate != "" &&
          funnelViewState.alllistdata[i].applicationReceivedDate != null &&
          funnelViewState.alllistdata[i].applicationReceivedDate != "") {
        listdataviewlist.add(funnelViewState.alllistdata[i]);
      }

      if (funnelViewState.alllistdata.length - 1 == i) {
        listdataviewlist.remove(lead);
        listdataviewlist.insert(0, lead);

        _store.dispatch(UpdateTenancyDetails(listdataviewlist));
      }
    }
  }

  _dailogPreviewDoc(TenancyApplication model) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PreviewDocumentsDialogBox(
          onPressedYes: () async {
            Navigator.of(context).pop();
            await finnleviewcallapi();
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
          Applicantid: model.applicantId.toString(),
          ApplicantionId: model.id.toString(),
        );
      },
    );
  }

  _dailogPreviewLease(TenancyApplication model) {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PreviewLeaseDialogBox(
          onPressedYes: () async {
            Navigator.of(context).pop();
            _dailogSetActiveTenant(model);
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
          Applicantid: model.applicantId.toString(),
          ApplicantionId: model.id.toString(),
        );
      },
    );
  }

  _dailogInviteApply(TenancyApplication dmodel) async {
    List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];
    tenancyleadlist.add(dmodel);

    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return InviteToApplyDialogbox(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedSave: () {
            Navigator.of(context).pop();
            _showSuceessInviteDialog();
          },
          tenancyleadlist: tenancyleadlist,
        );
      },
    );
  }

  _showSuceessInviteDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.DIA_Invite_success_finish,
          title: GlobleString.DIA_Invite_success1,
          onPressed: () async {
            Navigator.of(context).pop();

            await finnleviewcallapi();
          },
        );
      },
    );
  }

  _dailogRequestDocument(TenancyApplication dmodel) async {
    List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];
    tenancyleadlist.add(dmodel);

    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return DocumentRequestDialogbox(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedSave: () {
            Navigator.of(context).pop();
            _showSuceessRequestDocument();
          },
          tenancyleadlist: tenancyleadlist,
        );
      },
    );
  }

  _showSuceessRequestDocument() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.dailog_finish,
          title: GlobleString.DDQ_DocRequest_success,
          onPressed: () async {
            Navigator.of(context).pop();
            await finnleviewcallapi();
          },
        );
      },
    );
  }

  _dailogOpenLeadInfo(TenancyApplication model) {
    _store.dispatch(UpdateEditLeadPersionId(""));
    _store.dispatch(UpdateEditLeadFirstname(""));
    _store.dispatch(UpdateEditLeadLastname(""));
    _store.dispatch(UpdateEditLeadEmail(""));
    _store.dispatch(UpdateEditLead_Occupant("0"));
    _store.dispatch(UpdateEditLead_Children("0"));
    _store.dispatch(UpdateEditLeadPhoneNumber(""));
    _store.dispatch(UpdateEditLeadCountryCode("CA"));
    _store.dispatch(UpdateEditLeadCountryDialCode("+1"));
    _store.dispatch(UpdateEditLeadNotes(""));
    _store.dispatch(UpdateEditLeadApplicantid(""));
    _store.dispatch(UpdateEditLeadApplicantionId(""));
    _store.dispatch(UpdateEditLeadProperty(null));

    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getEditLeadDataAPI(context, model.applicantId.toString(), (status, responce) {
      if (status) {
        ApiManager().getPropertyDetails(context, model.propId!, (status, responce, propertyData) async {
          if (status) {
            loader.remove();

            _store.dispatch(UpdateEditLeadProperty(propertyData));

            showDialog(
              context: context,
              barrierColor: Colors.black45,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context1) {
                return LeadInfoDialogBox(
                  onPressedSave: () async {
                    Navigator.of(context1).pop();
                  },
                  onPressedClose: () {
                    Navigator.of(context1).pop();
                  },
                  applicantid: model.applicantId.toString(),
                );
              },
            );
          } else {
            loader.remove();
          }
        });

        loader.remove();
      } else {
        loader.remove();
        Helper.Log("respoce", responce);
      }
    });
  }

  _dailogOpenEditLead(TenancyApplication model) {
    _store.dispatch(UpdateEditLeadPersionId(""));
    _store.dispatch(UpdateEditLeadFirstname(""));
    _store.dispatch(UpdateEditLeadLastname(""));
    _store.dispatch(UpdateEditLeadEmail(""));
    _store.dispatch(UpdateEditLead_Occupant("0"));
    _store.dispatch(UpdateEditLead_Children("0"));
    _store.dispatch(UpdateEditLeadPhoneNumber(""));
    _store.dispatch(UpdateEditLeadCountryCode("CA"));
    _store.dispatch(UpdateEditLeadCountryDialCode("+1"));
    _store.dispatch(UpdateEditLeadNotes(""));
    _store.dispatch(UpdateEditLeadApplicantid(""));
    _store.dispatch(UpdateEditLeadApplicantionId(""));
    _store.dispatch(UpdateEditLeadProperty(null));

    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().getEditLeadDataAPI(context, model.applicantId.toString(), (status, responce) {
      if (status) {
        ApiManager().getPropertyDetails(context, model.propId!, (status, responce, propertyData) async {
          if (status) {
            loader.remove();

            _store.dispatch(UpdateEditLeadProperty(propertyData));

            showDialog(
              context: context,
              barrierColor: Colors.black45,
              useSafeArea: true,
              barrierDismissible: false,
              builder: (BuildContext context1) {
                return EditLeadDialogBox(
                  onPressedSave: () async {
                    Navigator.of(context1).pop();
                    await finnleviewcallapi();
                  },
                  onPressedClose: () {
                    Navigator.of(context1).pop();
                  },
                  applicantid: model.applicantId.toString(),
                );
              },
            );
          } else {
            loader.remove();
          }
        });
      } else {
        loader.remove();
        Helper.Log("respoce", responce);
      }
    });
  }

  _dailogReferenceConfirmDialog(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CheckReferenceConfirmDialog(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedFillOutManually: () {
            Navigator.of(context).pop();
            _dailogCheckReferenceFillOutManiual(model);
          },
          onPressedSendQuestionnaire: () {
            Navigator.of(context).pop();
            _dailogRequestReference(model);
          },
        );
      },
    );
  }

  _dailogCheckReferenceFillOutManiual(TenancyApplication model) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ApiManager().getReferenceListApplicantWise(context, model.id.toString(), (status, responce, messege) async {
      if (status) {
        loader.remove();
        if (responce.length > 0) {
          showDialog(
            barrierColor: Colors.black45,
            context: context,
            useSafeArea: true,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return CheckReferenceListDialog(
                onPressedClose: () {
                  Navigator.of(context).pop();
                },
                applicantionname: model.applicantName.toString(),
                referencelist: responce,
              );
            },
          );
        } else {
          ToastUtils.showCustomToast(context, GlobleString.DCR_No_reference, false);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.DCR_No_reference, false);
      }
    });
  }

  _dailogRequestReference(TenancyApplication model) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    await ApiManager().getReferenceListApplicantWise(context, model.id.toString(), (status, responce, messege) async {
      if (status) {
        loader.remove();
        if (responce.length > 0) {
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
                leadReferenceitems: responce,
                applicantionId: model.id.toString(),
                applicantionname: model.applicantName.toString(),
              );
            },
          );
        } else {
          ToastUtils.showCustomToast(context, GlobleString.DCR_No_reference, false);
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, GlobleString.DCR_No_reference, false);
      }
    });
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
            await finnleviewcallapi();
          },
          buttontitle: GlobleString.DCR_success_close,
        );
      },
    );
  }

  _dialogSendLeaseRequest(TenancyApplication datalead) {
    List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];
    tenancyleadlist.add(datalead);

    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LeaseSendDialogbox(
          onPressedClose: () {
            Navigator.of(context).pop();
          },
          onPressedSave: () {
            Navigator.of(context).pop();
            _showSuceessLeaseDialog();
          },
          tenancyleadlist: tenancyleadlist,
        );
      },
    );
  }

  _showSuceessLeaseDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          buttontitle: GlobleString.DLS_Document_lease_sucess_close,
          title: GlobleString.DLS_Document_lease_sucess,
          onPressed: () async {
            Navigator.of(context).pop();

            await finnleviewcallapi();
          },
        );
      },
    );
  }

  _dailogSetActiveTenant(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.activeTenant_msg,
          positiveText: GlobleString.activeTenant_yes,
          negativeText: GlobleString.activeTenant_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();

            /* if (model.leaseStatus == null) {
              CustomeWidget.LeaseSigne(context, (errorBool) {});
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {});
            } else {

            }*/

            await ApiManager().CheckTenantActiveOrNot(context, model.propId.toString(), model.applicantId.toString(),
                (status, responce) async {
              if (status) {
                await finnleviewcallapi();
                await ApiManager().updateTenancyStatusCount(context);
              } else {
                if (responce == "1") {
                  ToastUtils.showCustomToast(context, GlobleString.already_active_tenant, false);
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  _dailogRemoveActiveTenant(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.activeTenant_remove_msg,
          positiveText: GlobleString.activeTenant_remove_yes,
          negativeText: GlobleString.activeTenant_remove_NO,
          onPressedYes: () async {
            Navigator.of(context1).pop();

            TenancyApplicationID cpojo1 = new TenancyApplicationID();
            cpojo1.ID = model.propId;

            PropVacancyUpdateStatus upojo1 = new PropVacancyUpdateStatus();
            upojo1.Vacancy = "0";

            TenancyApplicationID cpojo2 = new TenancyApplicationID();
            cpojo2.ID = model.id.toString();

            TenancyApplicationUpdateStatus upojo2 = new TenancyApplicationUpdateStatus();
            upojo2.ApplicationStatus = eApplicationStatus().LeaseSent.toString();

            await ApiManager().RemoveActiveTenant(context, cpojo1, upojo1, cpojo2, upojo2, (status, responce) async {
              if (status) {
                await finnleviewcallapi();
                await ApiManager().updateTenancyStatusCount(context);
              } else {
                ToastUtils.showCustomToast(context, responce, false);
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  _dailogTenantInvite(TenancyApplication model) async {
    showDialog(
      barrierColor: Colors.black45,
      context: context,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.ARC_Tenant_Invite_msg,
          negativeText: GlobleString.ARC_Tenant_Invite_NO,
          positiveText: GlobleString.ARC_Tenant_Invite_yes,
          onPressedYes: () {
            Navigator.of(context1).pop();
            tenantRegister(model);
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  tenantRegister(TenancyApplication model) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().landlord_ProfileDSQCall(context, Prefs.getString(PrefsName.OwnerID), (error, respoce2, landlordProfile) {
      if (error) {
        String url = Weburl.CustomerFeaturedPage +
            landlordProfile!.CustomerFeatureListingURL! +
            "/" +
            RouteNames.Basic_Tenant_Register +
            "/" +
            model.applicantId.toString();

        String CompanyLogo;
        if (landlordProfile.companylogo != null &&
            landlordProfile.companylogo!.url != null &&
            landlordProfile.companylogo!.url!.isNotEmpty) {
          CompanyLogo = landlordProfile.companylogo!.url.toString();
        } else {
          CompanyLogo = "http://161.97.104.204:8013/Attachments/Files/20210720135003287_logo.png";
        }

        ApiManager().tenantRegisterWorkflow(context, model.email!, model.personId.toString(), CompanyLogo, url, model.applicantName!,
            landlordProfile.firstname!, landlordProfile.lastname!, landlordProfile.companyname!, (status, responce) async {
          if (status) {
            loader.remove();
            ToastUtils.showCustomToast(context, GlobleString.ARC_Tenant_Invite_successfully, true);
          } else {
            loader.remove();
            ToastUtils.showCustomToast(context, GlobleString.ARC_Tenant_Invite_Error, false);
          }
        });
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce2, false);
      }
    });
  }
}
