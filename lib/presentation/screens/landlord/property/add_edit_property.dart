import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui';

import 'package:archive/archive.dart' as webarc;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/property_summery_state.dart';
import 'package:silverhome/presentation/models/landlord_models/propertyform_state.dart';
import 'package:silverhome/presentation/screens/landlord/property/step_feature.dart';
import 'package:silverhome/presentation/screens/landlord/property/step_property_details.dart';
import 'package:silverhome/presentation/screens/landlord/property/step_property_specification_restriction.dart';
import 'package:silverhome/presentation/screens/landlord/property/step_summery_disclousures.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final formatSize = new NumberFormat.currency(locale: "en_US", symbol: "");

class AddEditProperty extends StatefulWidget {
  static bool isValueUpdate = false;

  @override
  _AddEditPropertyState createState() => _AddEditPropertyState();
}

class _AddEditPropertyState extends State<AddEditProperty> {
  final _store = getIt<AppStore>();

  double ssheight = 0, sswidth = 0;
  var font_medium, font_demi, font_regular, font_bold;

  @override
  void initState() {
    Prefs.init();
    AddEditProperty.isValueUpdate = false;
    fontload();
    if (!Prefs.getBool(PrefsName.PropertyEditMode)) {
      fillAmenities();
    }
    super.initState();
  }

  void fontload() async {
    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");
  }

  void fillAmenities() {
    /* Amenities */
    ApiManager().getPropertyFeaturelist(context);

    List<SystemEnumDetails> restrictionlist = [];
    restrictionlist = QueryFilter().PlainValues(eSystemEnums().Restrictions);

    _store.dispatch(UpdateRestrictionlist(restrictionlist));

    List<SystemEnumDetails> secondrestrictionlist = restrictionlist
        .map((item) => new SystemEnumDetails.clone(item))
        .toList();

    _store.dispatch(UpdateSummeryRestrictionlist(secondrestrictionlist));
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
        height: ssheight,
        width: sswidth,
        color: myColor.bg_color1,
        child: _initialview());
  }

  Widget _initialview() {
    return Container(
      width: ssheight,
      height: sswidth,
      child: Padding(
        padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
        child: ConnectState<PropertyFormState>(
            map: (state) => state.propertyFormState,
            where: notIdentical,
            builder: (propertyFormState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerView(propertyFormState!),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      propertyFormState.selectView != 4
                          ? Expanded(
                              child: Text(
                                propertyFormState.property_address,
                                style: MyStyles.SemiBold(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : Expanded(
                              child: Text(
                                GlobleString.PS_Property_Summary,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                      propertyFormState.selectView != 4
                          ? Container()
                          : Container(
                              width: 100,
                              child: ConnectState<PropertySummeryState>(
                                  map: (state) => state.propertySummeryState,
                                  where: notIdentical,
                                  builder: (propertySummeryState) {
                                    return InkWell(
                                      onTap: () async {
                                        var loader =
                                            Helper.overlayLoader(context);
                                        Overlay.of(context)!.insert(loader);
                                        await Pdfgenerate(
                                            propertySummeryState!);
                                        loader.remove();
                                      },
                                      child: Container(
                                        width: 100,
                                        margin: EdgeInsets.only(right: 10),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          GlobleString.PS_Property_Export,
                                          style: MyStyles.Medium(
                                              14, myColor.black),
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: sswidth,
                    decoration: BoxDecoration(
                      color: myColor.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: myColor.application_boreder, width: 1),
                    ),
                    padding: EdgeInsets.all(20),
                    child: _centerView(
                        propertyFormState.selectView, propertyFormState),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _headerView(PropertyFormState propertyFormState) {
    return Row(
      children: [
        Container(
          width: 150,
          alignment: Alignment.topLeft,
          child: InkWell(
            onTap: () {
              if (AddEditProperty.isValueUpdate)
                showBackDialog(propertyFormState, true);
              else
                _store
                    .dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            },
            child: Text(
              GlobleString.PS_Back_to_Propertys,
              style: MyStyles.SemiBold(13, myColor.blue),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                width: 741,
                height: 82,
                margin: EdgeInsets.only(right: 150),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 80, right: 30, bottom: 20),
                      alignment: Alignment.topCenter,
                      color: myColor.black,
                      height: 2,
                    ),
                    _indicator(propertyFormState),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showBackDialog(PropertyFormState propertyFormState, bool goback,
      {int stepper = 0}) {
    if (stepper == propertyFormState.selectView) return;
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.PS_Save_Propertys_msg,
          positiveText: GlobleString.PS_Save_Propertys_yes,
          negativeText: GlobleString.PS_Save_Propertyse_NO,
          onPressedNo: () {
            Navigator.of(context1).pop();
            if (goback && stepper == 0)
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            else
              _store.dispatch(UpdatePropertyForm(stepper));
          },
          onPressedYes: () {
            switch (propertyFormState.selectView) {
              case 1:
                navigationNotifier.change(
                    back: NavigationConstant.propertyDetails,
                    goBack: goback,
                    step: stepper);
                break;
              case 2:
                navigationNotifier.change(
                    back: NavigationConstant.specificationAndRestriction,
                    goBack: goback,
                    step: stepper);
                break;
              case 3:
                navigationNotifier.change(
                    back: NavigationConstant.featuresAndPhotos,
                    goBack: goback,
                    step: stepper);
                break;
              case 4:
                navigationNotifier.change(
                    back: NavigationConstant.propertySummary,
                    goBack: goback,
                    step: stepper);
                break;
            }
            Navigator.of(context1).pop();
            //ToastUtils.showCustomToast(context, propertyState.PropertyName, false);
          },
        );
      },
    );
  }

  Widget _indicator(PropertyFormState propertyFormState) {
    return Container(
      width: 741,
      margin: const EdgeInsets.only(top: 15),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.PropertyEditMode)) {
                if (AddEditProperty.isValueUpdate)
                  showBackDialog(propertyFormState, false, stepper: 1);
                else
                  _store.dispatch(UpdatePropertyForm(1));

                // _store.dispatch(UpdatePropertyForm(1));
              }
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    Prefs.getBool(PrefsName.PropertyStep1)
                        ? "assets/images/ic_circle_check.png"
                        : "assets/images/ic_circle_fill.png",
                    width: 30,
                    height: 30,
                    alignment: Alignment.topLeft,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  GlobleString.PS_Property_Details,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const SizedBox(width: 35.0),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.PropertyEditMode)) {
                if (AddEditProperty.isValueUpdate)
                  showBackDialog(propertyFormState, false, stepper: 2);
                else
                  _store.dispatch(UpdatePropertyForm(2));

                // _store.dispatch(UpdatePropertyForm(2));
              }
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    Prefs.getBool(PrefsName.PropertyStep2)
                        ? "assets/images/ic_circle_check.png"
                        : propertyFormState.selectView > 2
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 30,
                    height: 30,
                    alignment: Alignment.topLeft,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  GlobleString.PS_Property_Specifications_Restrictions,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const SizedBox(width: 74.0),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.PropertyEditMode)) {
                if (AddEditProperty.isValueUpdate)
                  showBackDialog(propertyFormState, false, stepper: 3);
                else
                  _store.dispatch(UpdatePropertyForm(3));

                // _store.dispatch(UpdatePropertyForm(3));
              }
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    Prefs.getBool(PrefsName.PropertyStep3)
                        ? "assets/images/ic_circle_check.png"
                        : propertyFormState.selectView > 3
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 30,
                    height: 30,
                    alignment: Alignment.topLeft,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  GlobleString.PS_Property_Features,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          const SizedBox(width: 110.0),
          InkWell(
            onTap: () {
              if (Prefs.getBool(PrefsName.PropertyEditMode)) {
                // _store.dispatch(UpdatePropertyForm(4));

                if (AddEditProperty.isValueUpdate)
                  showBackDialog(propertyFormState, false, stepper: 4);
                else
                  _store.dispatch(UpdatePropertyForm(4));
              }
            },
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    Prefs.getBool(PrefsName.PropertyAgreeTC) &&
                            Prefs.getBool(PrefsName.PropertyStep1) &&
                            Prefs.getBool(PrefsName.PropertyStep2) &&
                            Prefs.getBool(PrefsName.PropertyStep3)
                        ? "assets/images/ic_circle_check.png"
                        : propertyFormState.selectView > 4
                            ? "assets/images/ic_circle_fill.png"
                            : "assets/images/ic_circle_border.png",
                    width: 30,
                    height: 30,
                    alignment: Alignment.topLeft,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  GlobleString.PS_Property_Summary,
                  style: MyStyles.SemiBold(13, myColor.text_color),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _centerView(int val, PropertyFormState propertyFormState) {
    switch (val) {
      case 1:
        {
          return StepPropertyDetails(
            onPressedSave: () {
              _store.dispatch(UpdatePropertyForm(2));
            },
          );
        }
      case 2:
        {
          return StepPropertySpecificationRestriction(
            onPressedSave: () {
              _store.dispatch(UpdatePropertyForm(3));
            },
            onPressedBack: () {
              if (AddEditProperty.isValueUpdate)
                showBackDialog(propertyFormState, false, stepper: 1);
              else
                _store.dispatch(UpdatePropertyForm(1));
            },
          );
        }
      case 3:
        {
          return StepPropertyFeature(
            onPressedSave: () {
              _store.dispatch(UpdatePropertyForm(4));
            },
            onPressedBack: () {
              if (AddEditProperty.isValueUpdate)
                showBackDialog(propertyFormState, false, stepper: 2);
              else
                _store.dispatch(UpdatePropertyForm(2));
            },
          );
        }
      case 4:
        {
          return StepPropertySummary(
            onPressedSave: () async {
              await Prefs.setBool(PrefsName.PropertyEdit, false);
              await Prefs.setBool(PrefsName.PropertyEditMode, false);
              await Prefs.setBool(PrefsName.PropertyAgreeTC, false);
              await Prefs.setString(PrefsName.PropertyID, "");
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            },
            onPressedBack: () {
              if (AddEditProperty.isValueUpdate)
                showBackDialog(propertyFormState, false, stepper: 3);
              else
                _store.dispatch(UpdatePropertyForm(3));
            },
          );
        }
      default:
        {
          return StepPropertyDetails(
            onPressedSave: () {
              _store.dispatch(UpdatePropertyForm(2));
            },
          );
        }
    }
  }

  /*===============================================================================================*/
  /*======================================  PDF FILE GENERETE  ====================================*/
  /*===============================================================================================*/

  Future<void> Pdfgenerate(PropertySummeryState propertyState) async {
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
              BannerView(propertyState),

              // PropertyDetails view
              PropertyDetailsView(propertyState),

              // SpecificationRestrictionView view
              PropertySpecificationRestrictionView(propertyState),

              PropertyFeatureView(propertyState),
            ],
          ),
        ),
      ),
    );

    String filename = "property_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".pdf";

    Uint8List pdfInBytes = await pdf.save();
    webarc.Archive archive = webarc.Archive();
    var pdffile =
        webarc.ArchiveFile.string(filename, String.fromCharCodes(pdfInBytes));
    archive.addFile(pdffile);

    try {
      List<String> namestring = [];
      for (PropertyImageMediaInfo img
          in propertyState.SummerypropertyImagelist) {
        try {
          var res = await get(Uri.parse(Weburl.image_API + img.id.toString()),
              headers: {
                'Authorization':
                    'bearer ' + Prefs.getString(PrefsName.userTokan),
                'ApplicationCode': Weburl.API_CODE,
              });

          String filename = Helper.FileName(img.url!);

          String newfilename = Helper.CopyAddFilename(namestring, filename);

          namestring.add(newfilename);

          var file = webarc.ArchiveFile.string(
              newfilename, String.fromCharCodes(res.bodyBytes));
          archive.addFile(file);
        } catch (e) {}
      }
    } catch (e) {
      print("fileerror: $e");
    }

    webarc.OutputStream stream =
        webarc.OutputStream(byteOrder: webarc.LITTLE_ENDIAN);

    String zipname = "property_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString();
    var bytes;
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.linux) {
      webarc.TarEncoder tarEncoder = webarc.TarEncoder();
      bytes = tarEncoder.encode(archive, output: stream);
      zipname += ".tar";
    } else {
      webarc.ZipEncoder encode = webarc.ZipEncoder();
      bytes = encode.encode(
        archive,
        level: webarc.Deflate.BEST_COMPRESSION,
        output: stream,
        modified: DateTime.now(),
      );
      zipname += ".zip";
    }

    html.AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64Encode(bytes!)}")
      ..setAttribute("download", zipname)
      ..click();
  }

  pw.Widget BannerView(PropertySummeryState propertyState) {
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

  pw.Widget PropertyDetailsView(PropertySummeryState propertyState) {
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
                PropertyDetails(propertyState),
                pw.SizedBox(
                  width: 10,
                ),
                PropertyLeaseDetails(propertyState)
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget PropertyDetails(PropertySummeryState propertyState) {
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

  pw.Widget PropertyLeaseDetails(PropertySummeryState propertyState) {
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

  pw.Widget PropertySpecificationRestrictionView(
      PropertySummeryState propertyState) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            SpecificationView(propertyState),
            pw.SizedBox(
              width: 10,
            ),
            RestrictionView(propertyState),
            pw.SizedBox(
              width: 10,
            ),
            FeatureView(propertyState),
          ],
        ),
      ),
    );
  }

  pw.Widget SpecificationView(PropertySummeryState propertyState) {
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

  pw.Widget RestrictionView(PropertySummeryState propertyState) {
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
                                        data.displayValue.replaceAll("No", ""),
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

  pw.Widget FeatureView(PropertySummeryState propertyState) {
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

  pw.Widget PropertyFeatureView(PropertySummeryState propertyState) {
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

    //int AV = Acount1 + Ucount1;
    //int AVR = Acount2 + Ucount2;
    //int NAV = Acount3 + Ucount3;

    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        height: 400, //gethightofFeature(propertyState, AV, AVR, NAV),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            IncludedInTheRent(propertyState, Acount1, Ucount1),
            pw.SizedBox(
              width: 10,
            ),
            AvailableNotIncludedInTheRent(propertyState, Acount2, Ucount2),
            pw.SizedBox(
              width: 10,
            ),
            NotAvailable(propertyState, Acount3, Ucount3)
          ],
        ),
      ),
    );
  }

  pw.Widget IncludedInTheRent(
      PropertySummeryState propertyState, int Acount, int Ucount) {
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

  pw.Widget AvailableNotIncludedInTheRent(
      PropertySummeryState propertyState, int Acount, int Ucount) {
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

  pw.Widget NotAvailable(
      PropertySummeryState propertyState, int Acount, int Ucount) {
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

  double gethightofFeature(
      PropertySummeryState propertyState, int AV, int AVR, int NAV) {
    double Fheight = 0;
    if (AV >= AVR) {
      if (AV >= NAV) {
        Fheight = double.parse((AV * 13).toString());
      } else {
        Fheight = double.parse((NAV * 13).toString());
      }
    } else {
      if (AVR >= NAV) {
        Fheight = double.parse((AVR * 13).toString());
      } else {
        Fheight = double.parse((NAV * 13).toString());
      }
    }

    Helper.Log("PDF Height", Fheight.toString());
    Helper.Log("PDF Height", (Fheight + 70).toString());

    return Fheight + 70;
  }
}
