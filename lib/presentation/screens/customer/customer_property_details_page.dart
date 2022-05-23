import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/customer/customer_portal_action.dart';
import 'package:silverhome/domain/actions/customer/customer_property_details_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/customer/customer_property_details_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:silverhome/widget/customer/customer_property_card.dart';

//final formatCurrency = new NumberFormat.simpleCurrency();
final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final format1 = new NumberFormat.currency(locale: "en_US", symbol: "");

class CustomerPropertyDetailsPage extends StatefulWidget {
  const CustomerPropertyDetailsPage({
    this.LID,
  });

  final String? LID;

  @override
  _CustomerPropertyDetailsPageState createState() =>
      _CustomerPropertyDetailsPageState();
}

class _CustomerPropertyDetailsPageState
    extends State<CustomerPropertyDetailsPage> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();
  int imgindex = 0;
  bool isloading = false;

  late OverlayEntry loader;
  ScrollController _scrollController = ScrollController();

  final CarouselController _controller = CarouselController();
  final CarouselController _controllerProperty = CarouselController();
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 170,
      color: Colors.white,
      padding: EdgeInsets.only(left: 80, right: 80),
      child: ConnectState<CustomerPropertyDetailsState>(
        map: (state) => state.customerPropertyDetailsState,
        where: notIdentical,
        builder: (cpdState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                child: InkWell(
                  onTap: () {
                    _store.dispatch(UpdateCustomerPortal_pageindex(0));
                  },
                  child: Text(
                    GlobleString.CSM_BacktoFeaturedListings,
                    style: MyStyles.SemiBold(
                        14, myColor.CM_Prop_detail_header_fill),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Container(
                height: height - 210,
                color: Colors.white,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      propertyheader(cpdState),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  slickImage(cpdState),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  discription(cpdState),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  features(cpdState),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailsView(cpdState),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  addLeadView(cpdState),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            includeUtility(cpdState),
                            notincludeUtility(cpdState),
                            restriction(cpdState),
                            Expanded(child: SizedBox())
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      similerList(cpdState),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget propertyheader(CustomerPropertyDetailsState? cpdState) {
    String rentAmount = "";

    if (cpdState!.RentAmount != null && cpdState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(cpdState.RentAmount.replaceAll(",", "")))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return Container(
      width: width,
      height: 70,
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: new BoxDecoration(
        color: myColor.CM_Prop_detail_header_fill,
        borderRadius: BorderRadius.all(Radius.circular(2)),
        border:
            Border.all(color: myColor.CM_Prop_detail_header_border, width: 1),
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cpdState.Suiteunit.toString() +
                    ((cpdState.Suiteunit != null &&
                            cpdState.Suiteunit.trim().isNotEmpty)
                        ? "-"
                        : "") +
                    cpdState.PropertyAddress,
                style: MyStyles.Medium(20, myColor.white),
                // textAlign: TextAlign.start,
              ),
              Text(
                cpdState.City +
                    ", " +
                    cpdState.Province +
                    ", " +
                    cpdState.CountryName +
                    " " +
                    cpdState.Postalcode,
                style: MyStyles.Medium(14, myColor.white),
                // textAlign: TextAlign.start,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* Text(
                cpdState.RentAmount != null && cpdState.RentAmount != ""
                    ? '${formatCurrency.format(int.parse(cpdState.RentAmount))}'
                    : "",
                style: MyStyles.Medium(20, myColor.white),
                //textAlign: TextAlign.start,
              ),*/
              Text(
                rentAmount,
                style: MyStyles.Medium(20, myColor.white),
                //textAlign: TextAlign.start,
              ),
              Text(
                GlobleString.CSM_permonth,
                style: MyStyles.Medium(14, myColor.white),
                //textAlign: TextAlign.start,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget slickImage(CustomerPropertyDetailsState? cpdState) {
    return Column(
      children: [
        cpdState!.propertyImagelist.length > 0
            ? Container(
                width: width,
                height: 400,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: myColor.CM_Prop_card_fill,
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  border:
                      Border.all(color: myColor.CM_Prop_card_border, width: 2),
                  /* image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: CustomNetworkImage(
                      Weburl.image_API +
                          cpdState.propertyImagelist[imgindex].id.toString(),
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
                    Weburl.image_API +
                        cpdState.propertyImagelist[imgindex].id.toString(),
                    scale: 1.5,
                    headers: {
                      'Authorization':
                          'bearer ' + Prefs.getString(PrefsName.userTokan),
                      'ApplicationCode': Weburl.API_CODE,
                    },
                  ),
                ),
              )
            : Container(
                width: width,
                height: 400,
                decoration: new BoxDecoration(
                  color: myColor.CM_Prop_card_fill,
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  border:
                      Border.all(color: myColor.CM_Prop_card_border, width: 2),
                ),
                padding: EdgeInsets.all(40),
                child: Image.asset(
                  "assets/images/cp_placeholder.png",
                  alignment: Alignment.center,
                  fit: BoxFit.fitHeight,
                ),
              ),
        SizedBox(
          height: 10,
        ),
        cpdState.propertyImagelist.length > 0
            ? Container(
                height: 100,
                child: Row(
                  children: [
                    cpdState.propertyImagelist.length > 4
                        ? IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 24,
                            onPressed: () {
                              _controller.previousPage();
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            iconSize: 24,
                            color: Colors.transparent,
                            onPressed: () {
                              //_controller.previousPage();
                            },
                          ),
                    Expanded(
                      child: Container(
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 2.0,
                            enlargeCenterPage: false,
                            viewportFraction: 1,
                          ),
                          carouselController: _controller,
                          itemCount:
                              (cpdState.propertyImagelist.length / 4).round(),
                          itemBuilder: (context, index, realIdx) {
                            var resultArray = <int>[];
                            int first = index * 4;

                            if (first < cpdState.propertyImagelist.length) {
                              resultArray.add(first);
                            }
                            if ((first + 1) <
                                cpdState.propertyImagelist.length) {
                              resultArray.add(first + 1);
                            }
                            if ((first + 2) <
                                cpdState.propertyImagelist.length) {
                              resultArray.add(first + 2);
                            }
                            if ((first + 3) <
                                cpdState.propertyImagelist.length) {
                              resultArray.add(first + 3);
                            }

                            return Row(
                              children: resultArray.map(
                                (indx) {
                                  return Container(
                                    width: (width / 2) / 5.7,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          imgindex = indx;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: new BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: myColor.CM_Prop_card_fill,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(1)),
                                          border: Border.all(
                                              color:
                                                  myColor.CM_Prop_card_border,
                                              width: 2),
                                        ),
                                        child: FadeInImage(
                                          fit: BoxFit.fill,
                                          placeholder: AssetImage(
                                              'assets/images/cp_placeholder.png'),
                                          image: CustomNetworkImage(
                                            Weburl.image_API +
                                                cpdState
                                                    .propertyImagelist[indx].id
                                                    .toString(),
                                            scale: 1.5,
                                            headers: {
                                              'Authorization': 'bearer ' +
                                                  Prefs.getString(
                                                      PrefsName.userTokan),
                                              'ApplicationCode':
                                                  Weburl.API_CODE,
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ).toList(),
                            );
                          },
                        ),
                      ),
                    ),
                    cpdState.propertyImagelist.length > 4
                        ? IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 24,
                            onPressed: () {
                              _controller.nextPage();
                            },
                          )
                        : IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 24,
                            color: Colors.transparent,
                            onPressed: () {
                              //_controller.nextPage();
                            },
                          ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Widget discription(CustomerPropertyDetailsState? cpdState) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_Aboutthesuite,
            style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            cpdState!.PropertyDescription,
            style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget features(CustomerPropertyDetailsState? cpdState) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_Features,
            style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          GridView.builder(
            itemCount: cpdState!.PropertyAmenitieslist.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              childAspectRatio: 12,
            ),
            itemBuilder: (context, index) {
              return Container(
                width: width,
                height: 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: new BoxDecoration(
                        color: myColor.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: myColor.black,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        cpdState.PropertyAmenitieslist[index].Feature
                            .toString(),
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget includeUtility(CustomerPropertyDetailsState? cpdState) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_Includedutilities,
            style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemCount: cpdState!.PropertyUtilitieslist.length,
            shrinkWrap: true,
            itemBuilder: (
              context,
              index,
            ) {
              return Container(
                width: width,
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: new BoxDecoration(
                        color: myColor.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: myColor.black,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        cpdState.PropertyUtilitieslist[index].Feature
                            .toString(),
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget notincludeUtility(CustomerPropertyDetailsState? cpdState) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_NotIncludedutilities,
            style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemCount: cpdState!.PropertyNotIncludedUtilitieslist.length,
            shrinkWrap: true,
            itemBuilder: (
              context,
              index,
            ) {
              return Container(
                width: width,
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: new BoxDecoration(
                        color: myColor.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: myColor.black,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        cpdState.PropertyNotIncludedUtilitieslist[index].Feature
                            .toString(),
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget restriction(CustomerPropertyDetailsState? cpdState) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_Restrictions,
            style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemCount: cpdState!.restrictionlist.length,
            shrinkWrap: true,
            itemBuilder: (
              context,
              index,
            ) {
              return Container(
                width: width,
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 5,
                      height: 5,
                      decoration: new BoxDecoration(
                        color: myColor.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: myColor.black,
                          width: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                        cpdState.restrictionlist[index] != null
                            ? cpdState.restrictionlist[index].displayValue
                                .toString()
                            : "",
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget similerList(CustomerPropertyDetailsState? cpdState) {
    List<PropertyData> propertylist = updateList(cpdState);

    return Container(
      width: width,
      //height: 430,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              GlobleString.CSM_Similarlistings,
              style: MyStyles.Medium(22, myColor.CM_Prop_card_text2),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          if (propertylist.length < 4)
            Container(
              height: 430,
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: propertylist.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CSM_PropertyCard(
                    callbackOnItem: () {
                      getFeaturePropertyDetails(propertylist[index], cpdState!);
                    },
                    propertyData: propertylist[index],
                    pos: index,
                    cdwidth: 300,
                  );
                },
              ),
            ),
          if (propertylist.length > 4)
            Container(
              width: width,
              height: 430,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  propertylist.length > 4
                      ? IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 24,
                          onPressed: () {
                            _controllerProperty.previousPage();
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: 24,
                          color: Colors.transparent,
                          onPressed: () {
                            //_controller.previousPage();
                          },
                        ),
                  Expanded(
                    child: Container(
                      //alignment: Alignment.center,
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          aspectRatio: 2.0,
                          enlargeCenterPage: false,
                          viewportFraction: 1,
                        ),
                        carouselController: _controllerProperty,
                        itemCount: MediaQuery.of(context).size.width < 1400
                            ? (propertylist.length / 3).round()
                            : (propertylist.length / 4).round(),
                        itemBuilder: (context, index, realIdx) {
                          var resultArray = <int>[];

                          int mcount =
                              MediaQuery.of(context).size.width < 1400 ? 3 : 4;

                          //int first = index * mcount;
                          int first = index * mcount;

                          if (first < propertylist.length) {
                            resultArray.add(first);
                          }
                          if ((first + 1) < propertylist.length) {
                            resultArray.add(first + 1);
                          }
                          if ((first + 2) < propertylist.length) {
                            resultArray.add(first + 2);
                          }
                          if (mcount == 4) {
                            if ((first + 3) < propertylist.length) {
                              resultArray.add(first + 3);
                            }
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: resultArray.map(
                              (index) {
                                return CSM_PropertyCard(
                                  callbackOnItem: () {
                                    getFeaturePropertyDetails(
                                        propertylist[index], cpdState!);
                                  },
                                  propertyData: propertylist[index],
                                  pos: index,
                                  cdwidth: MediaQuery.of(context).size.width <
                                          1400
                                      ? MediaQuery.of(context).size.width / 4
                                      : MediaQuery.of(context).size.width / 5.2,
                                );
                              },
                            ).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  propertylist.length > 4
                      ? IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 24,
                          onPressed: () {
                            _controllerProperty.nextPage();
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 24,
                          color: Colors.transparent,
                          onPressed: () {
                            //_controller.nextPage();
                          },
                        ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<PropertyData> updateList(CustomerPropertyDetailsState? cpdState) {
    List<PropertyData> propertylist = <PropertyData>[];

    for (int i = 0; i < cpdState!.propertylist.length; i++) {
      PropertyData propertyData = cpdState.propertylist[i];

      if (cpdState.PropID != propertyData.ID) {
        propertylist.add(propertyData);
      }
    }
    return propertylist;
  }

  Widget detailsView(CustomerPropertyDetailsState? cpdState) {
    String sqrft = "";

    if (cpdState!.PropertySizeinsquarefeet != null &&
        cpdState.PropertySizeinsquarefeet != "") {
      String squareft = format1.format(int.parse(
          cpdState.PropertySizeinsquarefeet.replaceAll(",", "").toString()));
      sqrft = squareft.replaceAll(".00", "");
    }

    return Container(
      width: width,
      height: 216,
      decoration: new BoxDecoration(
        color: myColor.white,
        borderRadius: BorderRadius.all(
          Radius.circular(1),
        ),
        border: Border.all(
          color: myColor.CM_Prop_card_border,
          width: 1,
        ),
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            GlobleString.CSM_Details,
            style: MyStyles.Medium(24, myColor.CM_Prop_card_text2),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: myColor.white,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        cpdState.PropertyBedrooms +
                            " " +
                            GlobleString.CSM_Bedroom,
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_bedroom.png",
                        width: 23,
                        height: 23,
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
                        cpdState.PropertyBathrooms +
                            " " +
                            GlobleString.CSM_Bathroom,
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_bathroom.png",
                        width: 20,
                        height: 20,
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
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_sqft.png",
                        width: 20,
                        height: 20,
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
                        cpdState.Parkingstalls + " " + GlobleString.CSM_Parking,
                        style: MyStyles.Medium(14, myColor.CM_Prop_card_text2),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Image.asset(
                        "assets/images/cp_parking.png",
                        width: 20,
                        height: 20,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            color: myColor.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: myColor.CM_Prop_card_fill,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      border: Border.all(
                          color: myColor.CM_Prop_card_border, width: 1),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.CSM_Furnishings,
                          style:
                              MyStyles.Medium(16, myColor.CM_Prop_detail_text1),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          cpdState.furnishingValue != null
                              ? cpdState.furnishingValue!.displayValue
                                  .toString()
                              : "",
                          style:
                              MyStyles.Medium(20, myColor.CM_Prop_card_text2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    decoration: new BoxDecoration(
                      color: myColor.CM_Prop_card_fill,
                      borderRadius: BorderRadius.all(
                        Radius.circular(3),
                      ),
                      border: Border.all(
                          color: myColor.CM_Prop_card_border, width: 1),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.CSM_Available,
                          style:
                              MyStyles.Medium(16, myColor.CM_Prop_detail_text1),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          cpdState.dateofavailable != null &&
                                  cpdState.dateofavailable != ""
                              ? new DateFormat("MMM dd")
                                  .format(
                                      DateTime.parse(cpdState.dateofavailable))
                                  .toString()
                              : "",
                          style:
                              MyStyles.Medium(20, myColor.CM_Prop_card_text2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget addLeadView(CustomerPropertyDetailsState? cpdState) {
    return Container(
      width: width,
      //height: 560,
      decoration: new BoxDecoration(
        color: myColor.CM_Lead_fill,
        borderRadius: BorderRadius.all(
          Radius.circular(1),
        ),
        /* border: Border.all(
          color: myColor.CM_Lead_border,
          width: 1,
        ),*/
      ),
      padding: EdgeInsets.all(20),
      child: isloading
          ? Container()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  GlobleString.CSM_Lead_title,
                  style: MyStyles.Medium(20, myColor.CM_Prop_card_text2),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: FocusScope(
                    node: _focusScopeNode,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.CSM_Lead_Firstname,
                                    style: MyStyles.Medium(
                                        14, myColor.CM_Prop_card_text2),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: cpdState!.Lead_firstname,
                                    textAlign: TextAlign.start,
                                    autofocus: true,
                                    //focusNode: _focus1,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(25),
                                    ],
                                    decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.CM_Prop_card_border,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(15),
                                      fillColor: myColor.white,
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      _store.dispatch(
                                          UpdateCPDLead_firstname(value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.CSM_Lead_Lastname,
                                    style: MyStyles.Medium(
                                        14, myColor.CM_Prop_card_text2),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: cpdState.Lead_lastname,
                                    textAlign: TextAlign.start,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.CM_Prop_card_border,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(15),
                                      fillColor: myColor.white,
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      _store.dispatch(
                                          UpdateCPDLead_lastname(value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.CSM_Lead_Email,
                                    style: MyStyles.Medium(
                                        14, myColor.CM_Prop_card_text2),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: cpdState.Lead_email,
                                    textAlign: TextAlign.start,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(50),
                                    ],
                                    decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.CM_Prop_card_border,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(15),
                                      fillColor: myColor.white,
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      _store
                                          .dispatch(UpdateCPDLead_email(value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    GlobleString.CSM_Lead_Phone,
                                    style: MyStyles.Medium(
                                        14, myColor.CM_Prop_card_text2),
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    initialValue: cpdState.Lead_phone,
                                    textAlign: TextAlign.start,
                                    style:
                                        MyStyles.Medium(14, myColor.text_color),
                                    inputFormatters: [
                                      MaskedInputFormatter("(000) 000 0000")
                                    ],
                                    decoration: InputDecoration(
                                      //border: InputBorder.none,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.blue, width: 2),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: myColor.CM_Prop_card_border,
                                            width: 1.0),
                                      ),
                                      isDense: true,
                                      hintText: "(000) 000 0000",
                                      hintStyle: MyStyles.Medium(
                                          14, myColor.CM_Prop_card_border),
                                      contentPadding: EdgeInsets.all(15),
                                      fillColor: myColor.white,
                                      filled: true,
                                    ),
                                    onChanged: (value) {
                                      _store
                                          .dispatch(UpdateCPDLead_phone(value));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        /* SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                           Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobleString.CSM_Lead_Noofoccupants,
                                          style: MyStyles.Medium(
                                              14, myColor.CM_Prop_card_text2),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 35,
                                          color: Colors.white,
                                          // ignore: missing_required_param
                                          child: DropdownSearch<String>(
                                            key: UniqueKey(),
                                            mode: Mode.MENU,
                                            defultHeight: 250,
                                            isError: false,
                                            enablecolor:
                                                myColor.CM_Prop_card_border,
                                            errorcolor: myColor.errorcolor,
                                            focuscolor: myColor.blue,
                                            focusWidth: 2,
                                            popupBackgroundColor: myColor.white,
                                            items: [
                                              "1",
                                              "2",
                                              "3",
                                              "4",
                                              "5",
                                              "6",
                                              "7",
                                              "8",
                                              "9",
                                              "10",
                                              "10+"
                                            ],
                                            hint: "0",
                                            showSearchBox: false,
                                            selectedItem: cpdState.Lead_occupant
                                                .toString(),
                                            textstyle: MyStyles.Medium(
                                                14, myColor.text_color),
                                            isFilteredOnline: true,
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateCPDLead_occupant(
                                                      value.toString()));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          GlobleString.CSM_Lead_Noofchildren,
                                          style: MyStyles.Medium(
                                              14, myColor.CM_Prop_card_text2),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          height: 35,
                                          color: Colors.white,
                                          // ignore: missing_required_param
                                          child: DropdownSearch<String>(
                                            key: UniqueKey(),
                                            mode: Mode.MENU,
                                            defultHeight: 250,
                                            errorcolor: myColor.errorcolor,
                                            enablecolor:
                                                myColor.CM_Prop_card_border,
                                            focuscolor: myColor.blue,
                                            focusWidth: 2,
                                            popupBackgroundColor: myColor.white,
                                            items: [
                                              "0",
                                              "1",
                                              "2",
                                              "3",
                                              "4",
                                              "5",
                                              "5+"
                                            ],
                                            hint: "0",
                                            showSearchBox: false,
                                            selectedItem: cpdState.Lead_children
                                                .toString(),
                                            textstyle: MyStyles.Medium(
                                                14, myColor.text_color),
                                            isFilteredOnline: true,
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateCPDLead_children(
                                                      value.toString()));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.CSM_Lead_AdditionalInformation,
                                  style: MyStyles.Medium(
                                      14, myColor.CM_Prop_card_text2),
                                  textAlign: TextAlign.start,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  GlobleString.Optional,
                                  style: MyStyles.Regular(12, myColor.optional),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              initialValue: cpdState.Lead_additionalInfo,
                              maxLines: 6,
                              textAlign: TextAlign.start,
                              style: MyStyles.Medium(14, myColor.text_color),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(250),
                              ],
                              decoration: InputDecoration(
                                //border: InputBorder.none,
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: myColor.blue, width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myColor.CM_Prop_card_border,
                                      width: 1.0),
                                ),
                                isDense: true,
                                contentPadding: EdgeInsets.all(15),
                                fillColor: myColor.white,
                                filled: true,
                              ),
                              onChanged: (value) {
                                _store.dispatch(UpdateCPDLead_additionalInfo(
                                    value.toString()));
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                _checkValidation(context, cpdState);
                              },
                              child: Container(
                                height: 35,
                                width: 100,
                                padding: EdgeInsets.only(left: 25, right: 25),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: myColor.Circle_main,
                                ),
                                child: Text(
                                  GlobleString.CSM_Lead_Submit,
                                  style: MyStyles.Medium(14, myColor.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  RefreshstartTime() async {
    setState(() {
      isloading = true;
    });

    new Timer(Duration(milliseconds: 100), updateLoading);
  }

  updateLoading() {
    setState(() {
      isloading = false;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? pickedStartDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext? context, Widget? child) {
        return Theme(
          data: new ThemeData(
            primarySwatch: MaterialColor(0xFF010B32, Helper.color),
            accentColor: myColor.Circle_main,
          ),
          child: child!,
        );
      },
    );

    if (pickedStartDate != null) {
      Helper.Log("Start Data", pickedStartDate.toString());
    }
  }

  getFeaturePropertyDetails(
      PropertyData propertyData1, CustomerPropertyDetailsState cpdState) async {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    String propId = propertyData1.ID.toString();

    await ApiManager().getPropertyRestriction_Customer(context, propId,
        (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(UpdateCPDRestrictionlist(restrictionlist));
      } else {
        _store.dispatch(UpdateCPDRestrictionlist([]));
      }
    });

    await ApiManager().getPropertyImagesDSQ(context, propId,
        (status, responce, PropertyImageMediaInfolist) {
      if (status) {
        _store.dispatch(UpdateCPDPropertyImageList(PropertyImageMediaInfolist));
      } else {
        _store.dispatch(UpdateCPDPropertyImageList([]));
      }
    });

    await ApiManager().getPropertyAmanityUtility(context, propId,
        (status, responce, amenitieslist, utilitylist) async {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        List<PropertyAmenitiesUtility> new_amenitieslist =
            <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> new_utilitylist =
            <PropertyAmenitiesUtility>[];

        List<PropertyAmenitiesUtility> new_notincludedutilitylist =
            <PropertyAmenitiesUtility>[];

        for (PropertyAmenitiesUtility proam in amenitieslist) {
          if (proam.value == "1") {
            new_amenitieslist.add(proam);
          }
        }

        for (PropertyAmenitiesUtility proam1 in utilitylist) {
          if (proam1.value == "1") {
            new_utilitylist.add(proam1);
          }
        }

        for (PropertyAmenitiesUtility proam2 in utilitylist) {
          if (proam2.value == "2") {
            new_notincludedutilitylist.add(proam2);
          }
        }

        _store.dispatch(UpdateCPDPropertyAmenitiesList(new_amenitieslist));
        _store.dispatch(UpdateCPDPropertyUtilitiesList(new_utilitylist));
        _store.dispatch(UpdateCPDPropertyNotIncludedUtilitiesList(
            new_notincludedutilitylist));
      } else {
        _store.dispatch(UpdateCPDPropertyAmenitiesList([]));
        _store.dispatch(UpdateCPDPropertyUtilitiesList([]));
        _store.dispatch(UpdateCPDPropertyNotIncludedUtilitiesList([]));
        await ApiManager().getPropertyFeaturelist(context);
      }
    });

    await ApiManager().getPropertyDetails(context, propId,
        (status, responce, propertyData) async {
      if (status) {
        _store.dispatch(UpdateCPDpropertylist(cpdState.propertylist));

        await ApiManager().Customer_bindPropertyData(propertyData!);

        imgindex = 0;
        _scrollController.jumpTo(0);

        RefreshstartTime();

        loader.remove();
      } else {
        loader.remove();
      }
    });
  }

  Future<void> _checkValidation(
      BuildContext context, CustomerPropertyDetailsState? cpdState) async {
    if (cpdState!.Lead_firstname == null || cpdState.Lead_firstname.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_Firstname, false);
    } else if (cpdState.Lead_lastname == null ||
        cpdState.Lead_lastname.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_Lastname, false);
    } else if (cpdState.Lead_email == null || cpdState.Lead_email.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_email, false);
    } else if (Helper.ValidEmail(cpdState.Lead_email.trim().toString()) !=
        true) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_valid_email, false);
    } else if (cpdState.Lead_phone == null || cpdState.Lead_phone.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_phone, false);
    } else if (Helper.ValidPhonenumber(cpdState.Lead_phone.toString())) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_valid_phone, false);
    }
    /*else if (cpdState.Lead_occupant == null ||
        cpdState.Lead_occupant == "0") {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_occupant, false);
    } else if (cpdState.Lead_children == null || cpdState.Lead_children == "") {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_children, false);
    }*/
    /* else if (cpdState.Lead_additionalInfo == null ||
        cpdState.Lead_additionalInfo.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.CSM_Lead_error_additionalinfo, false);
    }*/
    else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      await ApiManager().checkEmailAddressCustomer(
          context, cpdState.PropID, cpdState.Lead_email, (status, responce) {
        if (status) {
          PersonId personid = new PersonId();
          personid.firstName = cpdState.Lead_firstname;
          personid.lastName = cpdState.Lead_lastname;
          personid.email = cpdState.Lead_email;
          personid.mobileNumber = cpdState.Lead_phone;
          personid.Country_Code = "CA";
          personid.Dial_Code = "+1";

          ApplicantIdCustomer applicationid = new ApplicantIdCustomer();
          applicationid.note = cpdState.Lead_additionalInfo;
          applicationid.NumberOfChildren = cpdState.Lead_children.toString();
          applicationid.NumberOfOccupant = cpdState.Lead_occupant.toString();
          applicationid.personId = personid;

          AddLeadCustomer addlead = new AddLeadCustomer();
          addlead.propId = cpdState.PropID;
          addlead.applicationStatus = "1";
          addlead.docReviewStatus = "2";
          addlead.referenceStatus = null;
          addlead.leaseStatus = "2";
          addlead.applicantId = applicationid;
          addlead.Owner_ID = widget.LID;

          leadcall(addlead);
        } else {
          loader.remove();
          if (responce == "1") {
            ToastUtils.showCustomToast(
                context, GlobleString.CSM_Lead_already_Email_new, false);
          } else {
            ToastUtils.showCustomToast(context, responce, false);
          }
        }
      });
    }
  }

  void leadcall(AddLeadCustomer addlead) {
    ApiManager().insetCustomerLead(context, addlead, (error, respoce) {
      if (error) {
        loader.remove();

        ToastUtils.showCustomToast(
            context, GlobleString.CSM_Lead_Successfully, true);

        RefreshstartTime();

        _store.dispatch(UpdateCPDLead_firstname(""));
        _store.dispatch(UpdateCPDLead_lastname(""));
        _store.dispatch(UpdateCPDLead_email(""));
        _store.dispatch(UpdateCPDLead_phone(""));
        _store.dispatch(UpdateCPDLead_occupant("0"));
        _store.dispatch(UpdateCPDLead_children("0"));
        _store.dispatch(UpdateCPDLead_additionalInfo(""));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
