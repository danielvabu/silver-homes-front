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
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/event_types_summery_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/alert/ImageDialog.dart';
import 'package:silverhome/widget/internet/_network_image_web.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';

import 'add_edit_eventtypes.dart';

typedef VoidCallback = void Function();
typedef VoidCallbackSaveandNext = void Function();

final formatCurrency = new NumberFormat.currency(locale: "en_US", symbol: "\$");
final formatSize = new NumberFormat.currency(locale: "en_US", symbol: "");

class StepEventTypesNotifications extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallbackSaveandNext _callbackSaveandNext;

  StepEventTypesNotifications({
    required VoidCallback onPressedBack,
    required VoidCallbackSaveandNext onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesNotificationsState createState() =>
      _StepEventTypesNotificationsState();
}

class _StepEventTypesNotificationsState
    extends State<StepEventTypesNotifications> {
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
          NavigationConstant.eventTypesSummary) {
        stepper = navigationNotifier.stepper;
        _addSaveAndFinishCall(_store.state!.eventTypesSummeryState);
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
          child: ConnectState<EventTypesSummeryState>(
            map: (state) => state.eventTypesSummeryState,
            where: notIdentical,
            builder: (eventtypesSummeryState) {
              return Column(
                children: [
                  bannerView(eventtypesSummeryState!),
                  eventtypesImages(eventtypesSummeryState),
                  eventtypesDetailsView(eventtypesSummeryState),
                  eventtypesSpecificationRestrictionView(
                      eventtypesSummeryState),
                  //eventtypesFeatureView(eventtypesSummeryState),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      back(),
                      SizedBox(width: 10),
                      editsaveandfinish(eventtypesSummeryState)
                    ],
                  ),
                  /*Prefs.getBool(PrefsName.EventTypesEditMode) &&
                          Prefs.getBool(PrefsName.EventTypesAgreeTC)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            back(),
                            SizedBox(width: 10),
                            editsaveandfinish(eventtypesSummeryState)
                          ],
                        )
                      : EventTypesDisclosureView(eventtypesSummeryState),*/
                  const SizedBox(height: 10.0),
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
    if (!firsttime && !AddEditEventTypes.isValueUpdate) {
      AddEditEventTypes.isValueUpdate = true;
      firsttime = false;
    } else if (firsttime) {
      AddEditEventTypes.isValueUpdate = false;
      firsttime = false;
    }

    return SizedBox(width: 0, height: 0);
  }

  Widget bannerView(EventTypesSummeryState eventtypesSummeryState) {
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
          //SingleEventTypesImage(eventtypesSummeryState),
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
                      eventtypesSummeryState.EventTypesName,
                      style: MyStyles.SemiBold(22, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      " - ",
                      style: MyStyles.SemiBold(22, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      eventtypesSummeryState.Suiteunit,
                      style: MyStyles.SemiBold(20, myColor.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  eventtypesSummeryState.eventtypestypeValue == null
                      ? ""
                      : eventtypesSummeryState
                                  .eventtypestypeValue!.EnumDetailID ==
                              6
                          ? eventtypesSummeryState.eventtypestypeOtherValue
                          : eventtypesSummeryState
                              .eventtypestypeValue!.displayValue,
                  style: MyStyles.Medium(16, myColor.white),
                  textAlign: TextAlign.start,
                ),
                Text(
                  eventtypesSummeryState.Suiteunit +
                      " - " +
                      eventtypesSummeryState.EventTypesAddress +
                      ", " +
                      eventtypesSummeryState.City +
                      ", " +
                      eventtypesSummeryState.Province +
                      ", " +
                      eventtypesSummeryState.Postalcode +
                      ", " +
                      eventtypesSummeryState.CountryName,
                  style: MyStyles.Medium(16, myColor.white),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (Prefs.getBool(PrefsName.EventTypesEditMode)) {
                _store.dispatch(UpdateEventTypesForm(1));
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

  Widget eventtypesImages(EventTypesSummeryState eventtypesSummeryState) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
      child: Container(
        height: 197,
        width: sswidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: const [
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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Images pa que', //GlobleString.PS1_EventTypes_Images1,
                  style: MyStyles.SemiBold(16, myColor.black),
                  textAlign: TextAlign.start,
                ),
                /*if (eventtypesSummeryState.SummeryeventtypesImagelist != null && eventtypesSummeryState.SummeryeventtypesImagelist.length > 0)
                  IconButton(
                    icon: Icon(
                      Icons.download_sharp,
                      color: myColor.black,
                      size: 25,
                    ),
                    onPressed: () {
                      if (eventtypesSummeryState.SummeryeventtypesImagelist !=
                              null &&
                          eventtypesSummeryState
                                  .SummeryeventtypesImagelist.length >
                              0) {
                        CustomeWidget.EventTypesSummaryImageZip(context,
                            eventtypesSummeryState.SummeryeventtypesImagelist);
                      } else {
                        ToastUtils.showCustomToast(
                            context,
                            GlobleString.PS3_EventTypes_NoImageAvailable,
                            false);
                      }
                    },
                  )
                else*/
                Container(),
              ],
            ),
            const SizedBox(height: 5.0),
            /*if (eventtypesSummeryState.SummeryeventtypesImagelist != null && eventtypesSummeryState.SummeryeventtypesImagelist.length > 0)
              Container(
                height: 130,
                width: sswidth,
                alignment: Alignment.centerLeft,
                child: Scrollbar(
                  //isAlwaysShown: true,
                  child: ListView.builder(
                    key: UniqueKey(),
                    shrinkWrap: true,
                    itemCount: eventtypesSummeryState
                        .SummeryeventtypesImagelist.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      EventTypesImageMediaInfo eventtypesImageMediaInfo =
                          eventtypesSummeryState
                              .SummeryeventtypesImagelist[index];
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
                                eventtypesImageMediaInfo.id.toString(),
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
                                    eventtypesImageMediaInfo.id.toString()));
                          },
                          child: FadeInImage(
                            fit: BoxFit.fill,
                            placeholder:
                                AssetImage('assets/images/placeholder.png'),
                            image: CustomNetworkImage(
                              Weburl.image_API +
                                  eventtypesImageMediaInfo.id.toString(),
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
            else*/
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

  /*Widget SingleEventTypesImage(EventTypesSummeryState eventtypesSummeryState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        eventtypesSummeryState.eventtypesImage != null &&
                eventtypesSummeryState.eventtypesImage!.id != null
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
                            eventtypesSummeryState.eventtypesImage!.id
                                .toString(),
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
            : eventtypesSummeryState.appimage != null
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
                            eventtypesSummeryState.appimage!,
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
*/
  /*void PickImage() async {
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
        _store.dispatch(UpdateSummeryEventTypesImage(null));
        _store.dispatch(UpdateSummeryEventTypesUint8List(file.bytes!));
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_EventTypes_Image_error, false);
      }
    }
  }*/

  Widget eventtypesDetailsView(EventTypesSummeryState eventtypesSummeryState) {
    String rentAmount = "";

    if (eventtypesSummeryState.RentAmount != null &&
        eventtypesSummeryState.RentAmount != "") {
      String amount =
          '${formatCurrency.format(int.parse(eventtypesSummeryState.RentAmount.replaceAll(",", "").toString()))}';
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
                          'Details',
                          //GlobleString.PS1_EventTypes_Details,
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
                                'Types',
                                //GlobleString.PS1_EventTypes_type,
                                style: MyStyles.Medium(14, myColor.black),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                eventtypesSummeryState.eventtypestypeValue ==
                                        null
                                    ? ""
                                    : eventtypesSummeryState
                                                .eventtypestypeValue!
                                                .EnumDetailID ==
                                            6
                                        ? eventtypesSummeryState
                                            .eventtypestypeOtherValue
                                        : eventtypesSummeryState
                                            .eventtypestypeValue!.displayValue,
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
                                eventtypesSummeryState.rentalspaceValue == null
                                    ? ""
                                    : eventtypesSummeryState
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
                                eventtypesSummeryState.Buildingname,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Description',
                              //GlobleString.PS1_EventTypes_description,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 5.0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    eventtypesSummeryState
                                        .EventTypesDescription,
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
                const SizedBox(width: 15.0),
                Expanded(
                  child: Container(
                    height: 296,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: myColor.white,
                      border: Border.all(color: myColor.ps_boreder, width: 1),
                      boxShadow: const [
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
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.PS1_Lease_Details,
                          style: MyStyles.SemiBold(16, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 20.0),
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
                        const SizedBox(height: 8.0),
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
                                eventtypesSummeryState.dateofavailable == null
                                    ? ""
                                    : new DateFormat("dd-MMM-yyyy")
                                        .format(eventtypesSummeryState
                                            .dateofavailable!)
                                        .toString(),
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
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
                                eventtypesSummeryState
                                            .rentpaymentFrequencyValue ==
                                        null
                                    ? ""
                                    : eventtypesSummeryState
                                        .rentpaymentFrequencyValue!
                                        .displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
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
                                eventtypesSummeryState.leasetypeValue == null
                                    ? ""
                                    : eventtypesSummeryState
                                        .leasetypeValue!.displayValue,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
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
                        const SizedBox(height: 8.0),
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
                                eventtypesSummeryState
                                    .minimumleasedurationnumber,
                                style: MyStyles.Regular(14, myColor.text_color),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4.0),
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
                                eventtypesSummeryState
                                            .minimumleasedurationValue ==
                                        null
                                    ? ""
                                    : eventtypesSummeryState
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

  Widget eventtypesSpecificationRestrictionView(
      EventTypesSummeryState eventtypesSummeryState) {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 15, right: 15),
      child: Container(
        width: sswidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            specificationView(eventtypesSummeryState),
            const SizedBox(width: 15.0),
            restrictionView(eventtypesSummeryState),
            const SizedBox(width: 15.0),
            featureView(eventtypesSummeryState),
          ],
        ),
      ),
    );
  }

  Widget specificationView(EventTypesSummeryState eventtypesSummeryState) {
    String Size = "";

    if (eventtypesSummeryState.EventTypesSizeinsquarefeet != null &&
        eventtypesSummeryState.EventTypesSizeinsquarefeet != "") {
      String sqft = formatSize.format(int.parse(
          eventtypesSummeryState.EventTypesSizeinsquarefeet.replaceAll(",", "")
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
          boxShadow: const [
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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.ps4_Specifications,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20.0),
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
                      const SizedBox(height: 5.0),
                      Text(
                        eventtypesSummeryState.EventTypesBedrooms,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
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
                      const SizedBox(height: 5.0),
                      Text(
                        eventtypesSummeryState.EventTypesBathrooms,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
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
                      const SizedBox(height: 5.0),
                      Text(
                        Size,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
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
                      const SizedBox(height: 5.0),
                      Text(
                        eventtypesSummeryState.furnishingValue == null
                            ? ""
                            : eventtypesSummeryState
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

  Widget restrictionView(EventTypesSummeryState eventtypesSummeryState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: const [
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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              GlobleString.ps4_Restrictions,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20.0),
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
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          //scrollDirection: Axis.vertical,
                          key: UniqueKey(),
                          itemCount:
                              eventtypesSummeryState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                eventtypesSummeryState.restrictionlist[Index];
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
                const SizedBox(width: 10.0),
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
                      const SizedBox(height: 10.0),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: ListView.builder(
                          //scrollDirection: Axis.vertical,
                          key: UniqueKey(),
                          itemCount:
                              eventtypesSummeryState.restrictionlist.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext ctxt, int Index) {
                            SystemEnumDetails data =
                                eventtypesSummeryState.restrictionlist[Index];
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

  Widget featureView(EventTypesSummeryState eventtypesSummeryState) {
    return Expanded(
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
          boxShadow: const [
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
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Features',
              //GlobleString.PS3_EventTypes_Features,
              style: MyStyles.SemiBold(16, myColor.black),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20.0),
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
                      const SizedBox(height: 5.0),
                      Text(
                        eventtypesSummeryState.Parkingstalls,
                        style: MyStyles.Regular(14, myColor.black),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Storage no',
                        //GlobleString.PS3_EventTypes_Features_StorageAvailable,
                        style: MyStyles.Medium(14, myColor.Circle_main),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        eventtypesSummeryState.storageavailableValue == null
                            ? ""
                            : eventtypesSummeryState
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

  /*Widget eventtypesFeatureView(EventTypesSummeryState eventtypesSummeryState) {
    int Acount1 = 0, Acount2 = 0, Acount3 = 0;
    for (int i = 0;
        i < eventtypesSummeryState.Summeryeventtypesamenitieslist.length;
        i++) {
      EventTypesAmenitiesUtility amenitiesUtility =
          eventtypesSummeryState.Summeryeventtypesamenitieslist[i];

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
        j < eventtypesSummeryState.Summeryeventtypesutilitieslist.length;
        j++) {
      EventTypesAmenitiesUtility amenitiesUtility =
          eventtypesSummeryState.Summeryeventtypesutilitieslist[j];

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
            IncludedInTheRent(eventtypesSummeryState, Acount1, Ucount1),
            SizedBox(
              width: 15,
            ),
            AvailableNotIncludedInTheRent(
                eventtypesSummeryState, Acount2, Ucount2),
            SizedBox(
              width: 15,
            ),
            NotAvailable(eventtypesSummeryState, Acount3, Ucount3)
          ],
        ),
      ),
    );
  }
*/

/*  Widget IncludedInTheRent(EventTypesSummeryState eventtypesSummeryState, int Acount, int Ucount) {
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
                      Text('Amenities no',
                        //GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
                                                  Index]
                                              .value ==
                                          "1"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
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
*/

/*  Widget AvailableNotIncludedInTheRent(EventTypesSummeryState eventtypesSummeryState, int Acount, int Ucount) {
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
                        GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
                                                  Index]
                                              .value ==
                                          "2"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
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
*/

/*  Widget NotAvailable(EventTypesSummeryState eventtypesSummeryState, int Acount, int Ucount) {
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
                        GlobleString.PS3_EventTypes_Features_Amenities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesamenitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesamenitieslist[
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
                        GlobleString.PS3_EventTypes_Features_Utilities,
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
                                itemCount: eventtypesSummeryState
                                    .Summeryeventtypesutilitieslist.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext ctxt, int Index) {
                                  return eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
                                                  Index]
                                              .value ==
                                          "3"
                                      ? Text(
                                          eventtypesSummeryState
                                              .Summeryeventtypesutilitieslist[
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
*/

  Widget EventTypesDisclosureView(
      EventTypesSummeryState eventtypesSummeryState) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
      child: Container(
        width: sswidth,
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5, bottom: 25),
              child: Text(
                GlobleString.PS_Disclosures,
                style: MyStyles.SemiBold(16, myColor.black),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 7),
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
            const SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Checkbox(
                  activeColor: myColor.Circle_main,
                  checkColor: myColor.white,
                  value: eventtypesSummeryState.agree_TCPP,
                  onChanged: (value) {
                    _store.dispatch(UpdateSummeryAgreeTCPP(value!));
                  },
                ),
                const SizedBox(width: 10.0),
                Text(
                  GlobleString.ps4_disclosure_Iagree,
                  style: MyStyles.Regular(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                back(),
                const SizedBox(width: 10),
                addsaveandfinish(eventtypesSummeryState)
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

  Widget addsaveandfinish(EventTypesSummeryState eventtypesSummeryState) {
    return InkWell(
      onTap: () async {
        /* if (eventtypesSummeryState.PropDrafting != 3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_EventTypes_all_details, false);
        }*/

        bool prostep1 = await Prefs.getBool(PrefsName.EventTypesStep1);
        bool prostep2 = await Prefs.getBool(PrefsName.EventTypesStep2);
        bool prostep3 = await Prefs.getBool(PrefsName.EventTypesStep3);

        if (!prostep1 || !prostep2 || !prostep3) {
          //ToastUtils.showCustomToast(context, GlobleString.PS3_EventTypes_all_details, false);
          ToastUtils.showCustomToast(context, 'Details', false);
        } else if (!eventtypesSummeryState.agree_TCPP) {
          //ToastUtils.showCustomToast(context, GlobleString.PS3_EventTypes_Disclosures, false);
          ToastUtils.showCustomToast(context, 'Disclosures', false);
        } else {
          _addSaveAndFinishCall(eventtypesSummeryState);
        }
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_Finish),
    );
  }

  Widget editsaveandfinish(EventTypesSummeryState eventtypesSummeryState) {
    return InkWell(
      onTap: () async {
        bool prostep1 = await Prefs.getBool(PrefsName.EventTypesStep1);
        bool prostep2 = await Prefs.getBool(PrefsName.EventTypesStep2);
        bool prostep3 = await Prefs.getBool(PrefsName.EventTypesStep3);

        if (!prostep1 || !prostep2 || !prostep3) {
          //ToastUtils.showCustomToast(context, GlobleString.PS3_EventTypes_all_details, false);
          ToastUtils.showCustomToast(context, 'All Details', false);
        }
        /*if (eventtypesSummeryState.PropDrafting != 3) {
          ToastUtils.showCustomToast(
              context, GlobleString.PS3_EventTypes_all_details, false);
        }*/
        else {
          _addSaveAndFinishCall(eventtypesSummeryState);
          //_updateEventTypesImageCall(eventtypesSummeryState.eventtypesImage);
          //widget._callbackSaveandNext();
        }
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_Finish),
    );
  }

  _addSaveAndFinishCall(EventTypesSummeryState eventtypesSummeryState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (eventtypesSummeryState.appimage != null) {
      ApiManager().AddSingleImage(context, eventtypesSummeryState.appimage!,
          (status, responce) {
        if (status) {
          final String id = '__file_picker_web-file-input';
          var element = html.document.getElementById(id);
          if (element != null) {
            element.remove();
          }

          _updateEventTypesImageCall(responce, eventtypesSummeryState);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      _updateEventTypesImageCall("0", eventtypesSummeryState);
    }
  }

  _updateEventTypesImageCall(
      String imagename, EventTypesSummeryState eventtypesSummeryState) {
    EventTypesDisclosure eventtypesd = EventTypesDisclosure();
    //eventtypesd.EventTypes_Image = imagename;
    eventtypesd.IsAgreed_TandC = true;
    eventtypesd.IsActive = Prefs.getBool(PrefsName.EventTypesActive);
    eventtypesd.PropDrafting = 3;

    EventTypesUpdate ceventtypesUpdate = EventTypesUpdate();
    ceventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
    ceventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().UpdateEventTypesDisclosure(
        context, ceventtypesUpdate, eventtypesd, (error, respoce) {
      if (error) {
        loader.remove();

        //ToastUtils.showCustomToast(context, GlobleString.PS_Save_EventTypesse, true);
        ToastUtils.showCustomToast(context, 'Save Evet Types', true);

        if (stepper == 0)
          widget._callbackSaveandNext();
        else
          _store.dispatch(UpdateEventTypesForm(stepper));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }
}
