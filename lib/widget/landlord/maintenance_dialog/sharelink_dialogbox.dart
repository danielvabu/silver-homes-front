import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/tablayer/weburl.dart';

class ShareLinkDialogBox extends StatefulWidget {
  final String mid;
  final VoidCallback _callbackNo;

  ShareLinkDialogBox({
    required String mid,
    required VoidCallback onPressedNo,
  })  : mid = mid,
        _callbackNo = onPressedNo;

  @override
  _ShareLinkDialogBoxState createState() => _ShareLinkDialogBoxState();
}

class _ShareLinkDialogBoxState extends State<ShareLinkDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 600, maxWidth: 600, minHeight: 150, maxHeight: 150),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget._callbackNo();
                        },
                        child: Icon(Icons.clear, size: 25),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      GlobleString.ShareLink_title,
                      style: MyStyles.Medium(20, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: Weburl.CustomerFeaturedPage +
                              Prefs.getString(
                                  PrefsName.user_CustomerFeatureListingURL) +
                              "/" +
                              RouteNames.maintenanceRequest +
                              "/" +
                              widget.mid,
                          textAlign: TextAlign.start,
                          readOnly: true,
                          style: MyStyles.Medium(14, myColor.text_color),
                          decoration: InputDecoration(
                              //border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: myColor.gray, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: myColor.gray, width: 1),
                              ),
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              fillColor: myColor.white,
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          String url = Weburl.CustomerFeaturedPage +
                              Prefs.getString(
                                  PrefsName.user_CustomerFeatureListingURL) +
                              "/" +
                              RouteNames.maintenanceRequest +
                              "/" +
                              widget.mid;

                          print("MaintenancePage" + url);

                          Helper.copyToClipboardHack(context, url);
                        },
                        child: Container(
                          height: 35,
                          padding: EdgeInsets.only(left: 25, right: 25),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                          ),
                          child: Text(
                            GlobleString.ShareLink_Copy,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
