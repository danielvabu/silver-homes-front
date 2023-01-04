import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/tenancy_application.dart';
import 'package:silverhome/widget/Landlord/action_popup/leasesent_popupmenu.dart';
import 'package:silverhome/widget/Landlord/funnelitemstatus/fnl_documentverificationstatus.dart';
import 'package:silverhome/widget/Landlord/funnelitemstatus/fnl_leaseagreementstatus.dart';
import 'package:silverhome/widget/Landlord/funnelitemstatus/fnl_referencechecksstatus.dart';
import 'package:silverhome/widget/Landlord/funnelitemstatus/fnl_tenancyapplicationstatus.dart';

typedef CallbackOnNext = void Function(int index);
typedef CallbackOnPrevious = void Function(int index);
typedef CallbackOnRating = void Function(int index);
typedef CallbackActivateTenant = void Function();
typedef CallbackArchive = void Function();
typedef CallbackPreviewLease = void Function();
typedef CallbackEditapplicant = void Function();
typedef CallbackTenancyApplicationIcon = void Function();
typedef CallbackDocumentVerificationIcon = void Function();
typedef CallbackReferenceChecksIcon = void Function();
typedef CallbackLeaseAgreementIcon = void Function();

class LeaseSentCardViewWidget extends StatefulWidget {
  TenancyApplication dmodel;
  List<TenancyApplication> alllistdata;
  int pos;
  final CallbackOnNext _callbackOnNext;
  final CallbackOnPrevious _callbackOnPrevious;
  final CallbackOnRating _callbackOnRating;
  final CallbackActivateTenant _callbackActivateTenant;
  final CallbackEditapplicant _callbackEditapplicant;
  final CallbackArchive _callbackArchive;
  final CallbackPreviewLease _callbackPreviewLease;
  final CallbackTenancyApplicationIcon _callbackTenancyApplicationIcon;
  final CallbackDocumentVerificationIcon _callbackDocumentVerificationIcon;
  final CallbackReferenceChecksIcon _callbackReferenceChecksIcon;
  final CallbackLeaseAgreementIcon _callbackLeaseAgreementIcon;

  LeaseSentCardViewWidget({
    required CallbackOnNext onNext,
    required CallbackOnPrevious onPrevious,
    required CallbackOnRating onRating,
    required CallbackActivateTenant onPressedActivateTenant,
    required CallbackEditapplicant onPressedEditapplicant,
    required CallbackArchive onPressedArchive,
    required CallbackPreviewLease onPressedPreviewLease,
    required CallbackTenancyApplicationIcon callbackTenancyApplicationIcon,
    required CallbackDocumentVerificationIcon callbackDocumentVerificationIcon,
    required CallbackReferenceChecksIcon callbackReferenceChecksIcon,
    required CallbackLeaseAgreementIcon callbackLeaseAgreementIcon,
    required TenancyApplication dmodel1,
    required List<TenancyApplication> alllistdata,
    required int pos,
  })  : this.dmodel = dmodel1,
        this.alllistdata = alllistdata,
        this.pos = pos,
        this._callbackOnNext = onNext,
        this._callbackOnPrevious = onPrevious,
        this._callbackOnRating = onRating,
        this._callbackActivateTenant = onPressedActivateTenant,
        this._callbackEditapplicant = onPressedEditapplicant,
        this._callbackArchive = onPressedArchive,
        this._callbackPreviewLease = onPressedPreviewLease,
        this._callbackTenancyApplicationIcon = callbackTenancyApplicationIcon,
        this._callbackDocumentVerificationIcon =
            callbackDocumentVerificationIcon,
        this._callbackReferenceChecksIcon = callbackReferenceChecksIcon,
        this._callbackLeaseAgreementIcon = callbackLeaseAgreementIcon;

  @override
  _LeaseSentCardViewWidgetState createState() =>
      _LeaseSentCardViewWidgetState();
}

class _LeaseSentCardViewWidgetState extends State<LeaseSentCardViewWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String grupo = widget.dmodel.group1.toString();
    String id = widget.dmodel.id.toString();
    if (grupo == '0') {
      grupo = "Group $id - primary";
    } else {
      grupo = "Group $grupo";
    }
    // TODO: implement build
    return Container(
      width: 280,
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: myColor.TA_Border, width: 0.5),
          borderRadius: BorderRadius.circular(3),
        ),
        shadowColor: myColor.fnl_shadow,
        color: myColor.fnl_card,
        margin: EdgeInsets.only(bottom: 10),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    margin: EdgeInsets.only(top: 35),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        widget._callbackOnPrevious(widget.pos);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: myColor.black,
                        size: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Tooltip(
                          message: widget.dmodel.applicantName!,
                          child: Text(
                            widget.dmodel.applicantName!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            widget._callbackOnRating(widget.pos);
                          },
                          child: RatingBarIndicator(
                            rating: widget.dmodel.rating!,
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: myColor.blue,
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(grupo),
                        InkWell(
                          onTap: () {
                            if (widget.dmodel.isexpand!) {
                              widget.dmodel.isexpand = false;
                            } else {
                              widget.dmodel.isexpand = true;
                            }
                            setState(() {});
                          },
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            height: 30,
                            width: 30,
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.center,
                            child: Image.asset(
                              widget.dmodel.isexpand!
                                  ? "assets/images/circle_up.png"
                                  : "assets/images/circle_down.png",
                              height: 20,
                              alignment: Alignment.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      LeasesentPopupMenu(
                        isListView: true,
                        agreementReceivedDate:
                            widget.dmodel.agreementReceivedDate != null &&
                                    widget.dmodel.agreementReceivedDate != ""
                                ? widget.dmodel.agreementReceivedDate
                                : "",
                        onPressedActivateTenant: () {
                          widget._callbackActivateTenant();
                        },
                        onPressedEditapplicant: () {
                          widget._callbackEditapplicant();
                        },
                        onPressedArchive: () {
                          widget._callbackArchive();
                        },
                        onPressedPreviewLease: () {
                          widget._callbackPreviewLease();
                        },
                      ),
                      Container(
                        height: 20,
                        width: 20,
                        margin: EdgeInsets.only(top: 5),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            widget._callbackOnNext(widget.pos);
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: myColor.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              widget.dmodel.isexpand!
                  ? Container(
                      height: 176,
                      decoration: BoxDecoration(
                        color: myColor.fnl_status_card_fill,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: myColor.fnl_status_card_border, width: 1),
                      ),
                      margin: EdgeInsets.only(top: 5, bottom: 5),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 5, right: 5),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FNLTenancyApplicationStatus(
                            onPressedIcon: () {
                              widget._callbackTenancyApplicationIcon();
                            },
                            sentdate: widget.dmodel.applicationSentDate!,
                            receivedate: widget.dmodel.applicationReceivedDate!,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FNLDocumentVerificationStatus(
                            onPressedIcon: () {
                              widget._callbackDocumentVerificationIcon();
                            },
                            sentdate: widget.dmodel.docRequestSentDate!,
                            receivedate: widget.dmodel.docReceivedDate!,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FNLReferenceChecksStatus(
                            onPressedIcon: () {
                              widget._callbackReferenceChecksIcon();
                            },
                            sentdate: widget.dmodel.referenceRequestSentDate!,
                            receivedate:
                                widget.dmodel.referenceRequestReceivedDate!,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FNLLeaseAgreementStatus(
                            onPressedIcon: () {
                              widget._callbackLeaseAgreementIcon();
                            },
                            sentdate: widget.dmodel.agreementSentDate!,
                            receivedate: widget.dmodel.agreementReceivedDate!,
                          ),
                        ],
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
