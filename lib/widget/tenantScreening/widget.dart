import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/mycolor.dart';
import '../../presentation/models/landlord_models/propertyform_state.dart';

class AppWidgetTenant {
  //LIST STEPS DYNAMIC
  Widget indicatorStepsList({List? steps, List<Function>? tap}) {
    return Container(
        width: 741,
        height: 100,
        margin: const EdgeInsets.only(top: 15),
        alignment: Alignment.center,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: steps!.length,
          itemBuilder: (context, index) {
            return Flexible(
                child: InkWell(
              onTap: () {
                tap![index];
              },
              child: Container(
                  margin: EdgeInsets.only(left: 35.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          Prefs.getBool(PrefsName.PropertyStep1)
                              ? "assets/images/ic_circle_check.png"
                              : "assets/images/ic_circle_fill.png",
                          width: 30,
                          height: 30,
                          alignment: Alignment.topLeft,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        steps![index].toString(),
                        style: MyStyles.SemiBold(13, myColor.text_color),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )),
            ));
          },
        ));
  }

  Widget indicatorSteps(List steps) {
    return Container(
      width: 741,
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          step1(steps),
          const SizedBox(width: 35.0),
          step2(steps),
          const SizedBox(width: 74.0),
          step3(steps),
          const SizedBox(width: 110.0),
          step4(),
        ],
      ),
    );
  }

  InkWell step4() {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              Prefs.getBool(PrefsName.PropertyAgreeTC) &&
                      Prefs.getBool(PrefsName.PropertyStep1) &&
                      Prefs.getBool(PrefsName.PropertyStep2) &&
                      Prefs.getBool(PrefsName.PropertyStep3)
                  ? "assets/images/ic_circle_check.png"
                  : "assets/images/ic_circle_border.png",
              width: 30,
              height: 30,
              alignment: Alignment.topLeft,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            GlobleString.PS_Property_Summary,
            style: MyStyles.SemiBold(13, myColor.text_color),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  InkWell step3(List<dynamic> steps) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              Prefs.getBool(PrefsName.PropertyStep3)
                  ? "assets/images/ic_circle_check.png"
                  : "assets/images/ic_circle_border.png",
              width: 30,
              height: 30,
              alignment: Alignment.topLeft,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            steps![0],
            style: MyStyles.SemiBold(13, myColor.text_color),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  InkWell step2(List<dynamic> steps) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              Prefs.getBool(PrefsName.PropertyStep2)
                  ? "assets/images/ic_circle_check.png"
                  : "assets/images/ic_circle_border.png",
              width: 30,
              height: 30,
              alignment: Alignment.topLeft,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            steps![1],
            style: MyStyles.SemiBold(13, myColor.text_color),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  InkWell step1(List<dynamic> steps) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Image.asset(
              Prefs.getBool(PrefsName.PropertyStep1)
                  ? "assets/images/ic_circle_check.png"
                  : "assets/images/ic_circle_fill.png",
              width: 30,
              height: 30,
              alignment: Alignment.topLeft,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            steps![0],
            style: MyStyles.SemiBold(13, myColor.text_color),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

