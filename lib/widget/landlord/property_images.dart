import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';

import '../internet/_network_image_web.dart';

typedef CallbackOnItem = void Function();
typedef CallbackOnFeatured = void Function(bool flag);

class PropertyImagesCard extends StatefulWidget {
  PropertyImageMediaInfo propertyImageMediaInfo;
  int pos;
  final CallbackOnItem _callbackOnItemDelete;
  final CallbackOnFeatured _callbackOnFeatured;

  PropertyImagesCard({
    required CallbackOnItem callbackOnItemDelete,
    required CallbackOnFeatured callbackOnFeatured,
    required PropertyImageMediaInfo modelclass,
    required int pos,
  })  : this.propertyImageMediaInfo = modelclass,
        this.pos = pos,
        this._callbackOnItemDelete = callbackOnItemDelete,
        this._callbackOnFeatured = callbackOnFeatured;

  @override
  _PropertyImagesCardState createState() => _PropertyImagesCardState();
}

class _PropertyImagesCardState extends State<PropertyImagesCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 130,
      width: 165,
      margin: EdgeInsets.all(10),
      child: Stack(
        children: [
          widget.propertyImageMediaInfo.islive! &&
                  widget.propertyImageMediaInfo.url != ""
              ? Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      widget._callbackOnFeatured(true);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 150,
                          decoration: new BoxDecoration(
                            color: myColor.white,
                            border: Border.all(
                                width: widget.propertyImageMediaInfo.IsFavorite!
                                    ? 3
                                    : 2,
                                color: widget.propertyImageMediaInfo.IsFavorite!
                                    ? myColor.blue
                                    : myColor.CM_Prop_card_border),
                          ),
                          child: FadeInImage(
                            fit: BoxFit.fill,
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
                            image: CustomNetworkImage(
                              Weburl.image_API +
                                  widget.propertyImageMediaInfo.id.toString(),
                              scale: 1,
                              headers: {
                                'Authorization': 'bearer ' +
                                    Prefs.getString(PrefsName.userTokan),
                                'ApplicationCode': Weburl.API_CODE,
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          widget.propertyImageMediaInfo.IsFavorite! != null &&
                                  widget.propertyImageMediaInfo.IsFavorite!
                              ? GlobleString.PS3_Property_FeaturedImage
                              : "",
                          style:
                              MyStyles.SemiBold(14, myColor.CM_Prop_card_text2),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                    onTap: () {
                      widget._callbackOnFeatured(false);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100.0,
                          width: 150,
                          decoration: new BoxDecoration(
                            color: myColor.white,
                            border: Border.all(
                                width: 2, color: myColor.CM_Prop_card_border),
                          ),
                          child: Image.memory(
                            widget.propertyImageMediaInfo.appImage!,
                            fit: BoxFit.contain,
                            width: 150,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "",
                          style: MyStyles.Medium(14, myColor.featureimage_txt),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                widget._callbackOnItemDelete();
              },
              hoverColor: Colors.transparent,
              child: Container(
                width: 30,
                height: 30,
                decoration: new BoxDecoration(
                    color: myColor.white,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    border: Border.all(color: myColor.black, width: 1)),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/ic_delete.png',
                  width: 15,
                  height: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
