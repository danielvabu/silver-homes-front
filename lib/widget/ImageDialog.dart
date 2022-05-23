import 'package:flutter/material.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';

class ImageDialog extends StatelessWidget {
  final String? mid;

  ImageDialog(this.mid);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.all(100),
                margin: EdgeInsets.only(top: 30, bottom: 30),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  image: new DecorationImage(
                    fit: BoxFit.contain,
                    image: CustomNetworkImage(
                      Weburl.image_API + mid.toString(),
                      scale: 1,
                      headers: {
                        'Authorization':
                            'bearer ' + Prefs.getString(PrefsName.userTokan),
                        'ApplicationCode': Weburl.API_CODE,
                      },
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0.94, -1.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        color: myColor.Circle_main),
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.close,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

/* child: GestureDetector(
  onTap: () {
  Navigator.of(context).pop();
  },
  ),*/
}
