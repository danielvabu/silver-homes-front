import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';

class BreadButton extends StatelessWidget {
  final String text;
  final bool isFirstButton;

  BreadButton(this.text, this.isFirstButton);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TriangleClipper(!isFirstButton),
      child: Container(
        color: myColor.drawselectcolor,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
              start: isFirstButton ? 8 : 20, end: 28, top: 8, bottom: 8),
          child: Text(
            text,
            style: TextStyle(
              color: myColor.black,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

class _TriangleClipper extends CustomClipper<Path> {
  final bool twoSideClip;

  _TriangleClipper(this.twoSideClip);

  @override
  Path getClip(Size size) {
    final Path path = new Path();
    if (twoSideClip) {
      path.moveTo(20, 0.0);
      path.lineTo(0.0, size.height / 2);
      path.lineTo(20, size.height);
    } else {
      path.lineTo(0, size.height);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 20, size.height / 2);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
