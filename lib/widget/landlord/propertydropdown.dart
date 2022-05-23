import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

typedef CallbackSelectItem = void Function(PropertyData? item);

class PropertyDropdown extends StatefulWidget {
  final CallbackSelectItem _callbackSelectVal;
  final List<PropertyData> propertylist1;
  PropertyData? selectpropertyValue;

  PropertyDropdown({
    required CallbackSelectItem onSelectVal,
    required List<PropertyData> propertylist,
    PropertyData? propertyValue,
  })  : _callbackSelectVal = onSelectVal,
        propertylist1 = propertylist,
        selectpropertyValue = propertyValue;

  @override
  _PropertyDropdownState createState() => _PropertyDropdownState();
}

class _PropertyDropdownState extends State<PropertyDropdown> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(
          color: myColor.Circle_main,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      // ignore: missing_required_param
      child: DropdownSearch<PropertyData>(
        mode: Mode.MENU,
        items: widget.propertylist1,
        focusWidth: 1,
        itemAsString: (PropertyData? u) => u!.propertyName!,
        hint: GlobleString.Select_Property,
        defultHeight: widget.propertylist1.length > 5
            ? 300
            : (widget.propertylist1.length * 35) + 50,
        textstyle: MyStyles.Medium(12, myColor.text_color),
        showSearchBox: true,
        selectedItem: widget.selectpropertyValue != null
            ? widget.selectpropertyValue
            : null,
        isFilteredOnline: true,
        onChanged: (data) {
          widget._callbackSelectVal(data);
        },
      ),
    );
  }
}
