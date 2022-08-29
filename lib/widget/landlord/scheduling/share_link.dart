import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/widget/Landlord/customewidget.dart';

class ShareLink extends StatefulWidget {
  @override
  State<ShareLink> createState() => _ShareLinkState();
}

class _ShareLinkState extends State<ShareLink> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 160, maxHeight: 160),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: myColor.CM_Lead_fill,
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.clear, size: 25),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      GlobleString.Share_Link,
                                      style:
                                          MyStyles.Bold(22, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  const SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      Container(
                                        width: 530,
                                        child: TextFormField(
                                          initialValue:
                                              "https://www.ren-hogar.com/link/",
                                          style: MyStyles.Medium(
                                              14, myColor.text_color),
                                          decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.blue,
                                                      width: 2)),
                                              enabledBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0)),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              fillColor: myColor.white,
                                              filled: true),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      InkWell(
                                        onTap: () {},
                                        child: CustomeWidget.AddSimpleButton(
                                            GlobleString.Copy_Link),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //},
            ),
          ),
        ),
      ),
    );
  }
}
