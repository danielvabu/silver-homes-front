import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef VoidCallbackTaxt = void Function(String text);

class SearchBoxView extends StatefulWidget {
  final VoidCallbackTaxt _callbacktext;

  SearchBoxView({
    required VoidCallbackTaxt callbackOnChanetext,
  }) : _callbacktext = callbackOnChanetext;

  @override
  _SearchBoxViewState createState() => _SearchBoxViewState();
}

class _SearchBoxViewState extends State<SearchBoxView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        border: Border.all(
          color: myColor.TA_Border,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: <Widget>[
          new Expanded(
            child: TextField(
              onChanged: (value) {
                widget._callbacktext(value.toString());
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintStyle: MyStyles.Medium(14, myColor.hintcolor),
                contentPadding: EdgeInsets.all(10),
                isDense: true,
                hintText: GlobleString.LL_Search,
              ),
              style: MyStyles.Medium(14, myColor.text_color),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8, right: 5),
            child: Icon(
              Icons.search,
              color: Colors.black,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
