import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/admin_action/admin_portal_action.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/admin_models/admin_property_details_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/ImageDialog.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final formatSize = new NumberFormat.currency(locale: "en_US", symbol: "");

class AdminPropertyDetails extends StatefulWidget {
  @override
  _AdminPropertyDetailsState createState() => _AdminPropertyDetailsState();
}

class _AdminPropertyDetailsState extends State<AdminPropertyDetails> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  double ssheight = 0, sswidth = 0;
  double drawer_width = 230;
  double header_height = 70;

  String? userTokan;
  var font_medium, font_demi, font_regular, font_bold;

  @override
  void initState() {
    Prefs.init();
    fontload();
    userTokan = Prefs.getString(PrefsName.userTokan);
    super.initState();
  }

  void fontload() async {
    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height - 90,
      margin: EdgeInsets.only(top: 10, right: 20, left: 20),
      color: myColor.ps_SummaryBg,
      child: SingleChildScrollView(
        child: Container(
          child: ConnectState<AdminPropertyDetailsState>(
            map: (state) => state.adminPropertyDetailsState,
            where: notIdentical,
            builder: (adminPropertyDetailsState) {
              return Column(
                children: [
                  Container(
                    height: 30,
                    margin: EdgeInsets.only(
                        top: 10, right: 10, left: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (Prefs.getBool(PrefsName.admin_PropertyBack)) {
                              _store.dispatch(UpdateAdminPortalLandlordDetails(
                                  GlobleString.NAV_admin_Landlords));
                            } else if (Prefs.getBool(
                                PrefsName.admin_Landlord_PropertyBack)) {
                              _store.dispatch(UpdateAdminPortalLandlordDetails(
                                  GlobleString.NAV_admin_Landlords));
                            } else {
                              _store.dispatch(UpdateAdminPortalPage(
                                  2, GlobleString.NAV_admin_LeadsTenants));
                            }
                          },
                          child: Container(
                            child: Text(
                              GlobleString.TA_BACK,
                              style: MyStyles.Bold(14, myColor.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Pdfgenerate(adminPropertyDetailsState!);
                          },
                          child: Container(
                            child: Text(
                              GlobleString.TA_exportpdf,
                              style: MyStyles.Bold(14, myColor.blue),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BannerView(adminPropertyDetailsState!),
                  PropertyImages(adminPropertyDetailsState),
                  PropertyDetailsView(adminPropertyDetailsState),
                  PropertySpecificationRestrictionView(
                      adminPropertyDetailsState),
                  PropertyFeatureView(adminPropertyDetailsState),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget BannerView(AdminPropertyDetailsState adminPropertyDetailsState) {
    return Container(
      width: width,
      height: 120,
      color: myColor.Circle_main,
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    adminPropertyDetailsState.PropertyName,
                    style: MyStyles.SemiBold(22, myColor.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    " - ",
                    style: MyStyles.SemiBold(22, myColor.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    adminPropertyDetailsState.Suiteunit,
                    style: MyStyles.SemiBold(20, myColor.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                adminPropertyDetailsState.propertytypeValue == null
                    ? ""
                    : adminPropertyDetailsState
                                .propertytypeValue!.EnumDetailID ==
                            6
                        ? adminPropertyDetailsState.propertytypeOtherValue
                        : adminPropertyDetailsState
                            .propertytypeValue!.displayValue,
                style: MyStyles.Medium(16, myColor.white),
                textAlign: TextAlign.start,
              ),
              Text(
                adminPropertyDetailsState.Suiteunit +
                    " - " +
                    adminPropertyDetailsState.PropertyAddress +
                    ", " +
                    adminPropertyDetailsState.City +
                    ", " +
                    adminPropertyDetailsState.Province +
                    ", " +
                    adminPropertyDetailsState.Postalcode +
                    ", " +
                    adminPropertyDetailsState.CountryName,
                style: MyStyles.Medium(16, myColor.white),
                textAlign: TextAlign.start,
              ),
            ],
          )
        ],
      ),
    );
  }

  PropertyImages(AdminPropertyDetailsState adminPropertyDetailsState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 15, right: 15),
      child: Container(
        height: 186,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.PS1_Property_Images1,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 130,
              width: width,
              alignment: Alignment.centerLeft,
              child: ListView.builder(
                itemCount: adminPropertyDetailsState.propertyImagelist.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  PropertyImageMediaInfo propertyImageMediaInfo =
                      adminPropertyDetailsState.propertyImagelist[index];
                  return Container(
                    height: 120.0,
                    width: 180,
                    margin: EdgeInsets.only(right: 10),
                    decoration: new BoxDecoration(
                      color: myColor.white,
                      border: Border.all(
                          width: 2, color: myColor.CM_Prop_card_border),
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: CustomNetworkImage(
                          Weburl.image_API +
                              propertyImageMediaInfo.id.toString(),
                          scale: 1,
                          headers: {
                            'Authorization': 'bearer ' +
                                Prefs.getString(PrefsName.userTokan),
                            'ApplicationCode': Weburl.API_CODE,
                          },
                        ),
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        await showDialog(
                            context: context,
                            builder: (_) => ImageDialog(
                                propertyImageMediaInfo.id.toString()));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PropertyDetailsView(
      AdminPropertyDetailsState adminPropertyDetailsState) {
    String rentAmount = "";

    if (adminPropertyDetailsState.RentAmount != null &&
        adminPropertyDetailsState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(adminPropertyDetailsState.RentAmount.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return Padding(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
      child: Container(
        width: width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: myColor.white,
                      border: Border.all(color: myColor.ps_boreder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: myColor.TA_Border,
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.PS1_Property_Details,
                          style: MyStyles.SemiBold(16, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Property_type,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState.propertytypeValue ==
                                        null
                                    ? ""
                                    : adminPropertyDetailsState
                                                .propertytypeValue!
                                                .EnumDetailID ==
                                            6
                                        ? adminPropertyDetailsState
                                            .propertytypeOtherValue
                                        : adminPropertyDetailsState
                                            .propertytypeValue!.displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Rental_space,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState.rentalspaceValue ==
                                        null
                                    ? ""
                                    : adminPropertyDetailsState
                                        .rentalspaceValue!.displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Building_name,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState.Buildingname,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.PS1_Property_description,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    adminPropertyDetailsState
                                        .PropertyDescription,
                                    style: MyStyles.Regular(
                                        12, myColor.text_color),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 7,
                                    textAlign: TextAlign.start,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: myColor.white,
                      border: Border.all(color: myColor.ps_boreder, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: myColor.TA_Border,
                          blurRadius: 4.0,
                          spreadRadius: 0.0,
                          offset: Offset(
                            0.0,
                            1.0,
                          ),
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.PS1_Lease_Details,
                          style: MyStyles.SemiBold(16, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Rent_amount,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                rentAmount,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Date_available,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState.dateofavailable ==
                                        null
                                    ? ""
                                    : new DateFormat("dd-MMM-yyyy")
                                        .format(adminPropertyDetailsState
                                            .dateofavailable!)
                                        .toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Rent_payment_frequency,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState
                                            .rentpaymentFrequencyValue ==
                                        null
                                    ? ""
                                    : adminPropertyDetailsState
                                        .rentpaymentFrequencyValue!
                                        .displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Lease_type,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState.leasetypeValue == null
                                    ? ""
                                    : adminPropertyDetailsState
                                        .leasetypeValue!.displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              //flex: 1,
                              child: Text(
                                GlobleString.PS1_Minimum_lease_duration,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            /* Expanded(
                              flex: 3,
                              child: Text(
                                "",
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),*/
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Minimum_lease_Number,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState
                                    .minimumleasedurationnumber,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                GlobleString.PS1_Minimum_lease_Period,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                adminPropertyDetailsState
                                            .minimumleasedurationValue ==
                                        null
                                    ? ""
                                    : adminPropertyDetailsState
                                        .minimumleasedurationValue!
                                        .displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget PropertySpecificationRestrictionView(
      AdminPropertyDetailsState adminPropertyDetailsState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Container(
        width: width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpecificationView(adminPropertyDetailsState),
            SizedBox(
              width: 15,
            ),
            RestrictionView(adminPropertyDetailsState),
            SizedBox(
              width: 15,
            ),
            FeatureView(adminPropertyDetailsState),
          ],
        ),
      ),
    );
  }

  Widget SpecificationView(
      AdminPropertyDetailsState adminPropertyDetailsState) {
    String Size = "";

    if (adminPropertyDetailsState.PropertySizeinsquarefeet != null &&
        adminPropertyDetailsState.PropertySizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          adminPropertyDetailsState.PropertySizeinsquarefeet.replaceAll(",", "")
              .toString()));
      Size = sqft.replaceAll(".00", "");
    }

    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.ps4_Specifications,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_Bedrooms,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adminPropertyDetailsState.PropertyBedrooms,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_Bathrooms,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adminPropertyDetailsState.PropertyBathrooms,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_SquareFootage,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        Size,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_Furnishing,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adminPropertyDetailsState.furnishingValue == null
                            ? ""
                            : adminPropertyDetailsState
                                .furnishingValue!.displayValue,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget RestrictionView(AdminPropertyDetailsState adminPropertyDetailsState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.ps4_Restrictions,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_Allowed,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          //scrollDirection: Axis.vertical,
                          key: UniqueKey(),
                          itemCount:
                              adminPropertyDetailsState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data = adminPropertyDetailsState
                                .restrictionlist[Index];
                            return !data.ischeck!
                                ? Text(
                                    data != null
                                        ? data.displayValue.replaceAll("No", "")
                                        : "",
                                    style: MyStyles.Regular(14, myColor.black),
                                    textAlign: TextAlign.start,
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_NotAllowed,
                        style: MyStyles.Medium(14, myColor.ps_Restriction),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          //scrollDirection: Axis.vertical,
                          key: UniqueKey(),
                          itemCount:
                              adminPropertyDetailsState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data = adminPropertyDetailsState
                                .restrictionlist[Index];
                            return data.ischeck!
                                ? Text(
                                    data != null
                                        ? data.displayValue.replaceAll("No", "")
                                        : "",
                                    style: MyStyles.Regular(
                                        14, myColor.ps_Restriction),
                                    textAlign: TextAlign.start,
                                  )
                                : Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget FeatureView(AdminPropertyDetailsState adminPropertyDetailsState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.PS3_Property_Features,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.ps4_ParkingStalls,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adminPropertyDetailsState.Parkingstalls,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_StorageAvailable,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        adminPropertyDetailsState.storageavailableValue == null
                            ? ""
                            : adminPropertyDetailsState
                                .storageavailableValue!.displayValue,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget PropertyFeatureView(AdminPropertyDetailsState adminPropDetailsState) {
    int Acount1 = 0, Acount2 = 0, Acount3 = 0;
    for (int i = 0;
        i < adminPropDetailsState.Summerypropertyamenitieslist.length;
        i++) {
      PropertyAmenitiesUtility amenitiesUtility =
          adminPropDetailsState.Summerypropertyamenitieslist[i];

      if (amenitiesUtility.value == "1") {
        Acount1++;
      } else if (amenitiesUtility.value == "2") {
        Acount2++;
      } else if (amenitiesUtility.value == "3") {
        Acount3++;
      }
    }

    int Ucount1 = 0, Ucount2 = 0, Ucount3 = 0;
    for (int j = 0;
        j < adminPropDetailsState.Summerypropertyutilitieslist.length;
        j++) {
      PropertyAmenitiesUtility amenitiesUtility =
          adminPropDetailsState.Summerypropertyutilitieslist[j];

      if (amenitiesUtility.value == "1") {
        Ucount1++;
      } else if (amenitiesUtility.value == "2") {
        Ucount2++;
      } else if (amenitiesUtility.value == "3") {
        Ucount3++;
      }
    }

    int AV = Acount1 + Ucount1;
    int AVR = Acount2 + Ucount2;
    int NAV = Acount3 + Ucount3;

    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Container(
        width: width,
        height: gethightofFeature(AV, AVR, NAV),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IncludedInTheRent(adminPropDetailsState, Acount1, Ucount1),
            SizedBox(
              width: 15,
            ),
            AvailableNotIncludedInTheRent(
                adminPropDetailsState, Acount2, Ucount2),
            SizedBox(
              width: 15,
            ),
            NotAvailable(adminPropDetailsState, Acount3, Ucount3)
          ],
        ),
      ),
    );
  }

  double gethightofFeature(int AV, int AVR, int NAV) {
    double Fheight = 0;
    if (AV >= AVR) {
      if (AV >= NAV) {
        Fheight = double.parse((AV * 19).toString());
      } else {
        Fheight = double.parse((NAV * 19).toString());
      }
    } else {
      if (AVR >= NAV) {
        Fheight = double.parse((AVR * 19).toString());
      } else {
        Fheight = double.parse((NAV * 19).toString());
      }
    }

    Helper.Log("Height", Fheight.toString());

    if (Fheight == 0) Fheight = 50;

    return Fheight + 125;
  }

  Widget IncludedInTheRent(
      AdminPropertyDetailsState adminPropDetailsState, int Acount, int Ucount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              child: Text(
                GlobleString.ps4_Features_IncludedIn_The_Rent,
                style: MyStyles.SemiBold(16, myColor.black),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Acount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(
                                              14, myColor.Circle_main),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Ucount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(
                                              14, myColor.Circle_main),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget AvailableNotIncludedInTheRent(
      AdminPropertyDetailsState adminPropDetailsState, int Acount, int Ucount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              child: Text(
                GlobleString
                    .ps4_Features_Available_But_Not_Included_In_The_Rent,
                style: MyStyles.SemiBold(16, myColor.black),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Acount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(
                                              14, myColor.Circle_main),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Ucount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(
                                              14, myColor.Circle_main),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget NotAvailable(
      AdminPropertyDetailsState adminPropDetailsState, int Acount, int Ucount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            BoxShadow(
              color: myColor.TA_Border,
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            )
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 35,
              child: Text(
                GlobleString.ps4_Features_Not_Available,
                style: MyStyles.SemiBold(16, myColor.black),
                textAlign: TextAlign.start,
                maxLines: 2,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: MyStyles.Medium(
                            14, myColor.TA_espand_status_Border),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Acount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(14,
                                              myColor.TA_espand_status_Border),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: MyStyles.Medium(
                            14, myColor.TA_espand_status_Border),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Ucount > 0
                            ? ListView.builder(
                                //scrollDirection: Axis.vertical,
                                key: UniqueKey(),
                                itemCount: adminPropDetailsState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          adminPropDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .Feature!,
                                          style: MyStyles.Regular(14,
                                              myColor.TA_espand_status_Border),
                                          textAlign: TextAlign.start,
                                        )
                                      : Container();
                                },
                              )
                            : Text(
                                "---",
                                style:
                                    MyStyles.Regular(14, myColor.Circle_main),
                                textAlign: TextAlign.start,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> Pdfgenerate(AdminPropertyDetailsState propertyState) async {
    final pdf = pw.Document(
      author: "Silver Home",
      pageMode: PdfPageMode.fullscreen,
      title: "Property Document",
    );

    ssheight = MediaQuery.of(context).size.height;
    sswidth = MediaQuery.of(context).size.width;

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(10),
        build: (pw.Context context) => pw.Container(
          width: sswidth,
          // height: ssheight,
          color: PdfColor.fromHex("#FBFBFB"),
          child: pw.Column(
            children: [
              //Banner view
              PDFBannerView(propertyState),

              // PropertyDetails view
              PDFPropertyDetailsView(propertyState),

              // SpecificationRestrictionView view
              PDFPropertySpecificationRestrictionView(propertyState),

              PDFPropertyFeatureView(propertyState),
            ],
          ),
        ),
      ),
    );

    /*pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return <pw.Widget>[
            pw.Container(
              width: sswidth,
              height: ssheight,
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Column(
                children: [

                  BannerView(propertyState),

                  PropertyDetailsView(propertyState),
                ],
              ),
            ),
            pw.Container(
              width: sswidth,
              height: ssheight,
              color: PdfColor.fromHex("#FBFBFB"),
              child: pw.Column(
                children: [

                  PropertySpecificationRestrictionView(propertyState)
                ],
              ),
            ),
          ];
        },
      ),
    );*/

    String filename = "property_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".pdf";

    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = filename;
    html.document.body!.children.add(anchor);
    anchor.click();
  }

  pw.Widget PDFBannerView(AdminPropertyDetailsState propertyState) {
    return pw.Container(
      width: sswidth,
      height: 70,
      color: PdfColor.fromHex("#010B32"),
      padding: pw.EdgeInsets.all(10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                children: [
                  pw.Text(
                    propertyState.PropertyName,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      font: pw.Font.ttf(font_demi),
                      fontSize: 14,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    " - ",
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      font: pw.Font.ttf(font_demi),
                      fontSize: 14,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    propertyState.Suiteunit,
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      font: pw.Font.ttf(font_demi),
                      fontSize: 14,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
              pw.SizedBox(
                height: 2,
              ),
              pw.Text(
                propertyState.propertytypeValue == null
                    ? ""
                    : propertyState.propertytypeValue!.EnumDetailID == 6
                        ? propertyState.propertytypeOtherValue
                        : propertyState.propertytypeValue!.displayValue,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  font: pw.Font.ttf(font_medium),
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.left,
              ),
              pw.Text(
                propertyState.Suiteunit +
                    " - " +
                    propertyState.PropertyAddress +
                    ", " +
                    propertyState.City +
                    ", " +
                    propertyState.Province +
                    ", " +
                    propertyState.Postalcode +
                    ", " +
                    propertyState.CountryName,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  font: pw.Font.ttf(font_medium),
                  fontSize: 9,
                ),
                textAlign: pw.TextAlign.left,
              ),
            ],
          )
        ],
      ),
    );
  }

  pw.Widget PDFPropertyDetailsView(AdminPropertyDetailsState propertyState) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        child: pw.Column(
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                PDFPropertyDetails(propertyState),
                pw.SizedBox(
                  width: 10,
                ),
                PDFPropertyLeaseDetails(propertyState)
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFPropertyDetails(AdminPropertyDetailsState propertyState) {
    return pw.Expanded(
      child: pw.Container(
        height: 190,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /*boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(10),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              GlobleString.PS1_Property_Details,
              style: pw.TextStyle(
                color: PdfColors.black,
                font: pw.Font.ttf(font_demi),
                fontSize: 11,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Property_type,
                    style: pw.TextStyle(
                      color: PdfColors.black,
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.propertytypeValue == null
                        ? ""
                        : propertyState.propertytypeValue!.EnumDetailID == 6
                            ? propertyState.propertytypeOtherValue
                            : propertyState.propertytypeValue!.displayValue,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Rental_space,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.rentalspaceValue == null
                        ? ""
                        : propertyState.rentalspaceValue!.displayValue,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Building_name,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.Buildingname,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 3,
            ),
            pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  GlobleString.PS1_Property_description,
                  style: pw.TextStyle(
                    color: PdfColor.fromHex("#000000"),
                    font: pw.Font.ttf(font_medium),
                    fontSize: 9,
                  ),
                  textAlign: pw.TextAlign.left,
                ),
                pw.SizedBox(
                  height: 2,
                ),
                pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        propertyState.PropertyDescription,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 8,
                        ),
                        maxLines: 10,
                        textAlign: pw.TextAlign.left,
                        overflow: pw.TextOverflow.span,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFPropertyLeaseDetails(AdminPropertyDetailsState propertyState) {
    String rentAmount = "";

    if (propertyState.RentAmount != null && propertyState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(propertyState.RentAmount.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return pw.Expanded(
      child: pw.Container(
        height: 190,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColors.white,
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /*boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(10),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              GlobleString.PS1_Lease_Details,
              style: pw.TextStyle(
                color: PdfColor.fromHex("#000000"),
                font: pw.Font.ttf(font_demi),
                fontSize: 11,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Rent_amount,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    rentAmount,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Date_available,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.dateofavailable == null
                        ? ""
                        : new DateFormat("dd-MMM-yyyy")
                            .format(propertyState.dateofavailable!)
                            .toString(),
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Rent_payment_frequency,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.rentpaymentFrequencyValue == null
                        ? ""
                        : propertyState.rentpaymentFrequencyValue!.displayValue,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Lease_type,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.leasetypeValue == null
                        ? ""
                        : propertyState.leasetypeValue!.displayValue,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Text(
                    GlobleString.PS1_Minimum_lease_duration,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 2,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Minimum_lease_Number,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.minimumleasedurationnumber,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 4,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Text(
                    GlobleString.PS1_Minimum_lease_Period,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#000000"),
                      font: pw.Font.ttf(font_medium),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
                pw.Expanded(
                  flex: 3,
                  child: pw.Text(
                    propertyState.minimumleasedurationValue == null
                        ? ""
                        : propertyState.minimumleasedurationValue!.displayValue,
                    style: pw.TextStyle(
                      color: PdfColor.fromHex("#010B32"),
                      font: pw.Font.ttf(font_regular),
                      fontSize: 9,
                    ),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFPropertySpecificationRestrictionView(
      AdminPropertyDetailsState propertyState) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            PDFSpecificationView(propertyState),
            pw.SizedBox(
              width: 10,
            ),
            PDFRestrictionView(propertyState),
            pw.SizedBox(
              width: 10,
            ),
            PDFFeatureView(propertyState),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFSpecificationView(AdminPropertyDetailsState propertyState) {
    String Size = "";

    if (propertyState.PropertySizeinsquarefeet != null &&
        propertyState.PropertySizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          propertyState.PropertySizeinsquarefeet.replaceAll(",", "")
              .toString()));
      Size = sqft.replaceAll(".00", "");
    }

    return pw.Expanded(
      child: pw.Container(
        height: 95,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /* boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              GlobleString.ps4_Specifications,
              style: pw.TextStyle(
                color: PdfColors.black,
                font: pw.Font.ttf(font_demi),
                fontSize: 11,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_Bedrooms,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        propertyState.PropertyBedrooms,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_Bathrooms,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        propertyState.PropertyBathrooms,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_SquareFootage,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        Size,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_Furnishing,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        propertyState.furnishingValue == null
                            ? ""
                            : propertyState.furnishingValue!.displayValue,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#000000"),
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFRestrictionView(AdminPropertyDetailsState propertyState) {
    return pw.Expanded(
      child: pw.Container(
        height: 95,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /*boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              GlobleString.ps4_Restrictions,
              style: pw.TextStyle(
                color: PdfColors.black,
                font: pw.Font.ttf(font_demi),
                fontSize: 11,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_Allowed,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.ListView.builder(
                          //scrollDirection: Axis.vertical,
                          itemCount: propertyState.restrictionlist.length,
                          itemBuilder: (pw.Context ctxt, int Index) {
                            SystemEnumDetails data =
                                propertyState.restrictionlist[Index];
                            return pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                child: !data.ischeck!
                                    ? pw.Text(
                                        data != null
                                            ? data.displayValue
                                                .replaceAll("No", "")
                                            : "",
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#000000"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 9,
                                        ),
                                        textAlign: pw.TextAlign.left,
                                      )
                                    : pw.Container());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_NotAllowed,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#878787"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 5,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.ListView.builder(
                          //scrollDirection: Axis.vertical,
                          itemCount: propertyState.restrictionlist.length,
                          itemBuilder: (pw.Context ctxt, int Index) {
                            SystemEnumDetails data =
                                propertyState.restrictionlist[Index];
                            return pw.Container(
                                alignment: pw.Alignment.centerLeft,
                                child: data.ischeck!
                                    ? pw.Text(
                                        data.displayValue.replaceAll("No", ""),
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex("#878787"),
                                          font: pw.Font.ttf(font_regular),
                                          fontSize: 9,
                                        ),
                                        textAlign: pw.TextAlign.left,
                                      )
                                    : pw.Container());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFFeatureView(AdminPropertyDetailsState propertyState) {
    return pw.Expanded(
      child: pw.Container(
        height: 95,
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /* boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              GlobleString.PS3_Property_Features,
              style: pw.TextStyle(
                color: PdfColors.black,
                font: pw.Font.ttf(font_demi),
                fontSize: 11,
              ),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.ps4_ParkingStalls,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        propertyState.Parkingstalls,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
                pw.SizedBox(
                  width: 5,
                ),
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_StorageAvailable,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Text(
                        propertyState.storageavailableValue == null
                            ? ""
                            : propertyState.storageavailableValue!.displayValue,
                        style: pw.TextStyle(
                          color: PdfColors.black,
                          font: pw.Font.ttf(font_regular),
                          fontSize: 9,
                        ),
                        textAlign: pw.TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFPropertyFeatureView(AdminPropertyDetailsState propertyState) {
    int Acount1 = 0, Acount2 = 0, Acount3 = 0;
    for (int i = 0;
        i < propertyState.Summerypropertyamenitieslist.length;
        i++) {
      PropertyAmenitiesUtility amenitiesUtility =
          propertyState.Summerypropertyamenitieslist[i];

      if (amenitiesUtility.value == "1") {
        Acount1++;
      } else if (amenitiesUtility.value == "2") {
        Acount2++;
      } else if (amenitiesUtility.value == "3") {
        Acount3++;
      }
    }

    int Ucount1 = 0, Ucount2 = 0, Ucount3 = 0;
    for (int j = 0;
        j < propertyState.Summerypropertyamenitieslist.length;
        j++) {
      PropertyAmenitiesUtility amenitiesUtility =
          propertyState.Summerypropertyamenitieslist[j];

      if (amenitiesUtility.value == "1") {
        Ucount1++;
      } else if (amenitiesUtility.value == "2") {
        Ucount2++;
      } else if (amenitiesUtility.value == "3") {
        Ucount3++;
      }
    }

    int AV = Acount1 + Ucount1;
    int AVR = Acount2 + Ucount2;
    int NAV = Acount3 + Ucount3;

    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        height: 400, //gethightofFeature(propertyState, AV, AVR, NAV),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            PDFIncludedInTheRent(propertyState, Acount1, Ucount1),
            pw.SizedBox(
              width: 10,
            ),
            PDFAvailableNotIncludedInTheRent(propertyState, Acount2, Ucount2),
            pw.SizedBox(
              width: 10,
            ),
            PDFNotAvailable(propertyState, Acount3, Ucount2)
          ],
        ),
      ),
    );
  }

  pw.Widget PDFIncludedInTheRent(
      AdminPropertyDetailsState propertyState, int Acount, int Ucount) {
    return pw.Expanded(
      child: pw.Container(
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /* boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 35,
              child: pw.Text(
                GlobleString.ps4_Features_IncludedIn_The_Rent,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  font: pw.Font.ttf(font_demi),
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.left,
                maxLines: 2,
              ),
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        child: Acount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyamenitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "1"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#010B32"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.topLeft,
                        child: Ucount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyutilitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "1"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#010B32"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFAvailableNotIncludedInTheRent(
      AdminPropertyDetailsState propertyState, int Acount, int Ucount) {
    return pw.Expanded(
      child: pw.Container(
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /* boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 35,
              child: pw.Text(
                GlobleString
                    .ps4_Features_Available_But_Not_Included_In_The_Rent,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  font: pw.Font.ttf(font_demi),
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.left,
                maxLines: 2,
              ),
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: Acount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyamenitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "2"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#010B32"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#010B32"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: Ucount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyutilitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "2"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#010B32"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#010B32"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PDFNotAvailable(
      AdminPropertyDetailsState propertyState, int Acount, int Ucount) {
    return pw.Expanded(
      child: pw.Container(
        decoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.circular(2),
          color: PdfColor.fromHex("#ffffff"),
          border: pw.Border.all(color: PdfColor.fromHex("#EDEDED"), width: 1),
          /* boxShadow: [
            pw.BoxShadow(
              color: PdfColor.fromHex("#979797"),
              blurRadius: 4.0,
              spreadRadius: 0.0,
              offset: PdfPoint(
                0.0,
                1.0,
              ),
            )
          ],*/
        ),
        padding: pw.EdgeInsets.all(5),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              height: 35,
              child: pw.Text(
                GlobleString.ps4_Features_Not_Available,
                style: pw.TextStyle(
                  color: PdfColors.black,
                  font: pw.Font.ttf(font_demi),
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.left,
                maxLines: 2,
              ),
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Amenities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#979797"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 1,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: Acount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyamenitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "3"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#979797"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#979797"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(
              height: 10,
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.start,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        GlobleString.PS3_Property_Features_Utilities,
                        style: pw.TextStyle(
                          color: PdfColor.fromHex("#979797"),
                          font: pw.Font.ttf(font_medium),
                          fontSize: 11,
                        ),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(
                        height: 2,
                      ),
                      pw.Container(
                        alignment: pw.Alignment.centerLeft,
                        child: Ucount > 0
                            ? pw.ListView.builder(
                                //scrollDirection: Axis.vertical,
                                itemCount: propertyState
                                    .Summerypropertyutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  PropertyAmenitiesUtility data = propertyState
                                      .Summerypropertyutilitieslist[Index];
                                  return pw.Container(
                                    alignment: pw.Alignment.centerLeft,
                                    child: data.value == "3"
                                        ? pw.Text(
                                            data.Feature!,
                                            style: pw.TextStyle(
                                              color:
                                                  PdfColor.fromHex("#979797"),
                                              font: pw.Font.ttf(font_regular),
                                              fontSize: 9,
                                            ),
                                            textAlign: pw.TextAlign.left,
                                          )
                                        : pw.Container(),
                                  );
                                },
                              )
                            : pw.Text(
                                "---",
                                style: pw.TextStyle(
                                  color: PdfColor.fromHex("#979797"),
                                  font: pw.Font.ttf(font_regular),
                                  fontSize: 9,
                                ),
                                textAlign: pw.TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
