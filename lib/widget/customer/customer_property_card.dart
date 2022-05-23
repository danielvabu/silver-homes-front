import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';

typedef CallbackOnItem = void Function();

//final formatCurrency = new NumberFormat.simpleCurrency();
final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final format1 = new NumberFormat.currency(locale: "en_US", symbol: "");

class CSM_PropertyCard extends StatefulWidget {
  PropertyData propertyData;
  int pos;
  double cdwidth;
  final CallbackOnItem _callbackOnItem;

  CSM_PropertyCard({
    required CallbackOnItem callbackOnItem,
    required PropertyData propertyData,
    required int pos,
    required double cdwidth,
  })  : this.propertyData = propertyData,
        this.pos = pos,
        this.cdwidth = cdwidth,
        this._callbackOnItem = callbackOnItem;

  @override
  _CSM_PropertyCardState createState() => _CSM_PropertyCardState();
}

class _CSM_PropertyCardState extends State<CSM_PropertyCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return widget.cdwidth == 0
        ? Container(
            height: 390,
            margin: EdgeInsets.all(20),
            decoration: new BoxDecoration(
              color: myColor.white,
              borderRadius: BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: myColor.CM_Prop_card_border, width: 1),
            ),
            child: cardview(),
          )
        : Container(
            height: 390,
            width: widget.cdwidth,
            margin: EdgeInsets.all(10),
            decoration: new BoxDecoration(
              color: myColor.white,
              borderRadius: BorderRadius.all(Radius.circular(2)),
              border: Border.all(color: myColor.CM_Prop_card_border, width: 1),
            ),
            child: cardview(),
          );
  }

  cardview() {
    String rentAmount = "";
    String sqrft = "";

    if (widget.propertyData.rentAmount != null &&
        widget.propertyData.rentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(widget.propertyData.rentAmount!.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    if (widget.propertyData.size != null && widget.propertyData.size != "") {
      String squareft = format1.format(int.parse(
          widget.propertyData.size.toString().replaceAll(",", "").toString()));
      sqrft = squareft.replaceAll(".00", "");
    }

    return InkWell(
      onTap: () {
        widget._callbackOnItem();
      },
      hoverColor: Colors.transparent,
      child: Column(
        children: [
          if (widget.propertyData.Media_ID != null &&
              widget.propertyData.Media_ID!.isNotEmpty)
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                /*image: new DecorationImage(
                  fit: BoxFit.fill,
                  image: CustomNetworkImage(
                    Weburl.image_API + widget.propertyData.Media_ID.toString(),
                    scale: 1.5,
                    headers: {
                      'Authorization':
                          'bearer ' + Prefs.getString(PrefsName.userTokan),
                           'ApplicationCode': Weburl.API_CODE,
                    },
                  ),
                ),*/
              ),
              child: FadeInImage(
                fit: BoxFit.fill,
                placeholder: AssetImage('assets/images/cp_placeholder.png'),
                image: CustomNetworkImage(
                  Weburl.image_API + widget.propertyData.Media_ID.toString(),
                  scale: 1.5,
                  headers: {
                    'Authorization':
                        'bearer ' + Prefs.getString(PrefsName.userTokan),
                    'ApplicationCode': Weburl.API_CODE,
                  },
                ),
              ),
            )
          else
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: myColor.CM_Prop_card_fill,
              padding: EdgeInsets.all(20),
              child: Image.asset(
                "assets/images/cp_placeholder.png",
                alignment: Alignment.center,
                fit: BoxFit.fitHeight,
                //height: 200,
                //width: 200,
              ),
            ),
          Container(
            color: myColor.CM_Prop_card_border,
            height: 1,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: myColor.white,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.CSM_Price_month,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      /* Text(
                        widget.propertyData.rentAmount != null &&
                                widget.propertyData.rentAmount != ""
                            ? '${formatCurrency.format(int.parse(widget.propertyData.rentAmount!))}'
                            : "",
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),*/
                      Text(
                        rentAmount,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        GlobleString.CSM_Furnishings,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.propertyData.furnishing != null
                            ? widget.propertyData.furnishing!.displayValue
                            : "",
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        GlobleString.CSM_Available,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text1),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.propertyData.dateAvailable != null &&
                                widget.propertyData.dateAvailable != ""
                            ? new DateFormat("MMM dd")
                                .format(DateTime.parse(
                                    widget.propertyData.dateAvailable!))
                                .toString()
                            : "",
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Text(
                widget.propertyData.suiteUnit! +
                    ((widget.propertyData.suiteUnit != null &&
                            widget.propertyData.suiteUnit!.trim().isNotEmpty)
                        ? "-"
                        : "") +
                    widget.propertyData.propertyAddress! +
                    ",\n" +
                    widget.propertyData.city! +
                    ", " +
                    widget.propertyData.province! +
                    ", " +
                    widget.propertyData.country!,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 3,
                style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            color: myColor.CM_Prop_card_border,
            height: 1,
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: myColor.white,
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.propertyData.bedrooms.toString() +
                            " " +
                            GlobleString.CSM_Bedroom,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_bedroom.png",
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: myColor.CM_Prop_card_border,
                  width: 1,
                  height: 40,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.propertyData.bathrooms.toString() +
                            " " +
                            GlobleString.CSM_Bathroom,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_bathroom.png",
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: myColor.CM_Prop_card_border,
                  width: 1,
                  height: 40,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        sqrft + " " + GlobleString.CSM_Sqft,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_sqft.png",
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  color: myColor.CM_Prop_card_border,
                  width: 1,
                  height: 40,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        widget.propertyData.parkingStalls.toString() +
                            " " +
                            GlobleString.CSM_Parking,
                        style: MyStyles.Medium(11, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_parking.png",
                        width: 17,
                        height: 17,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
