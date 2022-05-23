import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/basic_tenant/addvendordata.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/presentation/models/maintenance/edit_maintenance_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/landlord/maintenance_dialog/maintenace_edit_request.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef Callbackdelete = void Function(int index);

class EditAssigneVendorItemWidget extends StatefulWidget {
  AddVendorData dmodel;
  EditMaintenanceState editMaintenanceState;
  int pos, count;
  final Callbackdelete _callbackDelete;

  EditAssigneVendorItemWidget(
      {required Callbackdelete onPressedDelete,
      required int count,
      required EditMaintenanceState editMaintenanceState,
      required AddVendorData dmodel1,
      required int pos})
      : this.dmodel = dmodel1,
        this.pos = pos,
        this.editMaintenanceState = editMaintenanceState,
        this.count = count,
        this._callbackDelete = onPressedDelete;

  @override
  _EditAssigneVendorItemWidgetState createState() =>
      _EditAssigneVendorItemWidgetState();
}

class _EditAssigneVendorItemWidgetState
    extends State<EditAssigneVendorItemWidget> {
  final _store = getIt<AppStore>();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  bool isLoad = false;
  bool change = false;

  @override
  void initState() {
    super.initState();
  }

  _changeData() {
    if (!change) {
      change = true;
      MaintenanceEditRequestDialogBox.changeData = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.Mant_DL_Vendor_Vendor + " " + widget.count.toString(),
          style: MyStyles.Medium(16, myColor.black),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobleString.Mant_DL_Category,
                    style: MyStyles.Medium(12, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 30,
                    // ignore: missing_required_param
                    child: DropdownSearch<SystemEnumDetails>(
                      mode: Mode.MENU,
                      items: widget.editMaintenanceState.filterCategorylist,
                      textstyle: MyStyles.Medium(12, myColor.black),
                      itemAsString: (SystemEnumDetails? u) => u!.displayValue,
                      hint: GlobleString.Select_Category,
                      enabled: widget.editMaintenanceState.selectedCity !=
                                  null &&
                              widget.editMaintenanceState.selectedCity!.length >
                                  0
                          ? true
                          : false,
                      selectedItem: widget.dmodel.selectfilterCategory != null
                          ? widget.dmodel.selectfilterCategory
                          : null,
                      defultHeight: widget.editMaintenanceState
                                      .filterCategorylist.length *
                                  35 >
                              250
                          ? 250
                          : widget.editMaintenanceState.filterCategorylist
                                  .length *
                              35,
                      focuscolor: myColor.blue,
                      focusWidth: 2,
                      onChanged: (value) async {
                        List<VendorData> vendordatalist =
                            await Helper.filtervendor(
                                widget.editMaintenanceState.mainvendordatalist,
                                value!);

                        widget.dmodel.selectfilterCategory = value;
                        widget.dmodel.filtervendordatalist = vendordatalist;
                        widget.dmodel.selectvendor = null;

                        isLoad = true;
                        setState(() {});
                        _changeData();
                        new Timer(Duration(milliseconds: 5), () {
                          isLoad = false;
                          setState(() {});
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobleString.Mant_DL_Vendor_Vendor +
                        " " +
                        widget.count.toString(),
                    style: MyStyles.Medium(12, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  isLoad
                      ? Container(
                          height: 30,
                        )
                      : Container(
                          height: 30,
                          // ignore: missing_required_param
                          child: DropdownSearch<VendorData>(
                            mode: Mode.MENU,
                            items: widget.dmodel.filtervendordatalist,
                            textstyle: MyStyles.Medium(12, myColor.black),
                            itemAsString: (VendorData? u) =>
                                u!.companyName! +
                                "- " +
                                "Rating:" +
                                (u.rating == 0
                                    ? "Not assigned"
                                    : (u.rating.toString() + "/5")),
                            hint: GlobleString.Select_Vendor,
                            enabled: widget.dmodel.selectfilterCategory != null
                                ? true
                                : false,
                            showSearchBox: false,
                            defultHeight: widget.dmodel.filtervendordatalist!
                                            .length *
                                        35 >
                                    250
                                ? 250
                                : widget.dmodel.filtervendordatalist!.length *
                                    35,
                            selectedItem: widget.dmodel.selectvendor != null
                                ? widget.dmodel.selectvendor
                                : null,
                            isFilteredOnline: true,
                            focuscolor: myColor.blue,
                            focusWidth: 2,
                            onChanged: (value) {
                              widget.dmodel.selectvendor = value;
                              _changeData();
                              /*  widget.addMaintenanceState.vendordatalist[widget.pos].selectvendor = value;
                        _store.dispatch(UpdateMAR_vendordatalist(widget.addMaintenanceState.vendordatalist));*/
                            },
                          ),
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
          children: [
            Text(
              GlobleString.Mant_DL_Vendor_Vendor +
                  " " +
                  widget.count.toString() +
                  " " +
                  GlobleString.Mant_DL_Vendor_Instructions,
              style: MyStyles.Medium(12, myColor.black),
              textAlign: TextAlign.center,
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
          initialValue: widget.dmodel.Instruction,
          textAlign: TextAlign.start,
          style: MyStyles.Medium(12, myColor.text_color),
          maxLines: 4,
          decoration: InputDecoration(
            //border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: myColor.blue, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: myColor.gray, width: 1.0),
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(10),
            fillColor: myColor.white,
            filled: true,
          ),
          onChanged: (value) {
            widget.dmodel.Instruction = value;
            _changeData();
            /* widget.addMaintenanceState.vendordatalist[widget.pos].Instruction = value;
            _store.dispatch(UpdateMAR_vendordatalist(widget.addMaintenanceState.vendordatalist));*/
          },
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: () {
                widget._callbackDelete(widget.pos);
              },
              child: Image.asset(
                "assets/images/ic_delete.png",
                height: 22,
                //width: 20,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 1,
          color: myColor.TA_tab_devide,
          //color: myColor.Circle_main,
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
