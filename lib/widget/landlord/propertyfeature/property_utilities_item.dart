import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/screens/landlord/property/add_edit_property.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';

typedef VoidCallRadio = void Function(int pos, String value);

class PropertyUtilitiesItem extends StatefulWidget {
  final VoidCallRadio _callbackradio;
  List<PropertyAmenitiesUtility> listdata;

  PropertyUtilitiesItem({
    required VoidCallRadio callbackradio,
    required List<PropertyAmenitiesUtility> listdata1,
  })  : listdata = listdata1,
        _callbackradio = callbackradio;

  @override
  _PropertyUtilitiesItemState createState() => _PropertyUtilitiesItemState();
}

class _PropertyUtilitiesItemState extends State<PropertyUtilitiesItem> {
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
      width: 850,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<PropertyAmenitiesUtility> listdata) {
    return ListView.builder(
      //scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          height: 40,
          //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata[Index], Index),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(PropertyAmenitiesUtility model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueName(model, Index));
    result.add(_datavalueIncludeRent(model, Index));
    result.add(_datavalueAvailable(model, Index));
    result.add(_datavalueNoAvailabel(model, Index));
    return result;
  }

  Widget _datavalueName(PropertyAmenitiesUtility model, int Index) {
    return Container(
      height: 40,
      width: 250,
      padding: EdgeInsets.only(left: 10),
      color: myColor.pf_availableavalue,
      alignment: Alignment.centerLeft,
      child: Text(
        model.Feature!,
        textAlign: TextAlign.start,
        style: MyStyles.Medium(14, myColor.black),
      ),
    );
  }

  Widget _datavalueIncludeRent(PropertyAmenitiesUtility model, int Index) {
    return Container(
      height: 40,
      width: 200,
      color: myColor.pf_incudevalue,
      alignment: Alignment.center,
      child: Radio(
        value: "1",
        groupValue: model.value,
        activeColor: myColor.Circle_main,
        onChanged: (value) {
          AddEditProperty.isValueUpdate = true;
          widget._callbackradio(Index, value.toString());
          widget.listdata[Index].value = value.toString();
          _store.dispatch(UpdatePropertyUtilitiesList(widget.listdata));
        },
      ),
    );
  }

  Widget _datavalueAvailable(PropertyAmenitiesUtility model, int Index) {
    return Container(
      height: 40,
      width: 200,
      color: myColor.pf_availableavalue,
      alignment: Alignment.center,
      child: Radio(
        value: "2",
        groupValue: model.value,
        activeColor: myColor.Circle_main,
        onChanged: (value) {
          AddEditProperty.isValueUpdate = true;
          widget._callbackradio(Index, value.toString());
          widget.listdata[Index].value = value.toString();
          _store.dispatch(UpdatePropertyUtilitiesList(widget.listdata));
        },
      ),
    );
  }

  Widget _datavalueNoAvailabel(PropertyAmenitiesUtility model, int Index) {
    return Container(
      height: 40,
      width: 200,
      color: myColor.pf_incudevalue,
      alignment: Alignment.center,
      child: Radio(
        value: "3",
        groupValue: model.value,
        activeColor: myColor.Circle_main,
        onChanged: (value) {
          AddEditProperty.isValueUpdate = true;
          widget._callbackradio(Index, value.toString());
          widget.listdata[Index].value = value.toString();
          _store.dispatch(UpdatePropertyUtilitiesList(widget.listdata));
        },
      ),
    );
  }
}
