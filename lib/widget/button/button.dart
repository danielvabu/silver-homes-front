import 'package:flutter/material.dart';
import 'package:silverhome/common/mystyles.dart';

class AppButton {
  static Widget primary({String? title, Color? color}) {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        // color: color,
      ),
      child: Row(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.add_circle,
              color: Colors.white,
              size: 20,
            ),
          ),
          Text(
            title.toString(),
            style: MyStyles.Regular(14, Colors.white),
          ),
        ],
      ),
    );
  }
}
