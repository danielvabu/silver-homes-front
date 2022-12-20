import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';

typedef VoidCallName = void Function(PropertyData propertyData);
typedef VoidCallDetails = void Function(PropertyData propertyData);
typedef VoidCallTenantDetails = void Function(PropertyData propertyData);

class LandLordPropertyItem extends StatefulWidget {
  final VoidCallName _callbackPropertyName;
  final VoidCallDetails _callbackDetails;
  final VoidCallTenantDetails _callbackTenantDetails;
  List<PropertyData> listdata;

  LandLordPropertyItem({
    required List<PropertyData> listdata1,
    required VoidCallDetails onPressDetails,
    required VoidCallTenantDetails onPressTenantDetails,
    required VoidCallName onPressName,
  })  : listdata = listdata1,
        _callbackDetails = onPressDetails,
        _callbackTenantDetails = onPressTenantDetails,
        _callbackPropertyName = onPressName;

  @override
  _LandLordPropertyItemState createState() => _LandLordPropertyItemState();
}

class _LandLordPropertyItemState extends State<LandLordPropertyItem> {
  double height = 0, width = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 264,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<PropertyData> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          height: 40,
          color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata[Index], Index),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(PropertyData model, int Index) {
    var result = <Widget>[];
    //result.add(_datavaluePropertyId(model));
    result.add(_datavalueProperty(model));
    result.add(_datavalueUnit(model));
    result.add(_datavalueCity(model));
    result.add(_datavalueCountry(model));
    result.add(_datavaluePropertyType(model));
    result.add(_datavalueVacancy(model));
    result.add(_datavalueApplicantName(model));
    result.add(_datavalueStatus(model));
    result.add(_datavalueActiveInactive(model, Index));
    result.add(_actionPopup(model));
    return result;
  }

  Widget _datavaluePropertyId(PropertyData model) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: width / 16,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.ID!,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueProperty(PropertyData model) {
    return InkWell(
      onTap: () {
        widget._callbackPropertyName(model);
      },
      child: Container(
        height: 40,
        width: width / 7,
        margin: EdgeInsets.only(left: 10),
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

  Widget _datavalueUnit(PropertyData model) {
    return Container(
      height: 40,
      width: width / 12,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.suiteUnit!,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCity(PropertyData model) {
    return Container(
      height: 40,
      width: width / 10,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.city!,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueCountry(PropertyData model) {
    return Container(
      height: 40,
      width: width / 11,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.country!,
        textAlign: TextAlign.left,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluePropertyType(PropertyData model) {
    return Container(
      height: 40,
      width: width / 11,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.propertyType != null ? model.propertyType!.displayValue : "",
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueVacancy(PropertyData model) {
    return Container(
      height: 40,
      width: width / 13,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.Vacancy == null
            ? GlobleString.PH_Vacancy_Vacant
            : model.Vacancy!
                ? GlobleString.PH_Vacancy_Occupied
                : GlobleString.PH_Vacancy_Vacant, //model.province!,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueApplicantName(PropertyData model) {
    return InkWell(
      onTap: () {
        widget._callbackTenantDetails(model);
      },
      child: Container(
        height: 40,
        width: width / 10,
        margin: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.TenantName.toString(),
          child: Text(
            model.TenantName.toString(),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueStatus(PropertyData model) {
    return Container(
      height: 40,
      width: width / 18,
      margin: EdgeInsets.only(left: 15),
      alignment: Alignment.centerLeft,
      child: model.PropDrafting != 3 || !model.isAgreedTandC!
          ? SvgPicture.asset("assets/images/pro_progress_new.svg")
          : SvgPicture.asset("assets/images/pro_complated_new.svg"),
    );
  }

  Widget _datavalueActiveInactive(PropertyData model, int index) {
    return Container(
      height: 40,
      width: width / 11,
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            model.isActive!
                ? GlobleString.PH_Property_Active
                : GlobleString.PH_Property_InActive, //model.province!,
            textAlign: TextAlign.center,
            style: MyStyles.Medium(12,
                model.isActive! ? myColor.propertyOn1 : myColor.propertyOff),
          ),
          /*FlutterSwitch(
            width: 55.0,
            height: 25.0,
            valueFontSize: 10.0,
            toggleSize: 20.0,
            value: model.isActive!,
            borderRadius: 30.0,
            padding: 2.0,
            activeColor: myColor.propertyOn,
            activeText: "ON",
            activeTextColor: myColor.white,
            inactiveColor: myColor.gray,
            inactiveText: "OFF",
            inactiveTextColor: myColor.white,
            showOnOff: true,
            onToggle: (val) {

              if (val) {
                widget._callbackActive(model, index);
              } else {
                widget._callbackInActive(model, index);
              }
            },
          ),*/
          Expanded(child: Container())
        ],
      ),
    );
  }

  Widget _actionPopup(PropertyData model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        //width: 30,
        margin: EdgeInsets.only(left: 10, right: 20),
        alignment: Alignment.centerRight,
        child: PopupMenuButton(
          onSelected: (value) {
            widget._callbackDetails(model);
          },
          child: Container(
            height: 40,
            width: 20,
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 2,
              child: Text(
                GlobleString.PH_ACT_ViewDetails,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
