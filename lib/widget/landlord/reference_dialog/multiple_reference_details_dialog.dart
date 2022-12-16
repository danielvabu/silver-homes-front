import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/lead_reference.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/widget/alert/circular_loading_widget.dart';

import '../../../presentation/models/landlord_models/reference_questionnaire_details_state.dart';

class MultipleReferenceDetailsDialog extends StatefulWidget {
  final VoidCallback _callbackClose;
  List<LeadReference> leadlist;

  MultipleReferenceDetailsDialog({
    required VoidCallback onPressedClose,
    required List<LeadReference> leadlist,
  })  : _callbackClose = onPressedClose,
        leadlist = leadlist;

  @override
  _MultipleReferenceDetailsDialogState createState() => _MultipleReferenceDetailsDialogState();
}

class _MultipleReferenceDetailsDialogState extends State<MultipleReferenceDetailsDialog> {
  int indexpos = 0;
  bool isloading = true;

  @override
  void initState() {
    apiManagerCall();
    super.initState();
  }

  apiManagerCall() async {
    await Prefs.init();

    ApiManager().getReferenceDetailsAPISingle(context, widget.leadlist[indexpos].referenceId.toString(), (status, responce) {
      if (status) {
        updateMethod();
      } else {
        Helper.Log("respoce", responce);
      }
    });
  }

  void updateMethod() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 800,
              maxWidth: 800,
              minHeight: 800,
            ),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding: EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: isloading
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularLoadingWidget(height: 50),
                          /*Container(
                            height: 200,
                            child: Image.asset(
                              "assets/images/silverhome.png",
                              //width: 180,
                            ),
                          ),*/
                        ],
                      ),
                    )
                  : ConnectState<ReferenceQuestionnaireDetailsState>(
                      map: (state) => state.referenceQuestionnaireDetailsState,
                      where: notIdentical,
                      builder: (refQueState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  alignment: Alignment.topCenter,
                                  //margin: EdgeInsets.only(top: 30.0),
                                  child: Text(
                                    GlobleString.DRQ_Reference_Questionnaire,
                                    style: MyStyles.Medium(20, myColor.text_color),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        widget._callbackClose();
                                      },
                                      child: Icon(Icons.clear, size: 25),
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                indexpos > 0 && widget.leadlist.length > 1
                                    ? InkWell(
                                        onTap: () {
                                          if (indexpos > 0) {
                                            setState(() {
                                              isloading = true;
                                            });

                                            int pos = indexpos - 1;
                                            indexpos--;
                                            nextdetails(pos);
                                          }
                                        },
                                        child: Container(
                                          child: Text(
                                            GlobleString.TA_PREVIEW,
                                            style: MyStyles.Bold(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(),
                                (widget.leadlist.length - 1) > indexpos && widget.leadlist.length > 1
                                    ? InkWell(
                                        onTap: () {
                                          if ((widget.leadlist.length - 1) > indexpos) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            int pos = indexpos + 1;
                                            indexpos++;
                                            nextdetails(pos);
                                          }
                                        },
                                        child: Container(
                                          child: Text(
                                            GlobleString.TA_NEXT,
                                            style: MyStyles.Bold(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Property,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState!.PropertyName,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Reference_Name,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState.ReferenceName,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Phone_Number,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState.ReferencePhone,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 60),
                                Column(
                                  //mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Applicant_Name,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState.ApplicantName,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Relationship,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState.ReferenceRelationShip,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.DRQ_Email,
                                            style: MyStyles.Medium(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            refQueState.ReferenceEmail,
                                            style: MyStyles.Medium(14, myColor.blue),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height - 255,
                              child: SingleChildScrollView(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_Length_of_Tenancy,
                                            style: MyStyles.SemiBold(16, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 30,
                                                width: 150,
                                                //padding: EdgeInsets.only(left: 15, right: 15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  border: Border.all(width: 1, color: myColor.TA_Border),
                                                  color: refQueState.lenth_tenancy == 1 ? myColor.TA_tab_text : Colors.transparent,
                                                ),
                                                child: Text(
                                                  GlobleString.RQ_Under_6_month,
                                                  style: MyStyles.Medium(
                                                      13, refQueState.lenth_tenancy == 1 ? myColor.white : myColor.text_color),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                height: 30,
                                                width: 150,
                                                //padding: EdgeInsets.only(left: 15, right: 15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  border: Border.all(width: 1, color: myColor.TA_Border),
                                                  color: refQueState.lenth_tenancy == 2 ? myColor.TA_tab_text : Colors.transparent,
                                                ),
                                                child: Text(
                                                  GlobleString.RQ_6_months_to_1_year,
                                                  style: MyStyles.Medium(
                                                      13, refQueState.lenth_tenancy == 2 ? myColor.white : myColor.text_color),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                height: 30,
                                                width: 150,
                                                //padding: EdgeInsets.only(left: 15, right: 15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  border: Border.all(width: 1, color: myColor.TA_Border),
                                                  color: refQueState.lenth_tenancy == 3 ? myColor.TA_tab_text : Colors.transparent,
                                                ),
                                                child: Text(
                                                  GlobleString.RQ_1_year_to_2_years,
                                                  style: MyStyles.Medium(
                                                      13, refQueState.lenth_tenancy == 3 ? myColor.white : myColor.text_color),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Container(
                                                height: 30,
                                                width: 150,
                                                //padding: EdgeInsets.only(left: 15, right: 15),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(3)),
                                                  border: Border.all(width: 1, color: myColor.TA_Border),
                                                  color: refQueState.lenth_tenancy == 4 ? myColor.TA_tab_text : Colors.transparent,
                                                ),
                                                child: Text(
                                                  GlobleString.RQ_Over_2_years,
                                                  style: MyStyles.Medium(
                                                      13, refQueState.lenth_tenancy == 4 ? myColor.white : myColor.text_color),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_Reason_For_Departure,
                                            style: MyStyles.SemiBold(16, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            initialValue: refQueState.ReasonDeparture,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(14, myColor.text_color),
                                            maxLines: 5,
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
                                                ),
                                                hintText: GlobleString.RQ_Reason_For_Departure_hint,
                                                hintStyle: MyStyles.Regular(14, myColor.RQ_hint),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(10),
                                                fillColor: myColor.white,
                                                filled: true),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Text(
                                        GlobleString.RQ_question_title,
                                        style: MyStyles.SemiBold(16, myColor.text_color),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_question1_title,
                                            style: MyStyles.SemiBold(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              GlobleString.RQ_question1,
                                              style: MyStyles.Regular(13, myColor.text_color),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  GlobleString.RQ_Poor,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                RatingBarIndicator(
                                                  rating: refQueState.CleanlinessRating,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: myColor.blue,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  GlobleString.RQ_Excellent,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_question2_title,
                                            style: MyStyles.SemiBold(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              GlobleString.RQ_question2,
                                              style: MyStyles.Regular(13, myColor.text_color),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  GlobleString.RQ_Poor,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                RatingBarIndicator(
                                                  rating: refQueState.CommunicationRating,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: myColor.blue,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  GlobleString.RQ_Excellent,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_question3_title,
                                            style: MyStyles.SemiBold(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              GlobleString.RQ_question3,
                                              style: MyStyles.Regular(13, myColor.text_color),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  GlobleString.RQ_Poor,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                RatingBarIndicator(
                                                  rating: refQueState.RespectfulnessRating,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: myColor.blue,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  GlobleString.RQ_Excellent,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_question4_title,
                                            style: MyStyles.SemiBold(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(
                                              GlobleString.RQ_question4,
                                              style: MyStyles.Regular(13, myColor.text_color),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  GlobleString.RQ_Poor,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                RatingBarIndicator(
                                                  rating: refQueState.PaymentPunctualityRating,
                                                  itemBuilder: (context, index) => Icon(
                                                    Icons.star,
                                                    color: myColor.blue,
                                                  ),
                                                  itemCount: 5,
                                                  itemSize: 20.0,
                                                  direction: Axis.horizontal,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  GlobleString.RQ_Excellent,
                                                  style: MyStyles.Regular(12, myColor.RQ_rating),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_question5_title,
                                            style: MyStyles.SemiBold(14, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () {},
                                                  child: Image.asset(
                                                    "assets/images/ic_like.png",
                                                    width: 20,
                                                    height: 20,
                                                    color: refQueState.yesNo ? myColor.blue : myColor.black,
                                                    alignment: Alignment.topLeft,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  GlobleString.RQ_Yes,
                                                  style: MyStyles.Medium(14, refQueState.yesNo ? myColor.blue : myColor.text_color),
                                                  textAlign: TextAlign.center,
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                InkWell(
                                                  onTap: () {},
                                                  child: Image.asset(
                                                    "assets/images/ic_unlike.png",
                                                    width: 20,
                                                    height: 20,
                                                    color: refQueState.yesNo == false ? myColor.blue : myColor.black,
                                                    alignment: Alignment.topLeft,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                Text(
                                                  GlobleString.RQ_No,
                                                  style:
                                                      MyStyles.Medium(14, refQueState.yesNo == false ? myColor.blue : myColor.text_color),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.RQ_Other_Comments,
                                            style: MyStyles.SemiBold(16, myColor.text_color),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(14, myColor.text_color),
                                            maxLines: 5,
                                            readOnly: true,
                                            initialValue: refQueState.OtherComments,
                                            decoration: InputDecoration(
                                                focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
                                                ),
                                                hintText: GlobleString.RQ_Other_Comments_hint,
                                                hintStyle: MyStyles.Regular(14, myColor.RQ_hint),
                                                enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(color: myColor.TA_Border, width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding: EdgeInsets.all(10),
                                                fillColor: myColor.white,
                                                filled: true),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }),
            ),
          ),
        ),
      ),
    );
  }

  nextdetails(int index) {
    Helper.Log("index", index.toString());

    ApiManager().getReferenceDetailsAPISingle(context, widget.leadlist[index].referenceId.toString(), (status, responce) {
      if (status) {
        updateMethod();
      } else {
        Helper.Log("respoce", responce);
      }
    });
  }
}
