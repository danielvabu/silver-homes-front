import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/reference_check_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/Landlord/action_popup/reference_popupmenu.dart';
import 'package:silverhome/widget/alert/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/emailtemplet/leasesend_dialogbox.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_documentverificationstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_leaseagreementstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_referencechecksstatus.dart';
import 'package:silverhome/widget/landlord/listviewitemstatus/tbl_tenancyapplicationstatus.dart';
import 'package:silverhome/widget/landlord/referencechecktabel/reference_expanded_header.dart';
import 'package:silverhome/widget/landlord/referencechecktabel/reference_expanded_item.dart';
import 'package:silverhome/widget/alert/message_dialogbox.dart';

import '../../searchdropdown/dropdown_search.dart';
import '../customewidget.dart';
import '../preview_Lease_dialogbox.dart';
import '../preview_documents_dialogbox.dart';
import '../ratingupdate_dialogbox.dart';

class ReferenceItem extends StatefulWidget {
  final VoidCallback _callbackRefresh;
  List<TenancyApplication> listdata;

  ReferenceItem({
    required List<TenancyApplication> listdata1,
    required VoidCallback OnRefresh,
  })  : listdata = listdata1,
        _callbackRefresh = OnRefresh;

  @override
  _ReferenceItemState createState() => _ReferenceItemState();
}

class _ReferenceItemState extends State<ReferenceItem> {
  static List<SystemEnumDetails> statuslist = [];
  String statusValue = "";
  final _store = getIt<AppStore>();
  late ScrollController _scrollController;
  late OverlayEntry loader;
  double height = 0, width = 0;

  @override
  void initState() {
    _scrollController = new ScrollController();

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
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      controller: _scrollController,
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
                          color: myColor.TA_Border,
                          spreadRadius: 0.0,
                          blurRadius: 0.1,
                        ),
                        BoxShadow(
                          color: myColor.TA_sub,
                          spreadRadius: 0.0,
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 15, bottom: 5),
                          child: Row(
                            children: [
                              TBLTenancyApplicationStatus(
                                onPressedIcon: () {
                                  if (listdata[index].applicationReceivedDate !=
                                          null &&
                                      listdata[index].applicationReceivedDate !=
                                          "") {
                                    openTenancyApplicationDetails(index);
                                  }
                                },
                                sentdate: listdata[index].applicationSentDate!,
                                receivedate:
                                    listdata[index].applicationReceivedDate!,
                              ),
                              SizedBox(width: 20),
                              TBLDocumentVerificationStatus(
                                sentdate: listdata[index].docRequestSentDate!,
                                receivedate: listdata[index].docReceivedDate!,
                                onPressedIcon: () {
                                  if (listdata[index].docRequestSentDate !=
                                          null &&
                                      listdata[index].docRequestSentDate !=
                                          "" &&
                                      listdata[index].docReceivedDate != null &&
                                      listdata[index].docReceivedDate != "") {
                                    _dailogPreviewDoc(listdata[index]);
                                  }
                                },
                              ),
                              SizedBox(width: 20),
                              TBLReferenceChecksStatus(
                                sentdate:
                                    listdata[index].referenceRequestSentDate!,
                                receivedate: listdata[index]
                                    .referenceRequestReceivedDate!,
                                onPressedIcon: () {
                                  if (listdata[index]
                                              .referenceRequestReceivedDate !=
                                          null &&
                                      listdata[index]
                                              .referenceRequestReceivedDate !=
                                          "") {
                                    CustomeWidget.ReferencePreview(
                                        context, listdata[index].id.toString());
                                  }
                                },
                              ),
                              SizedBox(width: 20),
                              TBLLeaseAgreementStatus(
                                sentdate: listdata[index].agreementSentDate!,
                                receivedate:
                                    listdata[index].agreementReceivedDate!,
                                onPressedIcon: () {
                                  if (listdata[index].agreementReceivedDate !=
                                          null &&
                                      listdata[index].agreementReceivedDate !=
                                          "") {
                                    _dailogPreviewLease(listdata[index]);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        listdata[index].leadReference != null &&
                                listdata[index].leadReference!.length > 0
                            ? Container(
                                decoration: BoxDecoration(
                                  color: myColor.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: myColor.TA_status_Border,
                                      width: 2),
                                ),
                                margin: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          ReferenceExpendedHeader(
                                            onPressedCehck: () {},
                                          ),
                                          Container(
                                            height: 1,
                                            color: myColor.TA_tab_devide,
                                            margin: EdgeInsets.only(
                                                left: 20, right: 20),
                                          ),
                                          ReferenceExpandedItem(
                                            onPressed: () {},
                                            listdata1:
                                                listdata[index].leadReference!,
                                            referencedata: listdata[index],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(padding: EdgeInsets.only(bottom: 10))
                      ],
                    ),
                  )
                : Container()
          ],
        );
      },
    );
  }

  List<Widget> _tableData(TenancyApplication model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueTitle(model.applicantName!, Index));
    result.add(_datavalueGroup(model.group1!, model.id!, model.numgroup!));
    result.add(_datavalueTitlePrimecolor(model));
    result.add(_datavalueRating(model));
    result.add(_datavalueReferences(model.referencesCount.toString()));
    result.add(
        _datavalueQuestionnairesSent(model.questionnairesSentCount.toString()));
    result.add(_datavalueTitlequestionnairesReceived(
        model.questionnairesReceivedCount.toString()));
    result.add(_appstatusdropdown(model));
    result.add(_actionPopup(model));
    result.add(_datavalueExpand(
        model.isexpand!
            ? "assets/images/circle_up.png"
            : "assets/images/circle_down.png",
        30,
        model,
        Index));

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
        width: width / 8,
        padding: EdgeInsets.only(left: 10, right: 10),
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

  Widget _datavalueGroup(int group, int id, int numero) {
    String grupo = "";
    if (group == 0) {
      if (numero == 0) {
        grupo = "Single Applicant";
      } else {
        numero++;
        grupo = "Group $id - primary (" + numero.toString() + " applicants)";
      }
    } else {
      numero++;
      grupo = "Group $group (" + numero.toString() + " applicants)";
    }
    return InkWell(
      onTap: () {
        //  openApplicationDetailsView(Index);
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: grupo,
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
        width: width / 8,
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
                    await referencecallApi();
                  }
                });
              },
              onPressedNo: () {
                Navigator.of(context1).pop();
              },
              ratingset: model.rating!,
            );
          },
        );
      },
      child: Container(
        height: 40,
        width: width / 12,
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

  Widget _datavalueReferences(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueQuestionnairesSent(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueTitlequestionnairesReceived(String text) {
    return Container(
      height: 40,
      width: width / 10,
      padding: EdgeInsets.only(left: 10, right: 10),
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _appstatusdropdown(TenancyApplication model) {
    return Container(
      height: 28,
      width: width / 10,
      padding: EdgeInsets.only(left: 2),
      alignment: Alignment.centerLeft,
      // ignore: missing_required_param
      child: DropdownSearch<SystemEnumDetails>(
        mode: Mode.MENU,
        items: statuslist,
        textstyle: MyStyles.Medium(12, myColor.text_color),
        itemAsString: (SystemEnumDetails? u) => u!.displayValue,
        hint: "Action",
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
                await referencecallApi();

                loader.remove();
              } else {
                loader.remove();
              }
            });
          } else {
            /*if (model.leaseStatus == null) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                referencecallApi();
              });
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                referencecallApi();
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
        alignment: Alignment.centerRight,
        child: ReferenceCheckPopupMenu(
          onPressedSendLease: () {
            _dialogSendLeaseRequest(model);
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
      onTap: () async {
        if (model.isexpand!) {
          widget.listdata[index].isexpand = false;
          setState(() {});
        } else {
          await ApiManager().getReferenceListApplicantWise(
              context, model.id.toString(), (status, responce, messege) async {
            if (status) {
              widget.listdata[index].leadReference = responce;
              widget.listdata[index].isexpand = true;

              countingsize(index);
            } else {
              widget.listdata[index].leadReference = <LeadReference>[];
              widget.listdata[index].isexpand = true;

              countingsize(index);
            }
          });
        }
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

  countingsize(int index) {
    /*int size = 0;
    for (int i = 0; i < widget.listdata.length; i++) {
      TenancyApplication model = widget.listdata[i];

      if (i < index) {
        if (model.isexpand!) {
          if (int.parse(model.referencesCount.toString()) != 0) {
            size =
                size + 140 + (int.parse(model.referencesCount.toString()) * 40);
          } else {
            size =
                size + 100 + (int.parse(model.referencesCount.toString()) * 40);
          }
        }
      }

      if (i == index) {
        int height1 = index * 40;
        int height2 = int.parse(model.referencesCount.toString()) * 40;

        if (int.parse(model.referencesCount.toString()) != 0) {
          height2 = height2 + 40;
        }

        int height = height1 + height2;
        int fh = height + size;
        _scrollController.animateTo(double.parse(fh.toString()),
            duration: new Duration(seconds: 2), curve: Curves.ease);
        break;
      }
    }*/

    setState(() {});
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

  openTenancyApplicationDetails(int index) {
    List<TenancyApplication> listdataviewlist = <TenancyApplication>[];

    for (int i = 0; i < widget.listdata.length; i++) {
      if (widget.listdata[i].applicationSentDate != null &&
          widget.listdata[i].applicationSentDate != "" &&
          widget.listdata[i].applicationReceivedDate != null &&
          widget.listdata[i].applicationReceivedDate != "") {
        TenancyApplication tal = widget.listdata[i];

        listdataviewlist.add(tal);
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

            await referencecallApi();
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
            _showSuceessleaseDialog();
          },
          tenancyleadlist: tenancyleadlist,
        );
      },
    );
  }

  _showSuceessleaseDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MessageDialogBox(
          title: GlobleString.DLS_Document_lease_sucess,
          onPressed: () async {
            Navigator.of(context).pop();

            await referencecallApi();
          },
          buttontitle: GlobleString.DLS_Document_lease_sucess_close,
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
                referencecallApi();
              });
            } else if (model.leaseStatus!.EnumDetailID !=
                eLeaseStatus().Signed) {
              CustomeWidget.LeaseSigne(context, (errorBool) {
                referencecallApi();
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
                await referencecallApi();
                ApiManager().updateTenancyStatusCount(context);
              } else {
                if (responce == "1") {
                  ToastUtils.showCustomToast(
                      context, GlobleString.already_active_tenant, false);
                } else {
                  ToastUtils.showCustomToast(context, responce, false);
                }

                if (flag == 1) {
                  referencecallApi();
                }
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
            if (flag == 1) {
              referencecallApi();
            }
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

            TenancyApplicationUpdateArchive updateArchive =
                new TenancyApplicationUpdateArchive();
            updateArchive.IsArchived = "1";

            await ApiManager().UpdateArchiveApplication(
                context, updateid, updateArchive, (status, responce) async {
              if (status) {
                await referencecallApi();
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
}
