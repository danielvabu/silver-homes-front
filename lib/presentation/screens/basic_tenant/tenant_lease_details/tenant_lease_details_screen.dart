import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/basictenant_action/lease_details_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/basic_tenant/lease_details_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final formatSize = new NumberFormat.currency(locale: "en_US", symbol: "");

class TenantLeaseDetailsScreen extends StatefulWidget {
  @override
  _TenantLeaseDetailsScreenState createState() =>
      _TenantLeaseDetailsScreenState();
}

class _TenantLeaseDetailsScreenState extends State<TenantLeaseDetailsScreen> {
  double height = 0, width = 0;
  final _store = getIt<AppStore>();

  late OverlayEntry loader;
  bool isloading = true;

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await ApiManager().clear_Tenant_LeaseState();

    ApiManager().getTenantDetailsDSQCall(
        context, Prefs.getString(PrefsName.BT_UserID), (error, respoce2) {
      if (error) {
      } else {}
    });

    ApiManager()
        .getPropertyRestriction(context, Prefs.getString(PrefsName.BT_PropID),
            (status, responce, restrictionlist) {
      if (status) {
        _store.dispatch(Update_BtLease_Restrictionlist(restrictionlist));
      } else {
        _store.dispatch(Update_BtLease_Restrictionlist([]));
      }
    });

    ApiManager().getPropertyAmanityUtility(
        context, Prefs.getString(PrefsName.BT_PropID),
        (status, responce, amenitieslist, utilitylist) {
      if (status) {
        amenitieslist.sort((a, b) => a.id!.compareTo(b.id!));
        utilitylist.sort((a, b) => a.id!.compareTo(b.id!));

        _store.dispatch(Update_BtLease_PropertyAmenitiesList(amenitieslist));
        _store.dispatch(Update_BtLease_PropertyUtilitiesList(utilitylist));
      } else {
        _store.dispatch(Update_BtLease_PropertyAmenitiesList(amenitieslist));
        _store.dispatch(Update_BtLease_PropertyUtilitiesList(utilitylist));
      }
    });

    await ApiManager()
        .getPropertyDetails(context, Prefs.getString(PrefsName.BT_PropID),
            (status, responce, propertyData) async {
      if (status) {
        _store.dispatch(
            Update_BtLease_lanOwnerId(Prefs.getString(PrefsName.BT_OwnerID)));
        _store.dispatch(
            Update_BtLease_lan_name(Prefs.getString(PrefsName.BT_Owner_name)));
        _store.dispatch(Update_BtLease_lan_email(
            Prefs.getString(PrefsName.BT_Owner_email)));
        _store.dispatch(Update_BtLease_lan_phoneno(
            Prefs.getString(PrefsName.BT_Owner_phoneno)));
        _store.dispatch(Update_BtLease_lan_Companyname(
            Prefs.getString(PrefsName.BT_Owner_Companyname)));
        _store.dispatch(Update_BtLease_lan_Companyemail(""));

        String address = (propertyData!.suiteUnit!.isNotEmpty
                ? propertyData.suiteUnit! + " - "
                : "") +
            propertyData.propertyAddress! +
            ", " +
            propertyData.city! +
            ", " +
            propertyData.province! +
            ", " +
            propertyData.country! +
            ", " +
            propertyData.postalCode!;

        await Prefs.setString(
            PrefsName.BT_PropName, propertyData.propertyName.toString());
        await Prefs.setString(PrefsName.BT_PropAddress, address.toString());

        await ApiManager().bindTenantPropertyData(propertyData);
        await ApiManager().TenantLeaseAgreement(
            context, Prefs.getString(PrefsName.BT_ApplicationId),
            (status, responce) {
          if (status) {
            updatemethod();
          } else {
            Helper.Log("respoce", responce);
          }
        });
      } else {}
    });
  }

  void updatemethod() {
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.all(0),
      padding: EdgeInsets.all(20),
      color: myColor.bg_color1,
      child: isloading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            )
          : ConnectState<LeaseDetailsState>(
              map: (state) => state.leaseDetailsState,
              where: notIdentical,
              builder: (leaseDetailsState) {
                return intiview(leaseDetailsState!);
              },
            ),
    );
  }

  Widget intiview(LeaseDetailsState leaseDetailsState) {
    return Column(
      children: [
        profileheader(leaseDetailsState),
        Container(
          width: width,
          height: height - 160,
          margin: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GlobleString.BT_Lease_Landlord_Information,
                  style: MyStyles.Medium(18, myColor.Circle_main),
                  textAlign: TextAlign.center,
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: myColor.application_boreder),
                      color: myColor.white),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            top: 15, left: 15, bottom: 15, right: 15),
                        color: myColor.bg_color1,
                        child: Row(
                          children: [
                            LeaseView(leaseDetailsState),
                            SizedBox(
                              width: 14,
                            ),
                            LandlordView(leaseDetailsState)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  GlobleString.BT_Property_Information,
                  style: MyStyles.Medium(18, myColor.Circle_main),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: width,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1, color: myColor.application_boreder),
                      color: myColor.white),
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.all(15),
                  child: Column(
                    children: [
                      BannerView(leaseDetailsState),
                      Container(
                        padding: EdgeInsets.only(
                            top: 15, left: 15, bottom: 15, right: 15),
                        color: myColor.bg_color1,
                        child: Column(
                          children: [
                            PropertySpecificationRestrictionView(
                                leaseDetailsState),
                            PropertyFeatureView(leaseDetailsState),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget profileheader(LeaseDetailsState leaseDetailsState) {
    return Container(
      width: width,
      height: 100,
      color: myColor.Circle_main,
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            Prefs.getString(PrefsName.BT_fname) +
                " " +
                Prefs.getString(PrefsName.BT_lname),
            style: MyStyles.SemiBold(22, myColor.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/ic_bt_email.png",
                width: 18,
                height: 18,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Prefs.getString(PrefsName.BT_Email),
                style: MyStyles.Medium(14, myColor.white),
                textAlign: TextAlign.start,
              ),
              SizedBox(
                width: 50,
              ),
              Image.asset(
                "assets/images/ic_bt_phone.png",
                width: 18,
                height: 18,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                Prefs.getString(PrefsName.BT_phoneno),
                style: MyStyles.Medium(14, myColor.white),
                textAlign: TextAlign.start,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget LeaseView(LeaseDetailsState leaseDetailsState) {
    String rentAmount = "";

    if (leaseDetailsState.RentAmount != null &&
        leaseDetailsState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(leaseDetailsState.RentAmount.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return Expanded(
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
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
                    GlobleString.PS1_Rent_payment_frequency,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    leaseDetailsState.rentpaymentFrequencyValue != null
                        ? leaseDetailsState
                            .rentpaymentFrequencyValue!.displayValue
                        : "",
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
                    leaseDetailsState.leasetypeValue != null
                        ? leaseDetailsState.leasetypeValue!.displayValue
                        : "",
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
                    style: MyStyles.SemiBold(14, myColor.black),
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
                    GlobleString.PS1_Minimum_lease_Number,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    leaseDetailsState.minimumleasedurationnumber,
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
                    leaseDetailsState.minimumleasedurationValue != null
                        ? leaseDetailsState
                            .minimumleasedurationValue!.displayValue
                        : "",
                    style: MyStyles.Regular(14, myColor.text_color),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            leaseDetailsState.Lease_MediaDoc != null &&
                    leaseDetailsState.Lease_MediaDoc!.url != null &&
                    leaseDetailsState.Lease_MediaDoc!.url!.isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await Helper.download(
                              context,
                              leaseDetailsState.Lease_MediaDoc!.url.toString(),
                              leaseDetailsState.Lease_MediaDoc!.id.toString(),
                              Helper.FileNameWithTime(
                                  leaseDetailsState.Lease_MediaDoc!.url!),
                              1);
                        },
                        child: Container(
                          height: 30,
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                          ),
                          child: Text(
                            GlobleString.Lease_download,
                            style: MyStyles.Medium(12, myColor.white),
                          ),
                        ),
                      )
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Widget LandlordView(LeaseDetailsState leaseDetailsState) {
    return Expanded(
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: [
            /*BoxShadow(
            color: myColor.TA_Border,
            blurRadius: 4.0,
            spreadRadius: 0.0,
            offset: Offset(
              0.0,
              1.0,
            ),
          )*/
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.BT_Landlord_Details,
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
                        GlobleString.BT_Ld_CompanyName,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        leaseDetailsState.lan_Companyname,
                        style: MyStyles.Regular(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.BT_Ld_CompanyEmail,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        leaseDetailsState.lan_Companyemail,
                        style: MyStyles.Regular(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
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
                        GlobleString.BT_Ld_ContactName,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        leaseDetailsState.lan_name,
                        style: MyStyles.Regular(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        GlobleString.BT_Ld_ContactEmail,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        leaseDetailsState.lan_email,
                        style: MyStyles.Regular(14, myColor.text_color),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
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
                        GlobleString.BT_Ld_ContactPhone,
                        style: MyStyles.Medium(14, myColor.black),
                        textAlign: TextAlign.start,
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Text(
                        leaseDetailsState.lan_phoneno,
                        style: MyStyles.Regular(14, myColor.text_color),
                        textAlign: TextAlign.start,
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

  Widget BannerView(LeaseDetailsState leaseDetailsState) {
    String rentAmount = "";

    if (leaseDetailsState.RentAmount != null &&
        leaseDetailsState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(leaseDetailsState.RentAmount.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return Container(
      width: width,
      height: 115,
      color: myColor.Circle_main,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                leaseDetailsState.PropertyName,
                style: MyStyles.SemiBold(22, myColor.white),
                textAlign: TextAlign.center,
              ),
              if (leaseDetailsState.Suiteunit.isNotEmpty)
                Text(
                  " - ",
                  style: MyStyles.SemiBold(22, myColor.white),
                  textAlign: TextAlign.center,
                ),
              Text(
                leaseDetailsState.Suiteunit,
                style: MyStyles.SemiBold(20, myColor.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            (leaseDetailsState.propertytypeValue != null
                    ? leaseDetailsState.propertytypeValue!.displayValue
                    : "") +
                " | " +
                leaseDetailsState.PropertyAddress +
                ", " +
                leaseDetailsState.City +
                ", " +
                leaseDetailsState.Province +
                ", " +
                leaseDetailsState.Postalcode +
                ", " +
                leaseDetailsState.CountryName,
            style: MyStyles.Medium(14, myColor.white),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Rent: " + rentAmount + "/month",
            style: MyStyles.Medium(14, myColor.white),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget PropertySpecificationRestrictionView(
      LeaseDetailsState leaseDetailsState) {
    return Container(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SpecificationView(leaseDetailsState),
          SizedBox(
            width: 15,
          ),
          RestrictionView(leaseDetailsState),
          SizedBox(
            width: 15,
          ),
          FeatureView(leaseDetailsState),
        ],
      ),
    );
  }

  Widget SpecificationView(LeaseDetailsState leaseDetailsState) {
    String Size = "";

    if (leaseDetailsState.PropertySizeinsquarefeet != null &&
        leaseDetailsState.PropertySizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          leaseDetailsState.PropertySizeinsquarefeet.replaceAll(",", "")
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
                        leaseDetailsState.PropertyBedrooms,
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
                        leaseDetailsState.PropertyBathrooms,
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
                        leaseDetailsState.furnishingValue == null
                            ? ""
                            : leaseDetailsState.furnishingValue!.displayValue,
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

  Widget RestrictionView(LeaseDetailsState leaseDetailsState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
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
                          itemCount: leaseDetailsState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                leaseDetailsState.restrictionlist[Index];
                            return !data.ischeck!
                                ? Text(
                                    data.displayValue.replaceAll("No", ""),
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
                          itemCount: leaseDetailsState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                leaseDetailsState.restrictionlist[Index];
                            return data.ischeck!
                                ? Text(
                                    data.displayValue.replaceAll("No", ""),
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

  Widget FeatureView(LeaseDetailsState leaseDetailsState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
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
                        leaseDetailsState.Parkingstalls,
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
                        leaseDetailsState.storageavailableValue == null
                            ? ""
                            : leaseDetailsState
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

  Widget PropertyFeatureView(LeaseDetailsState leaseDetailsState) {
    int Acount1 = 0, Acount2 = 0;
    for (int i = 0;
        i < leaseDetailsState.Summerypropertyamenitieslist.length;
        i++) {
      PropertyAmenitiesUtility amenitiesUtility =
          leaseDetailsState.Summerypropertyamenitieslist[i];

      if (amenitiesUtility.value == "1") {
        Acount1++;
      } else if (amenitiesUtility.value == "2") {
        Acount2++;
      }
    }

    int Ucount1 = 0, Ucount2 = 0;
    for (int j = 0;
        j < leaseDetailsState.Summerypropertyutilitieslist.length;
        j++) {
      PropertyAmenitiesUtility amenitiesUtility =
          leaseDetailsState.Summerypropertyutilitieslist[j];

      if (amenitiesUtility.value == "1") {
        Ucount1++;
      } else if (amenitiesUtility.value == "2") {
        Ucount2++;
      }
    }

    int AV = Acount1 + Ucount1;
    int AVR = Acount2 + Ucount2;

    return Container(
      width: width,
      height: gethightofFeature(AV, AVR),
      margin: EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IncludedInTheRent(leaseDetailsState, Acount1, Ucount1),
          SizedBox(
            width: 15,
          ),
          AvailableNotIncludedInTheRent(leaseDetailsState, Acount2, Ucount2),
        ],
      ),
    );
  }

  gethightofFeature(int AV, int AVR) {
    Helper.Log("AV Count", AV.toString());
    Helper.Log("AVR Count", AVR.toString());

    double Fheight = 0;
    if (AV >= AVR) {
      Fheight = double.parse((AV * 19).toString());
    } else {
      Fheight = double.parse((AVR * 19).toString());
    }

    /*if (Fheight == 0)
      Fheight = 50;*/

    Helper.Log("Height", Fheight.toString());
    return Fheight + 50;
  }

  Widget IncludedInTheRent(
      LeaseDetailsState leaseDetailsState, int Acount, int Ucount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                itemCount: leaseDetailsState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return leaseDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          leaseDetailsState
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
                                itemCount: leaseDetailsState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return leaseDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          leaseDetailsState
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
      LeaseDetailsState leaseDetailsState, int Acount, int Ucount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                itemCount: leaseDetailsState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return leaseDetailsState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          leaseDetailsState
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
                                itemCount: leaseDetailsState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return leaseDetailsState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          leaseDetailsState
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
}
