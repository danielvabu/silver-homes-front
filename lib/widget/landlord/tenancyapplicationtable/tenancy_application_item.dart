import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_tenancy_applicant_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/action_popup/applicant_popupmenu.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/emailtemplet/documentrequest_dialogbox.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_documentverificationstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_leaseagreementstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_referencechecksstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_tenancyapplicationstatus.dart';
import 'package:silverhome/widget/landlord/preview_Lease_dialogbox.dart';
import 'package:silverhome/widget/landlord/preview_documents_dialogbox.dart';
import 'package:silverhome/widget/landlord/ratingupdate_dialogbox.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef CallbackInvite = void Function(TenancyApplication tenancyApplicationLead);

class TenancyApplicationItem extends StatefulWidget {
  List<TenancyApplication> listdata;
  final VoidCallback _callbackRefresh;

  TenancyApplicationItem({
    required List<TenancyApplication> listdata1,
    required VoidCallback OnRefresh,
  })  : listdata = listdata1,
        _callbackRefresh = OnRefresh;

  @override
  _TenancyApplicationItemState createState() => _TenancyApplicationItemState();
}

class _TenancyApplicationItemState extends State<TenancyApplicationItem> {
  double height = 0, width = 0;

  ScrollController _scrollController = ScrollController();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();
  static List<SystemEnumDetails> statuslist = [];

  @override
  void initState() {
    statuslist.clear();
    statuslist = QueryFilter().PlainValues(eSystemEnums().ApplicationStatus);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 265,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<TenancyApplication> listdata) {
    return ListView.separated(
      controller: _scrollController,
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      //key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[Index], Index),
              ),
            ),
            listdata[Index].isexpand!
                ? Container(
                    width: width - 55,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: myColor.TA_espand_status_Border,
                          spreadRadius: 0.0,
                          blurRadius: 0.1,
                        ),
                        BoxShadow(
                          color: myColor.TA_espand_status_fill,
                          spreadRadius: 0,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
                    child: Row(
                      children: [
                        TBLTenancyApplicationStatus(
                          onPressedIcon: () {
                            if (listdata[Index].applicationReceivedDate != null && listdata[Index].applicationReceivedDate != "") {
                              openTenancyApplicationDetails(Index);
                            }
                          },
                          sentdate: listdata[Index].applicationSentDate!,
                          receivedate: listdata[Index].applicationReceivedDate!,
                        ),
                        SizedBox(width: 20),
                        TBLDocumentVerificationStatus(
                          sentdate: listdata[Index].docRequestSentDate!,
                          receivedate: listdata[Index].docReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[Index].docRequestSentDate != null &&
                                listdata[Index].docRequestSentDate != "" &&
                                listdata[Index].docReceivedDate != null &&
                                listdata[Index].docReceivedDate != "") {
                              _dailogPreviewDoc(listdata[Index]);
                            }
                          },
                        ),
                        SizedBox(width: 20),
                        TBLReferenceChecksStatus(
                          sentdate: listdata[Index].referenceRequestSentDate!,
                          receivedate: listdata[Index].referenceRequestReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[Index].referenceRequestReceivedDate != null &&
                                listdata[Index].referenceRequestReceivedDate != "") {
                              CustomeWidget.ReferencePreview(context, listdata[Index].id.toString());
                            }
                          },
                        ),
                        SizedBox(width: 20),
                        TBLLeaseAgreementStatus(
                          sentdate: listdata[Index].agreementSentDate!,
                          receivedate: listdata[Index].agreementReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[Index].agreementReceivedDate != null && listdata[Index].agreementReceivedDate != "") {
                              _dailogPreviewLease(listdata[Index]);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : SizedBox()
          ],
        );
      },
    );
  }

  List<Widget> _tableData(TenancyApplication model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueTitle(model.applicantName!, Index));
    result.add(_datavalueTitlePrimecolor(model));
    result.add(_datavalueRating(model));
    result.add(_datavalueTitleDataSent(model.applicationSentDate!));
    result.add(_datavalueTitleDataReceive(model.applicationReceivedDate!));
    result.add(_statusdropdown(model));
    result.add(_actionPopup(model));
    result.add(_datavalueExpand(model.isexpand! ? "assets/images/circle_up.png" : "assets/images/circle_down.png", 30, model, Index));

    return result;
  }

  Widget _datavalueTitle(String text, int Index) {
    return InkWell(
      onTap: () {
        openApplicationDetailsView(Index);
      },
      child: Container(
        height: 40,
        width: width / 7.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: text,
          child: Text(
            text,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueTitlePrimecolor(TenancyApplication model) {
    return InkWell(
      onTap: () {
        CustomeWidget.getPropertyDetailsByPropertyID(context, model.propId!);
      },
      child: Container(
        height: 40,
        width: width / 7.5,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.propertyName!,
          child: Text(
            model.propertyName!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueRating(TenancyApplication model) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierColor: Colors.black45,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return RatingUpdateDialogBox(
              title: "",
              ratingcomment: model.note!,
              positiveText: GlobleString.DLR_Save,
              onPressedNo: () {
                Navigator.of(context1).pop();
              },
              ratingset: model.rating!,
              onPressedYes: (double rating, String ratingraview) async {
                TenancyApplicationID updateid = new TenancyApplicationID();
                updateid.ID = model.applicantId.toString();

                TenancyApplicationUpdateRating updaterating = new TenancyApplicationUpdateRating();
                updaterating.Rating = rating;
                updaterating.Note = ratingraview;

                await ApiManager().UpdateRatingApplication(context, updateid, updaterating, (status, responce) async {
                  if (status) {
                    ApplicantcallApi();
                  }
                });

                Navigator.of(context1).pop();
              },
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: RatingBarIndicator(
          rating: model.rating!,
          itemBuilder: (context, index) => Icon(
            Icons.star,
            color: myColor.blue,
          ),
          itemCount: 5,
          itemSize: 15.0,
          direction: Axis.horizontal,
        ),
      ),
    );
  }

  Widget _datavalueTitleDataSent(String text) {
    return Container(
      height: 40,
      width: width / 7,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text != null && text != "" ? new DateFormat("dd-MMM-yyyy").format(DateTime.parse(text)).toString() : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueTitleDataReceive(String text) {
    return Container(
      height: 40,
      width: width / 6,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text != null && text != "" ? new DateFormat("dd-MMM-yyyy").format(DateTime.parse(text)).toString() : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _statusdropdown(TenancyApplication model) {
    return Container(
      height: 28,
      width: width / 6,
      padding: EdgeInsets.only(left: 2),
      child: DropdownSearch<SystemEnumDetails>(
        mode: Mode.MENU,
        items: statuslist,
        textstyle: MyStyles.Medium(12, myColor.text_color),
        itemAsString: (SystemEnumDetails? u) => u != null ? u.displayValue : "",
        hint: "Select Status",
        defultHeight: statuslist.length * 33 > 250 ? 250 : statuslist.length * 33,
        showSearchBox: false,
        selectedItem: model.applicationStatus != null ? model.applicationStatus : null,
        isFilteredOnline: false,
        onChanged: (data) {
          if (data!.EnumDetailID.toString() != eApplicationStatus().ActiveTenent.toString()) {
            TenancyApplicationID updateid = new TenancyApplicationID();
            updateid.ID = model.id.toString();

            TenancyApplicationUpdateStatus updatestatus = new TenancyApplicationUpdateStatus();
            updatestatus.ApplicationStatus = data.EnumDetailID.toString();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);

            ApiManager().UpdateStatusApplication(context, updateid, updatestatus, (status, responce) async {
              if (status) {
                ApplicantcallApi();
                loader.remove();
              } else {
                loader.remove();
              }
            });
          } else {
            /*if (model.leaseStatus == null) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                ApplicantcallApi();
              });
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                ApplicantcallApi();
              });
            } else {

            }*/
            _dailogSetActiveTenant(model, 1);
          }
        },
      ),
    );
  }

  Widget _actionPopup(TenancyApplication model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        //width: width / 17,
        alignment: Alignment.centerRight,
        child: ApplicantPopupMenu(
          onPressedRequestdocuments: () {
            _dailogRequestDocument(model);
          },
          onPressedEditapplicant: () {
            CustomeWidget.EditApplicant(context, model.applicantId.toString());
          },
          onPressedArchive: () {
            _dailogSetArchive(model);
          },
          isListView: true,
        ),
      ),
    );
  }

  Widget _datavalueExpand(String iconData, double widthv, TenancyApplication model, int index) {
    return InkWell(
      onTap: () async {
        if (model.isexpand!) {
          widget.listdata[index].isexpand = false;
        } else {
          widget.listdata[index].isexpand = true;

          /*int size = 0;
          for (int i = 0; i < widget.listdata.length; i++) {
            TenancyApplication model = widget.listdata[i];

            if (i < index) {
              if (model.isexpand!) {
                size = size + 100;
              }
            }

            if (i == index) {
              int height = index * 40;
              int fh = height + size;
              _scrollController.animateTo(double.parse(fh.toString()),
                  duration: new Duration(seconds: 2), curve: Curves.ease);
              break;
            }
          }*/
        }

        setState(() {});
      },
      child: Container(
        margin: EdgeInsets.only(left: 15, right: 10),
        height: 40,
        width: widthv,
        alignment: Alignment.center,
        child: Image.asset(
          iconData,
          height: 19,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  openApplicationDetailsView(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      listdataviewlist.add(widget.listdata[i]);

      if (widget.listdata.length - 1 == i) {
        TenancyApplication tal = widget.listdata[index];
        listdataviewlist.remove(tal);
        listdataviewlist.insert(0, tal);

        _store.dispatch(UpdateTenancyDetails(listdataviewlist));
      }
    }
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
                ApplicantcallApi();
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

  _dailogRequestDocument(TenancyApplication tenancyApplication) async {
    List<TenancyApplication> tenancyleadlist = <TenancyApplication>[];
    tenancyleadlist.add(tenancyApplication);

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
          title: GlobleString.DDQ_DocRequest_success,
          onPressed: () async {
            Navigator.of(context).pop();
            ApplicantcallApi();
          },
          buttontitle: GlobleString.dailog_finish,
        );
      },
    );
  }

  openTenancyApplicationDetails(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      if (widget.listdata[i].applicationSentDate != null &&
          widget.listdata[i].applicationSentDate != "" &&
          widget.listdata[i].applicationReceivedDate != null &&
          widget.listdata[i].applicationReceivedDate != "") {
        listdataviewlist.add(widget.listdata[i]);
      }

      if (widget.listdata.length - 1 == i) {
        TenancyApplication tal = widget.listdata[index];
        listdataviewlist.remove(tal);
        listdataviewlist.insert(0, tal);

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
            ApplicantcallApi();
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

            /*if (model.leaseStatus == null) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
              });
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
              });
            } else {

            }*/
            _dailogSetActiveTenant(model, 0);
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

  _dailogSetActiveTenant(TenancyApplication model, int flag) async {
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

            await ApiManager().CheckTenantActiveOrNot(context, model.propId.toString(), model.applicantId.toString(),
                (status, responce) async {
              if (status) {
                await ApplicantcallApi();
                ApiManager().updateTenancyStatusCount(context);
              } else {
                if (responce == "1") {
                  ToastUtils.showCustomToast(context, GlobleString.already_active_tenant, false);
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }

                if (flag == 1) {
                  ApplicantcallApi();
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
            if (flag == 1) {
              ApplicantcallApi();
            }
          },
        );
      },
    );
  }

  ApplicantcallApi() async {
    _store.dispatch(UpdateLLTAApplicantisloding(true));
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);

    _store.dispatch(UpdateLLTAApplicantleadList(<TenancyApplication>[]));
    _store.dispatch(UpdateLLTAFilterApplicantleadList(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "2";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getCommonApplicantList(context, filterjson);
  }
}
