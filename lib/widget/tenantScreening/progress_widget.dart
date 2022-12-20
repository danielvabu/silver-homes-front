import 'package:flutter/material.dart';

import '../../common/mystyles.dart';
import 'package:silverhome/common/mycolor.dart';

class StepCompletionWidget extends StatefulWidget {
  final int indexOfCompletion;
  final int currentIndex;
  final int numberOfSteps;
  final List<String>? stepsText;
  final List<Widget> content;

  const StepCompletionWidget({required this.indexOfCompletion, required this.currentIndex,
      required this.numberOfSteps, required this.content,
      Key? key, this.stepsText})
      : super(key: key);

  @override
  State<StepCompletionWidget> createState() => _StepCompletionWidgetState();
}

class _StepCompletionWidgetState extends State<StepCompletionWidget> {
  int currentIndex = 1;
  List<String> stepsText = [];
  @override
  void initState() {
    stepsText.addAll(widget.stepsText??[]);
    if (stepsText.length < widget.numberOfSteps) {
      for (int i = stepsText.length; i < widget.numberOfSteps; i++) {
        stepsText.add("Paso ${i + 1}");
      }
    }

    currentIndex = widget.indexOfCompletion;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(color: Colors.red,child: stepsIndicator(stepsText)),
          SingleChildScrollView(
              //controller: controller,
              child: Column(
            children: [
              widget.content[currentIndex],
            ],
          )),
        ],
      ),
    );
  }

  Widget stepsIndicator(List<String> stepsTextArr) {
    return Container(
      width: 1000,
      //height: 100,
      margin: const EdgeInsets.only(top: 15),
      //alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          step(stepsTextArr[0], 0, currentIndex),
          const SizedBox(width: 35.0),
          step(stepsTextArr[1], 1, currentIndex),
          const SizedBox(width: 35.0),
          step(stepsTextArr[2], 2, currentIndex),
          const SizedBox(width: 35.0),
          step(stepsTextArr[3], 3, currentIndex),
        ],
      ),
    );
  }

  InkWell step(String text, int index, int currentIndex) {
    return InkWell(
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon(currentIndex, index),
          const SizedBox(height: 5.0),
          textW(text)
        ],
      ),
    );
  }

  Text textW(String text) {
    return Text(
      text,
      style: MyStyles.SemiBold(13, myColor.text_color),
      textAlign: TextAlign.center,
    );
  }

  Container icon(int currentIndex, int index) {
    return Container(
      alignment: Alignment.topLeft,
      child: Image.asset(
        currentIndex >= index
            ? "assets/images/ic_circle_check.png"
            : "assets/images/ic_circle_fill.png",
        width: 30,
        height: 30,
        alignment: Alignment.topLeft,
      ),
    );
  }
}
