import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';

class AppBackground {
  var stylebackgroid1 = Container(
      decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: Colors.grey, width: 2),
  ));

  var statuscard = BoxDecoration(
    color: myColor.fnl_status_card_fill,
    borderRadius: BorderRadius.circular(5),
    border: Border.all(color: myColor.fnl_status_card_border, width: 1),
  );

  var editrequest = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    color: myColor.Circle_main,
  );
  var addlead = BoxDecoration(
    border: Border.all(
      color: myColor.gray,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(4.0),
  );
}
