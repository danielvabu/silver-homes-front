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
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_dialog_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/varification_document_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/action_popup/document_popupmenu.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/emailtemplet/referencerequest_dialogbox.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_documentverificationstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_leaseagreementstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_referencechecksstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_tenancyapplicationstatus.dart';
import 'package:silverhome/widget/landlord/preview_Lease_dialogbox.dart';
import 'package:silverhome/widget/landlord/preview_documents_dialogbox.dart';
import 'package:silverhome/widget/landlord/ratingupdate_dialogbox.dart';
import 'package:silverhome/widget/landlord/reference_dialog/check_reference_confirm_dialog.dart';
import 'package:silverhome/widget/landlord/reference_dialog/check_reference_list_dialog.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class VarifyDocumentItem extends StatefulWidget {
  final VoidCallback _callbackRefresh;
  List<TenancyApplication> listdata;

  VarifyDocumentItem({
    required List<TenancyApplication> listdata1,
    required VoidCallback OnRefresh,
  })  : listdata = listdata1,
        _callbackRefresh = OnRefresh;

  @override
  _VarifyDocumentItemState createState() => _VarifyDocumentItemState();
}

class _VarifyDocumentItemState extends State<VarifyDocumentItem> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  late OverlayEntry loader;
  ScrollController _scrollController = ScrollController();

  static List<SystemEnumDetails> statuslist = [];
  static List<SystemEnumDetails> reviewstatuslist = [];

  @override
  void initState() {
    statuslist.clear();
    statuslist = QueryFilter().PlainValues(eSystemEnums().ApplicationStatus);

    reviewstatuslist.clear();
    reviewstatuslist =
        QueryFilter().PlainValuesWithSorting(eSystemEnums().DocReviewStatus);

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
      itemBuilder: (BuildContext ctxt, int index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[index], index),
              ),
            ),
            listdata[index].isexpand!
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
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 15),
                    child: Row(
                      children: [
                        TBLTenancyApplicationStatus(
                          onPressedIcon: () {
                            if (listdata[index].applicationReceivedDate !=
                                    null &&
                                listdata[index].applicationReceivedDate != "") {
                              openTenancyApplicationDetails(index);
                            }
                          },
                          sentdate: listdata[index].applicationSentDate!,
                          receivedate: listdata[index].applicationReceivedDate!,
                        ),
                        SizedBox(width: 20),
                        TBLDocumentVerificationStatus(
                          sentdate: listdata[index].docRequestSentDate!,
                          receivedate: listdata[index].docReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[index].docRequestSentDate != null &&
                                listdata[index].docRequestSentDate != "" &&
                                listdata[index].docReceivedDate != null &&
                                listdata[index].docReceivedDate != "") {
                              _dailogPreviewDoc(listdata[index]);
                            }
                          },
                        ),
                        SizedBox(width: 20),
                        TBLReferenceChecksStatus(
                          sentdate: listdata[index].referenceRequestSentDate!,
                          receivedate:
                              listdata[index].referenceRequestReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[index].referenceRequestReceivedDate !=
                                    null &&
                                listdata[index].referenceRequestReceivedDate !=
                                    "") {
                              CustomeWidget.ReferencePreview(
                                  context, listdata[index].id.toString());
                            }
                          },
                        ),
                        SizedBox(width: 20),
                        TBLLeaseAgreementStatus(
                          sentdate: listdata[index].agreementSentDate!,
                          receivedate: listdata[index].agreementReceivedDate!,
                          onPressedIcon: () {
                            if (listdata[index].agreementReceivedDate != null &&
                                listdata[index].agreementReceivedDate != "") {
                              _dailogPreviewLease(listdata[index]);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }

  List<Widget> _tableData(TenancyApplication model, int index) {
    var result = <Widget>[];

    result.add(_datavalueTitle(model.applicantName!, index));
    result
        .add(_datavalueGroup(model.group1!, model.id!, model.numgroup!, index));
    result.add(_datavalueTitlePrimecolor(model));
    result.add(_datavalueRating(model));
    result.add(_datavalueDatesent(model.applicationSentDate!));
    result.add(_datavalueDateReceive(model.applicationReceivedDate!));
    result.add(_appstatusdropdown(model));
    result.add(_reviewstatusdropdown(model));
    result.add(_priviewdocs(model));
    result.add(_actionPopup(model));
    result.add(_datavalueExpand(
        model.isexpand!
            ? "assets/images/circle_up.png"
            : "assets/images/circle_down.png",
        30,
        model,
        index));

    //result.add(_datavalueArchive("assets/images/ic_archive.png", 30));
    return result;
  }

  Widget _datavalueTitle(String text, int index) {
    return InkWell(
      onTap: () {
        openApplicationDetailsView(index);
      },
      child: Container(
        height: 40,
        width: width / 11,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: text,
          child: Text(
            text,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueGroup(int group, int id, int numero, int index) {
    String grupo = "";
    String grupotool = "";
    if (group == 0) {
      if (numero == 0) {
        grupo = "Single Applicant";
        grupotool = "Single Applicant";
      } else {
        numero++;
        grupo = "Group $id - primary (" + numero.toString() + ")";
        grupotool =
            "Group $id - primary (" + numero.toString() + " Applicants)";
      }
    } else {
      numero++;
      grupo = "Group $group (" + numero.toString() + ")";
      grupotool = "Group $id - primary (" + numero.toString() + " Applicants)";
    }
    return InkWell(
      onTap: () {
        // Navigator.of(context).pushNamed(RouteNames.TenantProfiel);
        openApplicationDetailsView2(index);
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: grupotool,
          child: Text(
            grupo,
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
        width: width / 8.5,
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
              ratingset: model.rating!,
              positiveText: GlobleString.DLR_Save,
              onPressedYes: (double rating, String ratingraview) async {
                Navigator.of(context1).pop();

                TenancyApplicationID updateid = new TenancyApplicationID();
                updateid.ID = model.applicantId.toString();

                TenancyApplicationUpdateRating updaterating =
                    new TenancyApplicationUpdateRating();
                updaterating.Rating = rating;
                updaterating.Note = ratingraview;

                await ApiManager().UpdateRatingApplication(
                    context, updateid, updaterating, (status, responce) async {
                  if (status) {
                    await varificationDocCallApi();
                  }
                });
              },
              onPressedNo: () {
                Navigator.of(context1).pop();
              },
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: width / 14,
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

  Widget _datavalueDatesent(String text) {
    return Container(
      height: 40,
      width: width / 10.5,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text != null && text != ""
            ? new DateFormat("dd-MMM-yyyy")
                .format(DateTime.parse(text))
                .toString()
            : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueDateReceive(String text) {
    return Container(
      height: 40,
      width: width / 10.5,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text != null && text != ""
            ? new DateFormat("dd-MMM-yyyy")
                .format(DateTime.parse(text))
                .toString()
            : "",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _appstatusdropdown(TenancyApplication model) {
    return Container(
      height: 28,
      width: width / 9,
      padding: EdgeInsets.only(left: 2),
      // ignore: missing_required_param
      child: DropdownSearch<SystemEnumDetails>(
        mode: Mode.MENU,
        items: statuslist,
        textstyle: MyStyles.Medium(12, myColor.text_color),
        itemAsString: (SystemEnumDetails? u) => u != null ? u.displayValue : "",
        hint: "Select Status",
        defultHeight:
            statuslist.length * 33 > 250 ? 250 : statuslist.length * 33,
        showSearchBox: false,
        selectedItem:
            model.applicationStatus != null ? model.applicationStatus : null,
        isFilteredOnline: true,
        onChanged: (data) {
          if (data!.EnumDetailID.toString() !=
              eApplicationStatus().ActiveTenent.toString()) {
            TenancyApplicationID updateid = new TenancyApplicationID();
            updateid.ID = model.id.toString();

            TenancyApplicationUpdateStatus updatestatus =
                new TenancyApplicationUpdateStatus();
            updatestatus.ApplicationStatus = data.EnumDetailID.toString();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);

            ApiManager().UpdateStatusApplication(
                context, updateid, updatestatus, (status, responce) async {
              if (status) {
                await varificationDocCallApi();

                loader.remove();
              } else {
                loader.remove();
              }
            });
          } else {
            /*if (model.leaseStatus == null) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                varificationDocCallApi();
              });
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                varificationDocCallApi();
              });
            } else {

            }*/
            _dailogSetActiveTenant(model, 1);
          }
        },
      ),
    );
  }

  Widget _reviewstatusdropdown(TenancyApplication model) {
    return Container(
        height: 28,
        width: width / 10,
        padding: EdgeInsets.only(left: 12),
        // ignore: missing_required_param
        child: DropdownSearch<SystemEnumDetails>(
          mode: Mode.MENU,
          items: reviewstatuslist,
          textstyle: MyStyles.Medium(12, myColor.text_color),
          itemAsString: (SystemEnumDetails? u) => u!.displayValue,
          hint: "Action",
          defultHeight: reviewstatuslist.length * 33 > 250
              ? 250
              : reviewstatuslist.length * 33,
          showSearchBox: false,
          selectedItem:
              model.docReviewStatus != null ? model.docReviewStatus : null,
          isFilteredOnline: true,
          onChanged: (data) {
            TenancyApplicationID updateid = new TenancyApplicationID();
            updateid.ID = model.id.toString();

            DocumentReviewUpdateStatus updatestatus =
                new DocumentReviewUpdateStatus();
            updatestatus.DocReviewStatus = data!.EnumDetailID.toString();

            ApiManager().UpdateReviewstatusVarificationDocumentList(
                context, updateid, updatestatus, (status, responce) {
              if (status) {}
            });
          },
        ));
  }

  Widget _priviewdocs(TenancyApplication model) {
    return (model.docReceivedDate != null && model.docReceivedDate != "")
        ? InkWell(
            onTap: () {
              _dailogPreviewDoc(model);
            },
            child: Container(
              height: 28,
              width: width / 11.5,
              padding: EdgeInsets.only(left: 10),
              alignment: Alignment.center,
              child: Text(
                "Preview Docs",
                textAlign: TextAlign.center,
                style: MyStyles.Medium(12, myColor.blue),
              ),
            ),
          )
        : Container(
            height: 28,
            width: width / 11.5,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.center,
          );
  }

  Widget _actionPopup(TenancyApplication model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        alignment: Alignment.centerRight,
        child: DocumentvarifyPopupMenu(
          onPressedCheckReferences: () {
            _dailogReferenceConfirmDialog(model);
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

  Widget _datavalueExpand(
      String iconData, double widthv, TenancyApplication model, int index) {
    return InkWell(
      onTap: () {
        if (model.isexpand!) {
          widget.listdata[index].isexpand = false;
        } else {
          widget.listdata[index].isexpand = true;

          /* int size = 0;
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
          //width: 20,
          alignment: Alignment.center,
        ),
      ),
    );
  }

  varificationDocCallApi() async {
    await Prefs.setBool(PrefsName.IsApplyFilterList, false);
    _store.dispatch(UpdateLLVDapplicationisloding(true));
    _store.dispatch(UpdateLLVDvarificationdoclist(<TenancyApplication>[]));
    _store
        .dispatch(UpdateLLVDfiltervarificationdoclist(<TenancyApplication>[]));

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.IsArchived = "0";
    reqtokens.ApplicationStatus = "3";

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);

    await ApiManager().getVarificationDocumentList(context, filterjson);
  }

  openApplicationDetailsView(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      TenancyApplication tal = widget.listdata[i];
      listdataviewlist.add(tal);

      if (widget.listdata.length - 1 == i) {
        TenancyApplication tal = widget.listdata[index];
        listdataviewlist.remove(tal);
        listdataviewlist.insert(0, tal);

        _store.dispatch(UpdateTenancyDetails(listdataviewlist));
      }
    }
  }

  openApplicationDetailsView2(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      TenancyApplication tal = widget.listdata[i];
      listdataviewlist.add(tal);

      if (widget.listdata.length - 1 == i) {
        TenancyApplication tal = widget.listdata[index];
        listdataviewlist.remove(tal);
        listdataviewlist.insert(0, tal);

        _store.dispatch(UpdateTenancyDetailsMultiple(listdataviewlist));
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
            await varificationDocCallApi();
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

            TenancyApplicationUpdateArchive updateArchive =
                new TenancyApplicationUpdateArchive();
            updateArchive.IsArchived = "1";

            await ApiManager().UpdateArchiveApplication(
                context, updateid, updateArchive, (status, responce) async {
              if (status) {
                await varificationDocCallApi();
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

  openTenancyApplicationDetails(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      if (widget.listdata[i].applicationSentDate != null &&
          widget.listdata[i].applicationSentDate != "" &&
          widget.listdata[i].applicationReceivedDate != null &&
          widget.listdata[i].applicationReceivedDate != "") {
        TenancyApplication tal1 = widget.listdata[i];
        listdataviewlist.add(tal1);
      }

      if (widget.listdata.length - 1 == i) {
        TenancyApplication tal = widget.listdata[index];

        listdataviewlist.remove(tal);
        listdataviewlist.insert(0, tal);

        _store.dispatch(UpdateTenancyDetails(listdataviewlist));
      }
    }
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

    await ApiManager().getReferenceListApplicantWise(
        context, model.id.toString(), (status, responce, messege) async {
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

  _dailogRequestReference(TenancyApplication model) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    _store.dispatch(UpdateRCDisAllCheck(false));

    await ApiManager().getReferenceListApplicantWise(
        context, model.id.toString(), (status, responce, messege) async {
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

            await varificationDocCallApi();
          },
          buttontitle: GlobleString.DCR_success_close,
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

            await ApiManager().CheckTenantActiveOrNot(
                context, model.propId.toString(), model.applicantId.toString(),
                (status, responce) async {
              if (status) {
                await varificationDocCallApi();
                ApiManager().updateTenancyStatusCount(context);
              } else {
                if (responce == "1") {
                  ToastUtils.showCustomToast(
                      context, GlobleString.already_active_tenant, false);
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }
                if (flag == 1) {
                  varificationDocCallApi();
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
            if (flag == 1) {
              varificationDocCallApi();
            }
          },
        );
      },
    );
  }
}
