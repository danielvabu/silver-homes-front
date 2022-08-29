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

class ListOfAttendees extends StatelessWidget {
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
                minWidth: 800, maxWidth: 800, minHeight: 500, maxHeight: 500),
            child: Container(
              height: 500,
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 60.0,
                                      child: Image.network(
                                          'https://silverhome1.s3.amazonaws.com/files/20220824150755237_1661353675069.png')),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      GlobleString.CAL_List_of_Attendees,
                                      style:
                                          MyStyles.Bold(22, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Container(),
                                    style: ElevatedButton.styleFrom(
                                        shape: CircleBorder(),
                                        padding: EdgeInsets.all(15),
                                        primary: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Container(
                              color: Colors.white,
                              width: double.infinity,
                              padding: const EdgeInsets.all(30.0),
                              child: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0, vertical: 20.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black12, width: 2.0),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5.0)),
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString.CAL_Event_Details,
                                                style: MyStyles.Bold(
                                                    20, myColor.text_color),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 20.0),
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString
                                                    .CAL_Event_Type_Name,
                                                style: MyStyles.Bold(
                                                    16, myColor.text_color),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                  'Showing - 867 Hamilton Street'),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString
                                                    .CAL_Event_Description,
                                                style: MyStyles.Bold(
                                                    16, myColor.text_color),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text('N/A'),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString.CAL_Property_Name,
                                                style: MyStyles.Bold(
                                                    16, myColor.text_color),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text("Jardin's Lookout"),
                                            ],
                                          ),
                                          const SizedBox(height: 10.0),
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString.CAL_Location,
                                                style: MyStyles.Bold(
                                                    16, myColor.text_color),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(
                                                  '867 Hamilton Street, Vancouver, BC, V7N 3K4, Canada'),
                                            ],
                                          ),
                                        ],
                                      )),
                                  const SizedBox(height: 20.0),
                                  Row(
                                    children: [
                                      Text(
                                        GlobleString.CAL_Time_Zone,
                                        style: MyStyles.Bold(
                                            15, myColor.text_color),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        "Pacific Standard Time (PST)",
                                        style: MyStyles.Bold(
                                            15, myColor.text_color),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                  Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    color: myColor.TA_table_header,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 15),
                                    child: Text('Wednesday - June 8, 2022',
                                        style: TextStyle(
                                            color: myColor.text_color,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  Container(
                                    //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                                    color: myColor.TA_light,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                            width: 8 * 20,
                                            child: Text('10:00 - 10:20 AM',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                            width: 8 * 30,
                                            child: Text('Abigail Quinn',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 8 * 25,
                                          child: Text('Confirmed',
                                              style: TextStyle(
                                                  color: myColor.CAL_green)),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 10),
                                            height: 40,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              //isexpand!? "assets/images/circle_up.png" : "assets/images/circle_down.png",
                                              "assets/images/circle_up.png",
                                              height: 19,
                                              //width: 20,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                                    color: myColor.TA_light,
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Divider(),
                                        Text(
                                          GlobleString.LMV_AV_Rating,
                                          style: MyStyles.Medium(
                                              14, myColor.text_color),
                                        ),
                                        const SizedBox(height: 5.0),
                                        RatingBar.builder(
                                          initialRating: 4,
                                          allowHalfRating: false,
                                          glow: false,
                                          itemBuilder: (context, index) =>
                                              const Icon(
                                            Icons.star,
                                            color: myColor.blue,
                                          ),
                                          onRatingUpdate: (rating) {
                                            //_store.dispatch(UpdateADV_rating(rating));
                                            //_changeData();
                                          },
                                          itemCount: 5,
                                          itemSize: 25.0,
                                          unratedColor: myColor.TA_Border,
                                          direction: Axis.horizontal,
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          GlobleString.LMV_AV_Note,
                                          style: MyStyles.Medium(
                                              14, myColor.text_color),
                                          textAlign: TextAlign.start,
                                        ),
                                        const SizedBox(height: 5.0),
                                        TextFormField(
                                          //initialValue: addVendorState.Note,
                                          textAlign: TextAlign.start,
                                          style: MyStyles.Medium(
                                              14, myColor.text_color),
                                          maxLines: 4,
                                          maxLength: 10000,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10000),
                                          ],
                                          decoration: const InputDecoration(
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myColor.blue,
                                                    width: 2.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: myColor.gray,
                                                    width: 1.0),
                                              ),
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              fillColor: myColor.white,
                                              filled: true),
                                          onChanged: (value) {
                                            //_store.dispatch(UpdateADV_Note(value));
                                            //_changeData();
                                          },
                                        ),
                                        const SizedBox(height: 10.0),
                                        InkWell(
                                          onTap: () {},
                                          child: CustomeWidget.AddSimpleButton(
                                              GlobleString.SAVE),
                                        ),
                                        const SizedBox(height: 15.0),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                                    color: myColor.TA_dark,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                            width: 8 * 20,
                                            child: Text('10:00 - 10:20 AM',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                            width: 8 * 30,
                                            child: Text('Barney Stinson',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 8 * 25,
                                          child: Text('Pending confirmation',
                                              style: TextStyle(
                                                  color: myColor.CAL_orange)),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 10),
                                            height: 40,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              //isexpand!? "assets/images/circle_up.png" : "assets/images/circle_down.png",
                                              "assets/images/circle_down.png",
                                              height: 19,
                                              //width: 20,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    //color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
                                    color: myColor.TA_light,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 10),
                                        SizedBox(
                                            width: 8 * 20,
                                            child: Text('10:00 - 10:20 AM',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                            width: 8 * 30,
                                            child: Text('Cal Winston',
                                                maxLines: 3)),
                                        const SizedBox(width: 8),
                                        SizedBox(
                                          width: 8 * 25,
                                          child: Text('Confirmed',
                                              style: TextStyle(
                                                  color: myColor.CAL_green)),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 15, right: 10),
                                            height: 40,
                                            width: 30,
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              //isexpand!? "assets/images/circle_up.png" : "assets/images/circle_down.png",
                                              "assets/images/circle_down.png",
                                              height: 19,
                                              //width: 20,
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 20, right: 20),
                                child: Container(),
                              ),
                            )
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
