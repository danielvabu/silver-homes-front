import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

class PropertyAmenitiesHeader extends StatefulWidget {
  @override
  _PropertyAmenitiesHeaderState createState() =>
      _PropertyAmenitiesHeaderState();
}

class _PropertyAmenitiesHeaderState extends State<PropertyAmenitiesHeader> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;
    return columnHeader();
  }

  Widget columnHeader() {
    return Container(
      width: 850,
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _headerRow(),
      ),
    );
  }

  List<Widget> _headerRow() {
    var result = <Widget>[];
    result.add(_headerAmenities(GlobleString.PS3_Property_Features_Amenities));
    result.add(_headerIncuding(
        GlobleString.PS3_Property_Features_Included_in_the_rent));
    result.add(_headerAvailable(GlobleString.PS3_Property_Features_Available));
    result.add(
        _headerNoAvailable(GlobleString.PS3_Property_Features_Notavailable));
    return result;
  }

  Widget _headerAmenities(String text) {
    return Container(
      height: 60,
      width: 250,
      color: myColor.white,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: MyStyles.SemiBold(14, myColor.black),
      ),
    );
  }

  Widget _headerIncuding(String text) {
    return Container(
      height: 60,
      width: 200,
      color: myColor.pf_incude,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(14, myColor.black),
      ),
    );
  }

  Widget _headerAvailable(String text) {
    return Container(
      height: 60,
      width: 200,
      color: myColor.pf_available,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }

  Widget _headerNoAvailable(String text) {
    return Container(
      height: 60,
      width: 200,
      color: myColor.pf_incude,
      alignment: Alignment.center,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }
}
