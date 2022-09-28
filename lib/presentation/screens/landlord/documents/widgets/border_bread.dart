import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:silverhome/common/mycolor.dart';

class BreadCumb extends StatefulWidget {
  String bread;
  BreadCumb({Key? key, this.bread = ""}) : super(key: key);

  @override
  State<BreadCumb> createState() => _BreadCumbState();
}

class _BreadCumbState extends State<BreadCumb> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: ClipPath(
            clipper: ArrowClipper(20, 50, Edge.RIGHT),
            child: Container(
              height: 70,
              width: 190,
              padding: EdgeInsets.only(right: 10),
              color: myColor.drawselectcolor,
              child: Center(
                  child: Text(
                "${widget.bread}",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              )),
            )));
  }
}
