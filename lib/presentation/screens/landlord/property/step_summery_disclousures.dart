import 'dart:html' as html;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/property_summery_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/ImageDialog.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

import 'add_edit_property.dart';

typedef VoidCallback = void Function();
typedef VoidCallbackSaveandNext = void Function();

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final formatSize = new NumberFormat.currency(locale: "en_US", symbol: "");

class StepPropertySummary extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallbackSaveandNext _callbackSaveandNext;

  StepPropertySummary({
    required VoidCallback onPressedBack,
    required VoidCallbackSaveandNext onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepPropertySummaryState createState() => _StepPropertySummaryState();
}

class _StepPropertySummaryState extends State<StepPropertySummary> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;

  String? userTokan;
  int stepper = 0;
  bool firsttime = true;

  @override
  void initState() {
    Prefs.init();
    userTokan = Prefs.getString(PrefsName.userTokan);

    initNavigationBack();
    super.initState();
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.propertySummary) {
        stepper = navigationNotifier.stepper;
        _addSaveAndFinishCall(_store.state!.propertySummeryState);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      color: myColor.ps_SummaryBg,
      child: SingleChildScrollView(
        child: Container(
          child: ConnectState<PropertySummeryState>(
            map: (state) => state.propertySummeryState,
            where: notIdentical,
            builder: (propertySummeryState) {
              return Column(
                children: [
                  bannerView(propertySummeryState!),
                  propertyImages(propertySummeryState),
                  propertyDetailsView(propertySummeryState),
                  propertySpecificationRestrictionView(propertySummeryState),
                  propertyFeatureView(propertySummeryState),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      back(),
                      SizedBox(width: 10),
                      editsaveandfinish(propertySummeryState)
                    ],
                  ),
                  /*Prefs.getBool(PrefsName.PropertyEditMode) &&
                          Prefs.getBool(PrefsName.PropertyAgreeTC)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            back(),
                            SizedBox(width: 10),
                            editsaveandfinish(propertySummeryState)
                          ],
                        )
                      : PropertyDisclosureView(propertySummeryState),*/
                  SizedBox(
                    height: 10,
                  ),
                  UpdateMethod(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget UpdateMethod() {
    if (!firsttime && !AddEditProperty.isValueUpdate) {
      AddEditProperty.isValueUpdate = true;
      firsttime = false;
    } else if (firsttime) {
      AddEditProperty.isValueUpdate = false;
      firsttime = false;
    }

    return SizedBox(
      width: 0,
      height: 0,
    );
  }

  Widget bannerView(PropertySummeryState propertySummeryState) {
    return Container(
      width: sswidth,
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
          //SinglePropertyImage(propertySummeryState),
          /*SizedBox(
            width: 40,
          ),*/
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      propertySummeryState.PropertyName,
                      style: MyStyles.SemiBold(22, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " - ",
                      style: MyStyles.SemiBold(22, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      propertySummeryState.Suiteunit,
                      style: MyStyles.SemiBold(20, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  propertySummeryState.propertytypeValue == null
                      ? ""
                      : propertySummeryState.propertytypeValue!.EnumDetailID ==
                              6
                          ? propertySummeryState.propertytypeOtherValue
                          : propertySummeryState
                              .propertytypeValue!.displayValue,
                  style: MyStyles.Medium(16, myColor.white),
                  textAlign: TextAlign.start,
                ),
                Text(
                  propertySummeryState.Suiteunit +
                      " - " +
                      propertySummeryState.PropertyAddress +
                      ", " +
                      propertySummeryState.City +
                      ", " +
                      propertySummeryState.Province +
                      ", " +
                      propertySummeryState.Postalcode +
                      ", " +
                      propertySummeryState.CountryName,
                  style: MyStyles.Medium(16, myColor.white),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (Prefs.getBool(PrefsName.PropertyEditMode)) {
                _store.dispatch(UpdatePropertyForm(1));
              }
            },
            child: Tooltip(
              message: "Edit",
              child: Container(
                width: 30,
                margin: EdgeInsets.only(right: 20),
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/images/ic_edit.png",
                  width: 30,
                  height: 30,
                  color: Colors.white,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyImages(PropertySummeryState propertySummeryState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 15, right: 15),
      child: Container(
        height: 197,
        width: sswidth,
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  GlobleString.PS1_Property_Images1,
                  style: MyStyles.SemiBold(16, myColor.black),
                  textAlign: TextAlign.start,
                ),
                if (propertySummeryState.SummerypropertyImagelist != null &&
                    propertySummeryState.SummerypropertyImagelist.length > 0)
                  IconButton(
                    icon: Icon(
                      Icons.download_sharp,
                      color: myColor.black,
                      size: 25,
                    ),
                    onPressed: () {
                      if (propertySummeryState.SummerypropertyImagelist !=
                              null &&
                          propertySummeryState.SummerypropertyImagelist.length >
                              0) {
                        CustomeWidget.PropertySummaryImageZip(context,
                            propertySummeryState.SummerypropertyImagelist);
                      } else {
                        ToastUtils.showCustomToast(context,
                            GlobleString.PS3_Property_NoImageAvailable, false);
                      }
                    },
                  )
                else
                  Container(),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            if (propertySummeryState.SummerypropertyImagelist != null &&
                propertySummeryState.SummerypropertyImagelist.length > 0)
              Container(
                height: 130,
                width: sswidth,
                alignment: Alignment.centerLeft,
                child: Scrollbar(
                  //isAlwaysShown: true,
                  child: ListView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount:
                        propertySummeryState.SummerypropertyImagelist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      PropertyImageMediaInfo propertyImageMediaInfo =
                          propertySummeryState.SummerypropertyImagelist[index];
                      return Container(
                        height: 100.0,
                        width: 180,
                        margin: EdgeInsets.only(right: 10),
                        decoration: new BoxDecoration(
                          color: myColor.white,
                          border: Border.all(
                              width: 2, color: myColor.CM_Prop_card_border),
                          /* image: new DecorationImage(
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
                        ),*/
                        ),
                        child: InkWell(
                          onTap: () async {
                            await showDialog(
                                context: context,
                                builder: (_) => ImageDialog(
                                    propertyImageMediaInfo.id.toString()));
                          },
                          child: FadeInImage(
                            fit: BoxFit.fill,
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
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
                      );
                    },
                  ),
                ),
              )
            else
              Container(
                height: 150,
                width: 210,
                /*child: Image.asset(
                  "assets/images/noimage.png",
                ),*/
                alignment: Alignment.center,
                decoration: BoxDecoration(color: myColor.fnl_shadow),
                child: Text(
                  "No photos\nuploaded",
                  style: MyStyles.SemiBold(20, myColor.RQ_hint),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget SinglePropertyImage(PropertySummeryState propertySummeryState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        propertySummeryState.propertyImage != null &&
                propertySummeryState.propertyImage!.id != null
            ? InkWell(
                onTap: () {
                  PickImage();
                },
                child: Container(
                  width: 100.0,
                  height: 100.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: myColor.white,
                    border: Border.all(width: 2, color: myColor.blue),
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: CustomNetworkImage(
                        Weburl.image_API +
                            propertySummeryState.propertyImage!.id.toString(),
                        scale: 1,
                        headers: {
                          'Authorization': 'bearer ' + userTokan!,
                          'ApplicationCode': Weburl.API_CODE,
                        },
                      ),
                    ),
                  ),
                ),
              )
            : propertySummeryState.appimage != null
                ? InkWell(
                    onTap: () {
                      PickImage();
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: myColor.white,
                        border: Border.all(width: 2, color: myColor.blue),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.brown.shade800,
                        child: ClipOval(
                          child: Image.memory(
                            propertySummeryState.appimage!,
                            fit: BoxFit.fill,
                            width: 98,
                            height: 98,
                          ),
                        ),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      PickImage();
                    },
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: myColor.white,
                        border: Border.all(width: 2, color: myColor.blue),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        "assets/images/imageplace.png",
                        width: 70,
                        height: 70,
                        alignment: Alignment.center,
                      ),
                    ),
                  )
      ],
    );
  }

  void PickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'png',
      ],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.name.split('.').last).contains("jpg") ||
          (file.name.split('.').last).contains("JPG") ||
          (file.name.split('.').last).contains("png") ||
          (file.name.split('.').last).contains("PNG")) {
        _store.dispatch(UpdateSummeryPropertyImage(null));
        _store.dispatch(UpdateSummeryPropertyUint8List(file.bytes!));
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_Property_Image_error, false);
      }
    }
  }

  Widget propertyDetailsView(PropertySummeryState propertySummeryState) {
    String rentAmount = "";

    if (propertySummeryState.RentAmount != null &&
        propertySummeryState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(propertySummeryState.RentAmount.replaceAll(",", "").toString()))}';
      rentAmount = amount.replaceAll(".00", "");
    }

    return Padding(
      padding: EdgeInsets.only(top: 15, left: 15, bottom: 15, right: 15),
      child: Container(
        width: sswidth,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    height: 296,
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
                                propertySummeryState.propertytypeValue == null
                                    ? ""
                                    : propertySummeryState.propertytypeValue!
                                                .EnumDetailID ==
                                            6
                                        ? propertySummeryState
                                            .propertytypeOtherValue
                                        : propertySummeryState
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
                                propertySummeryState.rentalspaceValue == null
                                    ? ""
                                    : propertySummeryState
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
                                propertySummeryState.Buildingname,
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
                                    propertySummeryState.PropertyDescription,
                                    style: MyStyles.Regular(
                                        14, myColor.text_color),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 8,
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
                    height: 296,
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
                                propertySummeryState.dateofavailable == null
                                    ? ""
                                    : new DateFormat("dd-MMM-yyyy")
                                        .format(propertySummeryState
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
                                propertySummeryState
                                            .rentpaymentFrequencyValue ==
                                        null
                                    ? ""
                                    : propertySummeryState
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
                                propertySummeryState.leasetypeValue == null
                                    ? ""
                                    : propertySummeryState
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
                                style: MyStyles.SemiBold(14, myColor.black),
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
                                propertySummeryState.minimumleasedurationnumber,
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
                                propertySummeryState
                                            .minimumleasedurationValue ==
                                        null
                                    ? ""
                                    : propertySummeryState
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

  Widget propertySpecificationRestrictionView(
      PropertySummeryState propertySummeryState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Container(
        width: sswidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            specificationView(propertySummeryState),
            SizedBox(
              width: 15,
            ),
            restrictionView(propertySummeryState),
            SizedBox(
              width: 15,
            ),
            featureView(propertySummeryState),
          ],
        ),
      ),
    );
  }

  Widget specificationView(PropertySummeryState propertySummeryState) {
    String Size = "";

    if (propertySummeryState.PropertySizeinsquarefeet != null &&
        propertySummeryState.PropertySizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          propertySummeryState.PropertySizeinsquarefeet.replaceAll(",", "")
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
                        propertySummeryState.PropertyBedrooms,
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
                        propertySummeryState.PropertyBathrooms,
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
                        propertySummeryState.furnishingValue == null
                            ? ""
                            : propertySummeryState
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

  Widget restrictionView(PropertySummeryState propertySummeryState) {
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
                              propertySummeryState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                propertySummeryState.restrictionlist[Index];
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
                              propertySummeryState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                propertySummeryState.restrictionlist[Index];
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

  Widget featureView(PropertySummeryState propertySummeryState) {
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
                        propertySummeryState.Parkingstalls,
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
                        propertySummeryState.storageavailableValue == null
                            ? ""
                            : propertySummeryState
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

  Widget propertyFeatureView(PropertySummeryState propertySummeryState) {
    int Acount1 = 0, Acount2 = 0, Acount3 = 0;
    for (int i = 0;
        i < propertySummeryState.Summerypropertyamenitieslist.length;
        i++) {
      PropertyAmenitiesUtility amenitiesUtility =
          propertySummeryState.Summerypropertyamenitieslist[i];

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
        j < propertySummeryState.Summerypropertyutilitieslist.length;
        j++) {
      PropertyAmenitiesUtility amenitiesUtility =
          propertySummeryState.Summerypropertyutilitieslist[j];

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
        width: sswidth,
        height: Helper.gethightofFeature(AV, AVR, NAV),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IncludedInTheRent(propertySummeryState, Acount1, Ucount1),
            SizedBox(
              width: 15,
            ),
            AvailableNotIncludedInTheRent(
                propertySummeryState, Acount2, Ucount2),
            SizedBox(
              width: 15,
            ),
            NotAvailable(propertySummeryState, Acount3, Ucount3)
          ],
        ),
      ),
    );
  }

  Widget IncludedInTheRent(
      PropertySummeryState propertySummeryState, int Acount, int Ucount) {
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
                                itemCount: propertySummeryState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          propertySummeryState
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
                                itemCount: propertySummeryState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          propertySummeryState
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
      PropertySummeryState propertySummeryState, int Acount, int Ucount) {
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
                                itemCount: propertySummeryState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          propertySummeryState
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
                                itemCount: propertySummeryState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          propertySummeryState
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
      PropertySummeryState propertySummeryState, int Acount, int Ucount) {
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
                                itemCount: propertySummeryState
                                    .Summerypropertyamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyamenitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          propertySummeryState
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
                                itemCount: propertySummeryState
                                    .Summerypropertyutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return propertySummeryState
                                              .Summerypropertyutilitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          propertySummeryState
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

  Widget PropertyDisclosureView(PropertySummeryState propertySummeryState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
      child: Container(
        width: sswidth,
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 25),
              child: Text(
                GlobleString.PS_Disclosures,
                style: MyStyles.SemiBold(16, myColor.black),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 7),
              child: Row(
                children: [
                  Text(
                    GlobleString.ps4_disclosure_chk41,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      Helper.launchURL(
                          Weburl.PrivacyPolicy_and_TermsConditions);
                    },
                    child: Text(
                      GlobleString.ps4_disclosure_chk42,
                      style: MyStyles.Medium(14, myColor.blue),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    GlobleString.ps4_disclosure_chk43,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    onTap: () {
                      Helper.launchURL(
                          Weburl.PrivacyPolicy_and_TermsConditions);
                    },
                    child: Text(
                      GlobleString.ps4_disclosure_chk44,
                      style: MyStyles.Medium(14, myColor.blue),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Text(
                    GlobleString.ps4_disclosure_chk45,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: myColor.Circle_main,
                  checkColor: myColor.white,
                  value: propertySummeryState.agree_TCPP,
                  onChanged: (value) {
                    _store.dispatch(UpdateSummeryAgreeTCPP(value!));
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  GlobleString.ps4_disclosure_Iagree,
                  style: MyStyles.Regular(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                back(),
                SizedBox(width: 10),
                addsaveandfinish(propertySummeryState)
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget back() {
    return InkWell(
      onTap: () {
        widget._callbackBack();
      },
      child: CustomeWidget.TenantBackButton(),
    );
  }

  Widget addsaveandfinish(PropertySummeryState propertySummeryState) {
    return InkWell(
      onTap: () async {
        /* if (propertySummeryState.PropDrafting != 3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_Property_all_details, false);
        }*/

        bool prostep1 = await Prefs.getBool(PrefsName.PropertyStep1);
        bool prostep2 = await Prefs.getBool(PrefsName.PropertyStep2);
        bool prostep3 = await Prefs.getBool(PrefsName.PropertyStep3);

        if (!prostep1 || !prostep2 || !prostep3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_Property_all_details, false);
        } else if (!propertySummeryState.agree_TCPP) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_Property_Disclosures, false);
        } else {
          _addSaveAndFinishCall(propertySummeryState);
        }
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_Finish),
    );
  }

  Widget editsaveandfinish(PropertySummeryState propertySummeryState) {
    return InkWell(
      onTap: () async {
        bool prostep1 = await Prefs.getBool(PrefsName.PropertyStep1);
        bool prostep2 = await Prefs.getBool(PrefsName.PropertyStep2);
        bool prostep3 = await Prefs.getBool(PrefsName.PropertyStep3);

        if (!prostep1 || !prostep2 || !prostep3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_Property_all_details, false);
        }
        /*if (propertySummeryState.PropDrafting != 3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_Property_all_details, false);
        }*/
        else {
          _addSaveAndFinishCall(propertySummeryState);
          //_updatePropertyImageCall(propertySummeryState.propertyImage);
          //widget._callbackSaveandNext();
        }
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_Finish),
    );
  }

  _addSaveAndFinishCall(PropertySummeryState propertySummeryState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (propertySummeryState.appimage != null) {
      ApiManager().AddSingleImage(context, propertySummeryState.appimage!,
          (status, responce) {
        if (status) {
          final String id = '__file_picker_web-file-input';
          var element = html.document.getElementById(id);
          if (element != null) {
            element.remove();
          }

          _updatePropertyImageCall(responce, propertySummeryState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      _updatePropertyImageCall("0", propertySummeryState);
    }
  }

  _updatePropertyImageCall(
      String imagename, PropertySummeryState propertySummeryState) {
    PropertyDisclosure propertyd = PropertyDisclosure();
    propertyd.Property_Image = imagename;
    propertyd.IsAgreed_TandC = true;
    propertyd.IsActive = Prefs.getBool(PrefsName.PropertyActive);
    propertyd.PropDrafting = 3;

    PropertyUpdate cpropertyUpdate = PropertyUpdate();
    cpropertyUpdate.ID = Prefs.getString(PrefsName.PropertyID);
    cpropertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().UpdatePropertyDisclosure(context, cpropertyUpdate, propertyd,
        (error, respoce) {
      if (error) {
        loader.remove();

        ToastUtils.showCustomToast(
            context, GlobleString.PS_Save_Propertyse, true);

        if (stepper == 0)
          widget._callbackSaveandNext();
        else
          _store.dispatch(UpdatePropertyForm(stepper));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }
}
