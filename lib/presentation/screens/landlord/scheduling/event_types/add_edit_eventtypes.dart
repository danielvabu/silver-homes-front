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
import 'package:silverhome/domain/actions/landlord_action/eventtypes_specification_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_summery_state.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_form_state.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/step_eventtypes_notifications.dart';
//import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/step_feature.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/step_eventtypes_setup.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/step_eventtypes_availability.dart';
import 'package:silverhome/presentation/screens/landlord/scheduling/event_types/step_eventtypes_questions.dart';
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

class AddEditEventTypes extends StatefulWidget {
  static bool isValueUpdate = false;

  @override
  _AddEditEventTypesState createState() => _AddEditEventTypesState();
}

class _AddEditEventTypesState extends State<AddEditEventTypes> {
  final _store = getIt<AppStore>();

  double ssheight = 0, sswidth = 0;
  var font_medium, font_demi, font_regular, font_bold;

  @override
  void initState() {
    Prefs.init();
    AddEditEventTypes.isValueUpdate = false;
    fontload();
    if (!Prefs.getBool(PrefsName.EventTypesEditMode)) {
      // fillAmenities();
    }
    super.initState();
  }

  void fontload() async {
    font_medium = await rootBundle.load("assets/fonts/avenirnext-medium.ttf");
    font_demi = await rootBundle.load("assets/fonts/avenirnext-demi.ttf");
    font_regular = await rootBundle.load("assets/fonts/avenirnext-regular.ttf");
    font_bold = await rootBundle.load("assets/fonts/avenirnext-bold.ttf");
  }

  /*void fillAmenities() {
    /* Amenities */
    ApiManager().getEventTypesFeaturelist(context);

    List<SystemEnumDetails> restrictionlist = [];
    restrictionlist = QueryFilter().PlainValues(eSystemEnums().Restrictions);

    _store.dispatch(UpdateRestrictionlist(restrictionlist));

    List<SystemEnumDetails> secondrestrictionlist = restrictionlist
        .map((item) => new SystemEnumDetails.clone(item))
        .toList();

    _store.dispatch(UpdateSummeryRestrictionlist(secondrestrictionlist));
  }*/

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
        padding: const EdgeInsets.all(15.0),
        child: ConnectState<EventTypesFormState>(
            map: (state) => state.eventTypesFormState,
            where: notIdentical,
            builder: (eventtypesFormState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: ssheight - 30,
                    width: sswidth,
                    decoration: BoxDecoration(
                      color: myColor.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: myColor.application_boreder, width: 1),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _headerView(eventtypesFormState!),
                        const SizedBox(height: 1.0),
                        Row(
                          children: [
                            eventtypesFormState.selectView != 4
                                ? Expanded(
                                    child: Text(
                                      eventtypesFormState.eventtypes_address,
                                      style:
                                          MyStyles.SemiBold(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                  )
                                : Expanded(
                                    child: Text(
                                      'Summary',
                                      //GlobleString.PS_EventTypes_Summary,
                                      style: MyStyles.Medium(14, myColor.black),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                            eventtypesFormState.selectView != 4
                                ? Container()
                                : Container(
                                    width: 100,
                                    child: ConnectState<EventTypesSummeryState>(
                                        map: (state) =>
                                            state.eventTypesSummeryState,
                                        where: notIdentical,
                                        builder: (eventtypesSummeryState) {
                                          return InkWell(
                                            onTap: () async {
                                              var loader =
                                                  Helper.overlayLoader(context);
                                              Overlay.of(context)!
                                                  .insert(loader);
                                              //await Pdfgenerate(eventtypesSummeryState!);
                                              loader.remove();
                                            },
                                            child: Container(
                                              width: 100,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'Export',
                                                //GlobleString.PS_EventTypes_Export,
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
                        _centerView(eventtypesFormState.selectView,
                            eventtypesFormState),
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }

  Widget _headerView(EventTypesFormState eventtypesFormState) {
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    GlobleString.ET_New_Event_Type,
                    style: MyStyles.Bold(25, myColor.Circle_main),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.center,
                width: sswidth - 250,
                height: 70,
                //margin: const EdgeInsets.only(right: 150),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      alignment: Alignment.topCenter,
                      color: myColor.black,
                      height: 2,
                    ),
                    Container(
                      width: sswidth - 250,
                      margin: const EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
                                if (AddEditEventTypes.isValueUpdate)
                                  showBackDialog(eventtypesFormState, false,
                                      stepper: 1);
                                else
                                  _store.dispatch(UpdateEventTypesForm(1));

                                // _store.dispatch(UpdateEventTypesForm(1));
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  child: Image.asset(
                                    Prefs.getBool(PrefsName.EventTypesStep1)
                                        ? "assets/images/ic_circle_check.png"
                                        : "assets/images/ic_circle_fill.png",
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  GlobleString.ET_Event_Setup,
                                  style:
                                      MyStyles.SemiBold(13, myColor.text_color),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            onTap: () {
                              if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
                                if (AddEditEventTypes.isValueUpdate)
                                  showBackDialog(eventtypesFormState, false,
                                      stepper: 2);
                                else
                                  _store.dispatch(UpdateEventTypesForm(2));

                                // _store.dispatch(UpdateEventTypesForm(2));
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    Prefs.getBool(PrefsName.EventTypesStep2)
                                        ? "assets/images/ic_circle_check.png"
                                        : eventtypesFormState.selectView > 2
                                            ? "assets/images/ic_circle_fill.png"
                                            : "assets/images/ic_circle_border.png",
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  GlobleString.ET_Availability,
                                  style:
                                      MyStyles.SemiBold(13, myColor.text_color),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            onTap: () {
                              if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
                                if (AddEditEventTypes.isValueUpdate)
                                  showBackDialog(eventtypesFormState, false,
                                      stepper: 3);
                                else
                                  _store.dispatch(UpdateEventTypesForm(3));

                                // _store.dispatch(UpdateEventTypesForm(3));
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    Prefs.getBool(PrefsName.EventTypesStep3)
                                        ? "assets/images/ic_circle_check.png"
                                        : eventtypesFormState.selectView > 3
                                            ? "assets/images/ic_circle_fill.png"
                                            : "assets/images/ic_circle_border.png",
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  GlobleString.ET_Invitee_Questions,
                                  style:
                                      MyStyles.SemiBold(13, myColor.text_color),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          InkWell(
                            onTap: () {
                              if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
                                // _store.dispatch(UpdateEventTypesForm(4));

                                if (AddEditEventTypes.isValueUpdate)
                                  showBackDialog(eventtypesFormState, false,
                                      stepper: 4);
                                else
                                  _store.dispatch(UpdateEventTypesForm(4));
                              }
                            },
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                    Prefs.getBool(
                                                PrefsName.EventTypesAgreeTC) &&
                                            Prefs.getBool(
                                                PrefsName.EventTypesStep1) &&
                                            Prefs.getBool(
                                                PrefsName.EventTypesStep2) &&
                                            Prefs.getBool(
                                                PrefsName.EventTypesStep3)
                                        ? "assets/images/ic_circle_check.png"
                                        : eventtypesFormState.selectView > 4
                                            ? "assets/images/ic_circle_fill.png"
                                            : "assets/images/ic_circle_border.png",
                                    width: 30,
                                    height: 30,
                                    alignment: Alignment.topLeft,
                                  ),
                                ),
                                const SizedBox(height: 5.0),
                                Text(
                                  GlobleString.ET_Notifications,
                                  style:
                                      MyStyles.SemiBold(13, myColor.text_color),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void showBackDialog(EventTypesFormState eventtypesFormState, bool goback,
      {int stepper = 0}) {
    if (stepper == eventtypesFormState.selectView) return;
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: 'Mensaje creo', //GlobleString.PS_Save_EventTypess_msg,
          positiveText: 'Yes', //GlobleString.PS_Save_EventTypess_yes,
          negativeText: 'No', //GlobleString.PS_Save_EventTypesse_NO,
          onPressedNo: () {
            Navigator.of(context1).pop();
            if (goback && stepper == 0)
              _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
            else
              _store.dispatch(UpdateEventTypesForm(stepper));
          },
          onPressedYes: () {
            switch (eventtypesFormState.selectView) {
              case 1:
                navigationNotifier.change(
                    back: NavigationConstant.eventtypesDetails,
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
                    back: NavigationConstant.eventTypesSummary,
                    goBack: goback,
                    step: stepper);
                break;
            }
            Navigator.of(context1).pop();
            //ToastUtils.showCustomToast(context, eventtypesState.EventTypesName, false);
          },
        );
      },
    );
  }

  Widget _centerView(int val, EventTypesFormState eventtypesFormState) {
    switch (val) {
      case 1:
        {
          return StepEventTypesSetup(
            onPressedSave: () {
              _store.dispatch(UpdateEventTypesForm(2));
            },
          );
        }
      case 2:
        {
          return StepEventTypesAvailability(
            onPressedSave: () {
              _store.dispatch(UpdateEventTypesForm(3));
            },
            onPressedBack: () {
              if (AddEditEventTypes.isValueUpdate)
                showBackDialog(eventtypesFormState, false, stepper: 1);
              else
                _store.dispatch(UpdateEventTypesForm(1));
            },
          );
        }
      case 3:
        {
          return StepEventTypesQuestions(
            onPressedSave: () {
              _store.dispatch(UpdateEventTypesForm(4));
            },
            onPressedBack: () {
              if (AddEditEventTypes.isValueUpdate)
                showBackDialog(eventtypesFormState, false, stepper: 2);
              else
                _store.dispatch(UpdateEventTypesForm(2));
            },
          );
        }
      case 4:
        {
          return StepEventTypesNotifications(
            onPressedSave: () async {
              await Prefs.setBool(PrefsName.EventTypesEdit, false);
              await Prefs.setBool(PrefsName.EventTypesEditMode, false);
              await Prefs.setBool(PrefsName.EventTypesAgreeTC, false);
              await Prefs.setString(PrefsName.EventTypesID, "");
              _store.dispatch(
                  UpdatePortalPage(8, GlobleString.NAV_Scheduling_event_types));
            },
            onPressedBack: () {
              if (AddEditEventTypes.isValueUpdate)
                showBackDialog(eventtypesFormState, false, stepper: 3);
              else
                _store.dispatch(UpdateEventTypesForm(3));
            },
          );
        }
      default:
        {
          // CARGA MANUAL

          // Primera Pantalla
          //return StepEventTypesSetup(onPressedSave: () {_store.dispatch(UpdateEventTypesForm(2));},);

          // Segunda Pantalla
          return StepEventTypesSetup(
            onPressedSave: () {
              _store.dispatch(UpdateEventTypesForm(2));
            },
          );
          ;
        }
    }
  }

  /*===============================================================================================*/
  /*======================================  PDF FILE GENERETE  ====================================*/
  /*===============================================================================================*/
/*
  Future<void> Pdfgenerate(EventTypesSummeryState eventtypesState) async {
    final pdf = pw.Document(
      author: "Silver Home",
      pageMode: PdfPageMode.fullscreen,
      title: "EventTypes Document",
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
              BannerView(eventtypesState),

              // EventTypesDetails view
              EventTypesDetailsView(eventtypesState),

              // SpecificationRestrictionView view
              EventTypesSpecificationRestrictionView(eventtypesState),

              //EventTypesFeatureView(eventtypesState),
            ],
          ),
        ),
      ),
    );

    String filename = "eventtypes_" +
        DateFormat("ddMMyyyy_hhmmss").format(DateTime.now()).toString() +
        ".pdf";

    Uint8List pdfInBytes = await pdf.save();
    webarc.Archive archive = webarc.Archive();
    var pdffile =
        webarc.ArchiveFile.string(filename, String.fromCharCodes(pdfInBytes));
    archive.addFile(pdffile);

    try {
      List<String> namestring = [];
      for (EventTypesImageMediaInfo img
          in eventtypesState.SummeryeventtypesImagelist) {
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

    String zipname = "eventtypes_" +
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

  pw.Widget BannerView(EventTypesSummeryState eventtypesState) {
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
                    eventtypesState.EventTypesName,
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
                    eventtypesState.Suiteunit,
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
                eventtypesState.eventtypestypeValue == null
                    ? ""
                    : eventtypesState.eventtypestypeValue!.EnumDetailID == 6
                        ? eventtypesState.eventtypestypeOtherValue
                        : eventtypesState.eventtypestypeValue!.displayValue,
                style: pw.TextStyle(
                  color: PdfColors.white,
                  font: pw.Font.ttf(font_medium),
                  fontSize: 11,
                ),
                textAlign: pw.TextAlign.left,
              ),
              pw.Text(
                eventtypesState.Suiteunit +
                    " - " +
                    eventtypesState.EventTypesAddress +
                    ", " +
                    eventtypesState.City +
                    ", " +
                    eventtypesState.Province +
                    ", " +
                    eventtypesState.Postalcode +
                    ", " +
                    eventtypesState.CountryName,
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

  pw.Widget EventTypesDetailsView(EventTypesSummeryState eventtypesState) {
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
                EventTypesDetails(eventtypesState),
                pw.SizedBox(
                  width: 10,
                ),
                EventTypesLeaseDetails(eventtypesState)
              ],
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget EventTypesDetails(EventTypesSummeryState eventtypesState) {
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
              GlobleString.PS1_EventTypes_Details,
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
                    GlobleString.PS1_EventTypes_type,
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
                    eventtypesState.eventtypestypeValue == null
                        ? ""
                        : eventtypesState.eventtypestypeValue!.EnumDetailID == 6
                            ? eventtypesState.eventtypestypeOtherValue
                            : eventtypesState.eventtypestypeValue!.displayValue,
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
                    eventtypesState.rentalspaceValue == null
                        ? ""
                        : eventtypesState.rentalspaceValue!.displayValue,
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
                    eventtypesState.Buildingname,
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
                  GlobleString.PS1_EventTypes_description,
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
                        eventtypesState.EventTypesDescription,
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

  pw.Widget EventTypesLeaseDetails(EventTypesSummeryState eventtypesState) {
    String rentAmount = "";

    if (eventtypesState.RentAmount != null &&
        eventtypesState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(eventtypesState.RentAmount.replaceAll(",", "").toString()))}';
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
                    eventtypesState.dateofavailable == null
                        ? ""
                        : new DateFormat("dd-MMM-yyyy")
                            .format(eventtypesState.dateofavailable!)
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
                    eventtypesState.rentpaymentFrequencyValue == null
                        ? ""
                        : eventtypesState
                            .rentpaymentFrequencyValue!.displayValue,
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
                    eventtypesState.leasetypeValue == null
                        ? ""
                        : eventtypesState.leasetypeValue!.displayValue,
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
                    eventtypesState.minimumleasedurationnumber,
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
                    eventtypesState.minimumleasedurationValue == null
                        ? ""
                        : eventtypesState
                            .minimumleasedurationValue!.displayValue,
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

  pw.Widget EventTypesSpecificationRestrictionView(EventTypesSummeryState eventtypesState) {
    return pw.Padding(
      padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
      child: pw.Container(
        width: sswidth,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            SpecificationView(eventtypesState),
            pw.SizedBox(
              width: 10,
            ),
            RestrictionView(eventtypesState),
            pw.SizedBox(
              width: 10,
            ),
            FeatureView(eventtypesState),
          ],
        ),
      ),
    );
  }

  pw.Widget SpecificationView(EventTypesSummeryState eventtypesState) {
    String Size = "";

    if (eventtypesState.EventTypesSizeinsquarefeet != null &&
        eventtypesState.EventTypesSizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          eventtypesState.EventTypesSizeinsquarefeet.replaceAll(",", "")
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
                        eventtypesState.EventTypesBedrooms,
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
                        eventtypesState.EventTypesBathrooms,
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
                        eventtypesState.furnishingValue == null
                            ? ""
                            : eventtypesState.furnishingValue!.displayValue,
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

  pw.Widget RestrictionView(EventTypesSummeryState eventtypesState) {
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
                          itemCount: eventtypesState.restrictionlist.length,
                          itemBuilder: (pw.Context ctxt, int Index) {
                            SystemEnumDetails data =
                                eventtypesState.restrictionlist[Index];
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
                          itemCount: eventtypesState.restrictionlist.length,
                          itemBuilder: (pw.Context ctxt, int Index) {
                            SystemEnumDetails data =
                                eventtypesState.restrictionlist[Index];
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

  pw.Widget FeatureView(EventTypesSummeryState eventtypesState) {
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
              GlobleString.PS3_EventTypes_Features,
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
                        eventtypesState.Parkingstalls,
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
                        GlobleString.PS3_EventTypes_Features_StorageAvailable,
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
                        eventtypesState.storageavailableValue == null
                            ? ""
                            : eventtypesState
                                .storageavailableValue!.displayValue,
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

  // pw.Widget EventTypesFeatureView(EventTypesSummeryState eventtypesState) {
  //   int Acount1 = 0, Acount2 = 0, Acount3 = 0;
  //   for (int i = 0;
  //       i < eventtypesState.Summeryeventtypesamenitieslist.length;
  //       i++) {
  //     EventTypesAmenitiesUtility amenitiesUtility =
  //         eventtypesState.Summeryeventtypesamenitieslist[i];

  //     if (amenitiesUtility.value == "1") {
  //       Acount1++;
  //     } else if (amenitiesUtility.value == "2") {
  //       Acount2++;
  //     } else if (amenitiesUtility.value == "3") {
  //       Acount3++;
  //     }
  //   }

  //   int Ucount1 = 0, Ucount2 = 0, Ucount3 = 0;
  //   for (int j = 0;
  //       j < eventtypesState.Summeryeventtypesamenitieslist.length;
  //       j++) {
  //     EventTypesAmenitiesUtility amenitiesUtility =
  //         eventtypesState.Summeryeventtypesamenitieslist[j];

  //     if (amenitiesUtility.value == "1") {
  //       Ucount1++;
  //     } else if (amenitiesUtility.value == "2") {
  //       Ucount2++;
  //     } else if (amenitiesUtility.value == "3") {
  //       Ucount3++;
  //     }
  //   }

  //   //int AV = Acount1 + Ucount1;
  //   //int AVR = Acount2 + Ucount2;
  //   //int NAV = Acount3 + Ucount3;

  //   return pw.Padding(
  //     padding: pw.EdgeInsets.only(left: 10, bottom: 10, right: 10),
  //     child: pw.Container(
  //       width: sswidth,
  //       height: 400, //gethightofFeature(eventtypesState, AV, AVR, NAV),
  //       child: pw.Row(
  //         mainAxisAlignment: pw.MainAxisAlignment.start,
  //         crossAxisAlignment: pw.CrossAxisAlignment.start,
  //         children: [
  //           IncludedInTheRent(eventtypesState, Acount1, Ucount1),
  //           pw.SizedBox(
  //             width: 10,
  //           ),
  //           AvailableNotIncludedInTheRent(eventtypesState, Acount2, Ucount2),
  //           pw.SizedBox(
  //             width: 10,
  //           ),
  //           NotAvailable(eventtypesState, Acount3, Ucount3)
  //         ],
  //       ),
  //     ),
  //   );
  // }

  pw.Widget IncludedInTheRent(EventTypesSummeryState eventtypesState, int Acount, int Ucount) {
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
                        GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesamenitieslist[
                                          Index];
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesutilitieslist[
                                          Index];
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

  pw.Widget AvailableNotIncludedInTheRent(EventTypesSummeryState eventtypesState, int Acount, int Ucount) {
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
                        GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesamenitieslist[
                                          Index];
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesutilitieslist[
                                          Index];
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

  pw.Widget NotAvailable(EventTypesSummeryState eventtypesState, int Acount, int Ucount) {
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
                        GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesamenitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesamenitieslist[
                                          Index];
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesState
                                    .Summeryeventtypesutilitieslist.length,
                                itemBuilder: (pw.Context ctxt, int Index) {
                                  EventTypesAmenitiesUtility data =
                                      eventtypesState
                                              .Summeryeventtypesutilitieslist[
                                          Index];
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

  double gethightofFeature(EventTypesSummeryState eventtypesState, int AV, int AVR, int NAV) {
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
*/
}
