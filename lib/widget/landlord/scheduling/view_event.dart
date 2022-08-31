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

class ViewEvent extends StatefulWidget {
  const ViewEvent({Key? key}) : super(key: key);

  @override
  State<ViewEvent> createState() => _ViewEventState();
}

class _ViewEventState extends State<ViewEvent> {
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
                minWidth: 700, maxWidth: 700, minHeight: 450, maxHeight: 450),
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
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 15.0,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Container(),
                                          style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              padding: EdgeInsets.all(12),
                                              primary: Colors.yellow),
                                        ),
                                      ),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Showing - 123 Main Street",
                                          style: MyStyles.Bold(
                                              22, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 45.0),
                                      Container(
                                        width: 530,
                                        child: Text(
                                            'Wednesday, June 8 - 4:00 - 4:20pm'),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 45.0),
                                      Container(
                                        width: 530,
                                        child: Text(GlobleString.ET_One_on_one),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child:
                                              Icon(Icons.location_on_outlined)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        width: 530,
                                        child: Text(
                                            "123 Main St, Vancouver, BC V6A 2S5, Canada"),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15.0),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child: Icon(Icons
                                              .supervisor_account_outlined)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        width: 530,
                                        child: Text(
                                            "2" + " " + GlobleString.Guests),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 45.0),
                                      SizedBox(
                                          width: 30.0,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('D',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(12),
                                                primary: Colors.grey),
                                          )),
                                      const SizedBox(width: 10.0),
                                      Container(
                                        child: Text(
                                          "danivabu2015@gmail.com",
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 45.0),
                                      SizedBox(
                                          width: 30.0,
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('J',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            style: ElevatedButton.styleFrom(
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(12),
                                                primary: Color.fromARGB(
                                                    255, 15, 87, 77)),
                                          )),
                                      const SizedBox(width: 10.0),
                                      Container(
                                        child: Text(
                                          "jcjavier1978@gmail.com",
                                          maxLines: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child:
                                              Icon(Icons.notifications_none)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        child: Text("30 minutes before"),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                          width: 15.0,
                                          child: Icon(Icons.calendar_today)),
                                      const SizedBox(width: 30.0),
                                      Container(
                                        child: Text("Briana Liau Chinchanchu"),
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
