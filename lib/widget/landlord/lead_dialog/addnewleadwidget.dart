import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/newlead.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';

typedef Callbackdelete = void Function(int index);

class AddNewLeadWidget extends StatefulWidget {
  List<NewLead> newleadlist;
  NewLead dmodel;
  int pos, count;
  final Callbackdelete _callbackDelete;

  AddNewLeadWidget(
      {required Callbackdelete onPressedDelete,
      required List<NewLead> newleadlist1,
      required int count,
      required NewLead dmodel1,
      required int pos})
      : this.dmodel = dmodel1,
        this.newleadlist = newleadlist1,
        this.pos = pos,
        this.count = count,
        this._callbackDelete = onPressedDelete;

  @override
  _AddNewLeadWidgetState createState() => _AddNewLeadWidgetState();
}

class _AddNewLeadWidgetState extends State<AddNewLeadWidget> {
  final _store = getIt<AppStore>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 350,
      padding: EdgeInsets.only(left: 30, right: 30),
      child: FocusScope(
        node: _focusScopeNode,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.NL_Lead_no + (widget.pos + 1).toString(),
                        style: MyStyles.Medium(16, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.NL_First_name,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        initialValue: widget.dmodel.firstname,
                        textAlign: TextAlign.start,
                        autofocus: true,
                        style: MyStyles.Medium(14, myColor.text_color),
                        decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            hintText: GlobleString.NL_hint_First_name,
                            //errorStyle: MyStyles.Regular(12, myColor.errorcolor),
                            //errorText: widget.dmodel.firstname!=null || widget.dmodel.firstname!="" ? "":GlobleString.NL_error_First_name,
                            hintStyle: MyStyles.Regular(12, myColor.hintcolor),
                            contentPadding: EdgeInsets.all(10),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {
                          widget.dmodel.firstname = value.toString();
                          //widget.newleadlist.insert(widget.pos, widget.dmodel);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.NL_Last_name,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        initialValue: widget.dmodel.lastname,
                        textAlign: TextAlign.start,
                        style: MyStyles.Medium(14, myColor.text_color),
                        decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            // errorText: widget.dmodel.lastname!=null || widget.dmodel.lastname!="" ? "":GlobleString.NL_error_Last_name,
                            // errorStyle: MyStyles.Regular(12, myColor.errorcolor),
                            hintText: GlobleString.NL_hint_Last_name,
                            hintStyle: MyStyles.Regular(12, myColor.hintcolor),
                            contentPadding: EdgeInsets.all(10),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {
                          widget.dmodel.lastname = value.toString();
                          //widget.newleadlist.insert(widget.pos, widget.dmodel);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.NL_Email,
                        style: MyStyles.Medium(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        initialValue: widget.dmodel.Email,
                        textAlign: TextAlign.start,
                        style: MyStyles.Medium(14, myColor.text_color),
                        decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            // errorText: widget.dmodel.Email!=null || widget.dmodel.Email!="" ? "":GlobleString.NL_error_Last_name,
                            // errorStyle: MyStyles.Regular(12, myColor.errorcolor),
                            hintText: GlobleString.NL_hint_Enter_email,
                            hintStyle: MyStyles.Regular(12, myColor.hintcolor),
                            contentPadding: EdgeInsets.all(10),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {
                          widget.dmodel.Email = value.toString();
                          //widget.newleadlist.insert(widget.pos, widget.dmodel);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            GlobleString.NL_Phone_Number,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            GlobleString.Optional,
                            style: MyStyles.Medium(10, myColor.optional),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: myColor.gray,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CountryCodePicker(
                              onChanged: (value) {
                                widget.dmodel.CountryCode =
                                    value.code.toString();
                                widget.dmodel.CountrydialCode =
                                    value.dialCode.toString();
                                //widget.newleadlist.insert(widget.pos, widget.dmodel);
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: widget.dmodel.CountryCode,
                              showFlag: true,
                              textStyle:
                                  MyStyles.Medium(14, myColor.text_color),
                              dialogTextStyle:
                                  MyStyles.Medium(14, myColor.text_color),
                              //showDropDownButton: true,
                            ),
                            Expanded(
                              child: TextFormField(
                                initialValue: widget.dmodel.phoneNumber,
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  MaskedInputFormatter("(000) 000 0000")
                                ],
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.all(10),
                                  isDense: true,
                                ),
                                style: MyStyles.Medium(14, myColor.text_color),
                                onChanged: (value) {
                                  widget.dmodel.phoneNumber = value.toString();
                                  //widget.newleadlist.insert(widget.pos, widget.dmodel);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            GlobleString.Notes,
                            style: MyStyles.Medium(14, myColor.text_color),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            GlobleString.Optional,
                            style: MyStyles.Medium(10, myColor.optional),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        initialValue: widget.dmodel.PrivateNotes,
                        textAlign: TextAlign.start,
                        style: MyStyles.Medium(14, myColor.text_color),
                        maxLines: 4,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(450),
                        ],
                        decoration: InputDecoration(
                            //border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.blue, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: myColor.gray, width: 1.0),
                            ),
                            isDense: true,
                            hintText: GlobleString.NL_hint_notes_here,
                            hintStyle: MyStyles.Regular(12, myColor.hintcolor),
                            contentPadding: EdgeInsets.all(10),
                            fillColor: myColor.white,
                            filled: true),
                        onChanged: (value) {
                          widget.dmodel.PrivateNotes = value.toString();
                          //widget.newleadlist.insert(widget.pos, widget.dmodel);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            widget.count > 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget._callbackDelete(widget.pos);
                        },
                        child: Container(
                          height: 35,
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/ic_delete.png",
                            height: 25,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(),
            widget.count > 1
                ? Container(
                    height: 1,
                    color: myColor.TA_tab_devide,
                    margin: EdgeInsets.only(top: 15),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
