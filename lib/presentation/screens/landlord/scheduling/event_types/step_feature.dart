import 'dart:html' as html;
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/navigation_constants.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypes_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/eventtypesform_actions.dart';
import 'package:silverhome/domain/entities/eventtypes_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/eventtypes_summery_state.dart';
import 'package:silverhome/presentation/screens/landlord/eventtypes/add_edit_eventtypes.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/landlord/customewidget.dart';
import 'package:silverhome/widget/landlord/eventtypes_images.dart';
import 'package:silverhome/widget/landlord/eventtypesfeature/eventtypes_amenities_header.dart';
import 'package:silverhome/widget/landlord/eventtypesfeature/eventtypes_amenities_item.dart';
import 'package:silverhome/widget/landlord/eventtypesfeature/eventtypes_utilities_header.dart';
import 'package:silverhome/widget/landlord/eventtypesfeature/eventtypes_utilities_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../../models/landlord_models/eventtypes_state.dart';

class StepEventTypesFeature extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;

  StepEventTypesFeature({
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepEventTypesFeatureState createState() => _StepEventTypesFeatureState();
}

class _StepEventTypesFeatureState extends State<StepEventTypesFeature> {
  double ssheight = 0, sswidth = 0;

  final _store = getIt<AppStore>();

  late OverlayEntry overlayEntry;
  late OverlayEntry loader;
  bool isGotoback = false;
  int stepper = 0;
  // bool firsttime = true;
  bool change = false;

  @override
  void initState() {
    Prefs.init();
    filldata();
    initilize();
    initNavigationBack();
    AddEditEventTypes.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditEventTypes.isValueUpdate = true;
      change = true;
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.featuresAndPhotos) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        apiCallAndValidation(_store.state!.eventtypesState);
      }
    });
  }

  void filldata() {
    List<SystemEnumDetails> storageavailablelist = [];
    storageavailablelist = QueryFilter().PlainValues(eSystemEnums().Storage);

    _store.dispatch(UpdateStorageAvailableList(storageavailablelist));
  }

  void initilize() {
    AddEditEventTypes.isValueUpdate = false;

    if (_store.state!.eventtypesSummeryState != null) {
      EventTypesSummeryState eventtypesSummeryState =
          _store.state!.eventtypesSummeryState;

      _store.dispatch(UpdateEventTypesImageList(
          eventtypesSummeryState.SummeryeventtypesImagelist));

      List<EventTypesAmenitiesUtility> secondAmenityList =
          eventtypesSummeryState.Summeryeventtypesamenitieslist.map(
              (item) => new EventTypesAmenitiesUtility.clone(item)).toList();

      List<EventTypesAmenitiesUtility> secondUtilityList =
          eventtypesSummeryState.Summeryeventtypesutilitieslist.map(
              (item) => new EventTypesAmenitiesUtility.clone(item)).toList();

      _store.dispatch(UpdateEventTypesAmenitiesList(secondAmenityList));
      _store.dispatch(UpdateEventTypesUtilitiesList(secondUtilityList));
      _store.dispatch(UpdateParkingstalls(eventtypesSummeryState.Parkingstalls));
      _store.dispatch(UpdateStorageAvailableValue(
          eventtypesSummeryState.storageavailableValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      child: ConnectState<EventTypesState>(
          map: (state) => state.eventtypesState,
          where: notIdentical,
          builder: (eventtypesState) {
            return SingleChildScrollView(
              child: Container(
                child: FocusScope(
                  node: new FocusScopeNode(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GlobleString.PS3_EventTypes_Features,
                          style: MyStyles.Medium(20, myColor.Circle_main),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GlobleString.PS3_EventTypes_Features_title,
                          style: MyStyles.Regular(14, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EventTypesAmenitiesHeader(),
                          EventTypesAmenitiesItem(
                            listdata1: eventtypesState!.eventtypesamenitieslist,
                            callbackradio: (int pos, String value) {
                              //eventtypesState.eventtypesamenitieslist[pos].value = value;
                              // _store.dispatch(UpdateEventTypesAmenitiesList(eventtypesState.eventtypesamenitieslist));
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EventTypesUtilitiesHeader(),
                          EventTypesUtilitiesItem(
                            listdata1: eventtypesState.eventtypesutilitieslist,
                            callbackradio: (int pos, String value) {
                              // eventtypesState.eventtypesutilitieslist[pos].value = value;
                              //_store.dispatch(UpdateEventTypesUtilitiesList(eventtypesState.eventtypesutilitieslist));
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.PS3_EventTypes_Features_Parkingstalls,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              initialValue: eventtypesState.Parkingstalls,
                              textAlign: TextAlign.start,
                              autofocus: false,
                              style: MyStyles.Regular(14, myColor.text_color),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0000")],
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState.error_Parkingstalls
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: eventtypesState.error_Parkingstalls
                                            ? myColor.errorcolor
                                            : myColor.gray,
                                        width: 1.0),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(12),
                                  fillColor: myColor.white,
                                  filled: true),
                              onChanged: (value) {
                                _changeData();
                                _store.dispatch(UpdateParkingstalls(value));
                                _store
                                    .dispatch(UpdateErrorParkingstalls(false));
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString
                                  .PS3_EventTypes_Features_StorageAvailable,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 32,
                              child: DropdownSearch<SystemEnumDetails>(
                                key: UniqueKey(),
                                mode: Mode.MENU,
                                focuscolor: myColor.blue,
                                focusWidth: 2,
                                errorcolor: myColor.errorcolor,
                                isError: eventtypesState.error_storageavailable,
                                popupBackgroundColor: myColor.white,
                                items: eventtypesState.storageavailablelist,
                                defultHeight: double.parse(
                                    (eventtypesState.storageavailablelist.length *
                                            35)
                                        .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u != null ? u.displayValue : "",
                                hint: GlobleString.storage_availability,
                                showSearchBox: false,
                                selectedItem:
                                    eventtypesState.storageavailableValue != null
                                        ? eventtypesState.storageavailableValue
                                        : null,
                                isFilteredOnline: true,
                                onChanged: (value) {
                                  _changeData();
                                  _store.dispatch(
                                      UpdateStorageAvailableValue(value!));
                                  _store.dispatch(
                                      UpdateErrorStorageavailable(false));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      eventtypesImages(eventtypesState),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          back(),
                          SizedBox(width: 10),
                          saveandnext(eventtypesState)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }

  // Widget UpdateMethod() {
  //   if (!firsttime && !AddEditEventTypes.isValueUpdate) {
  //     AddEditEventTypes.isValueUpdate = true;
  //     firsttime = false;
  //   } else if (firsttime) {
  //     AddEditEventTypes.isValueUpdate = false;
  //     firsttime = false;
  //   }

  //   return SizedBox(
  //     width: 0,
  //     height: 0,
  //   );
  // }

  Widget eventtypesImages(EventTypesState eventtypesState) {
    return Container(
      width: sswidth,
      //padding: EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: myColor.white,
          border: Border.all(color: myColor.ps_boreder, width: 1),
        ),
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      GlobleString.PS1_EventTypes_Images,
                      style: MyStyles.Medium(20, myColor.Circle_main),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      " - ",
                      style: MyStyles.Regular(14, myColor.optional),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      GlobleString.PS1_EventTypes_Images_optional,
                      style: MyStyles.Regular(13, myColor.optional),
                      textAlign: TextAlign.start,
                    ),
                  ],
                )

                /*Row(
                  children: [
                    InkWell(
                      onTap: () {
                      },
                      child:  Container(
                        height: 35,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: myColor.Circle_main, width: 1.5),
                        ),
                        child: Text(
                          "Delete All Image",
                          style: MyStyles.Medium(14, myColor.Circle_main),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                      },
                      child:  Container(
                        height: 35,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: myColor.Circle_main,
                        ),
                        child: Text(
                          "Upload",
                          style: MyStyles.Medium(14, myColor.white),
                        ),
                      ),
                    )
                  ],
                )*/
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              GlobleString.PS1_EventTypes_Images_Allowed,
              style: MyStyles.Regular(13, myColor.optional),
              textAlign: TextAlign.start,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              height: 160,
              width: sswidth,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (eventtypesState.eventtypesImagelist.length < 10)
                    InkWell(
                      onTap: () {
                        PickMultipleImage(eventtypesState);
                      },
                      child: Container(
                        width: 100.0,
                        height: 100.0,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: myColor.Circle_main,
                          border:
                              Border.all(width: 2, color: myColor.Circle_main),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 70,
                        ),
                      ),
                    ),
                  if (eventtypesState.eventtypesImagelist.length < 10)
                    SizedBox(
                      width: 10,
                    ),
                  Expanded(
                    child: Scrollbar(
                      //isAlwaysShown: true,
                      child: ListView.builder(
                        itemCount: eventtypesState.eventtypesImagelist.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return EventTypesImagesCard(
                            callbackOnItemDelete: () {
                              deleteimage_dailogShow(
                                  eventtypesState,
                                  eventtypesState.eventtypesImagelist[index],
                                  index);
                            },
                            pos: index,
                            modelclass: eventtypesState.eventtypesImagelist[index],
                            callbackOnFeatured: (bool flag) {
                              if (flag) {
                                feature_dailogShow(
                                    eventtypesState,
                                    eventtypesState.eventtypesImagelist[index],
                                    index);
                              } else {}
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  deleteimage_dailogShow(EventTypesState eventtypesState,
      EventTypesImageMediaInfo eventtypesImageMediaInfo, int pos) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogBox(
          title: GlobleString.Prop_Image_Delete,
          positiveText: GlobleString.Prop_Image_btn_yes,
          negativeText: GlobleString.Prop_Image_btn_No,
          onPressedYes: () {
            _changeData();
            Navigator.of(context).pop();

            if (eventtypesImageMediaInfo.islive!) {
              CommonID eventtypesImageId = new CommonID();
              eventtypesImageId.ID = eventtypesImageMediaInfo.ImageID;

              CommonID mediaInfoId = new CommonID();
              mediaInfoId.ID = eventtypesImageMediaInfo.id.toString();

              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager()
                  .deleteEventTypesImage(context, eventtypesImageId, mediaInfoId,
                      (error, responce) async {
                if (error) {
                  loader.remove();
                  List<EventTypesImageMediaInfo> EventTypesImageMediaInfolist =
                      eventtypesState.eventtypesImagelist;
                  EventTypesImageMediaInfolist.removeAt(pos);
                  _store.dispatch(
                      UpdateEventTypesImageList(EventTypesImageMediaInfolist));
                  _store.dispatch(UpdateSummeryEventTypesImageList(
                      EventTypesImageMediaInfolist));
                } else {
                  loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            } else {
              List<EventTypesImageMediaInfo> EventTypesImageMediaInfolist =
                  eventtypesState.eventtypesImagelist;
              EventTypesImageMediaInfolist.removeAt(pos);
              _store.dispatch(
                  UpdateEventTypesImageList(EventTypesImageMediaInfolist));
            }
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  feature_dailogShow(EventTypesState eventtypesState,
      EventTypesImageMediaInfo eventtypesImageMediaInfo, int pos) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialogBox(
          title: GlobleString.Prop_Image_featured,
          positiveText: GlobleString.Prop_Image_btn_yes,
          negativeText: GlobleString.Prop_Image_btn_No,
          onPressedYes: () {
            _changeData();
            Navigator.of(context).pop();

            loader = Helper.overlayLoader(context);
            Overlay.of(context)!.insert(loader);

            ApiManager().setFeaturedImage(
                context,
                Prefs.getString(PrefsName.EventTypesID),
                eventtypesImageMediaInfo.id.toString(), (error, responce) async {
              if (error) {
                loader.remove();
                List<EventTypesImageMediaInfo> EventTypesImageMediaInfolist =
                    eventtypesState.eventtypesImagelist;
                for (int i = 0; i < EventTypesImageMediaInfolist.length; i++) {
                  EventTypesImageMediaInfolist[i].IsFavorite = false;
                }
                EventTypesImageMediaInfolist[pos].IsFavorite = true;
                _store.dispatch(
                    UpdateEventTypesImageList(EventTypesImageMediaInfolist));
                _store.dispatch(
                    UpdateSummeryEventTypesImageList(EventTypesImageMediaInfolist));
              } else {
                loader.remove();
                ToastUtils.showCustomToast(context, responce, false);
              }
            });
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void PickMultipleImage(EventTypesState eventtypesState) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'png',
          'jpeg',
          'heif',
        ],
        allowMultiple: true);
    if (result != null) {
      List<PlatformFile> files = result.files;

      int length = eventtypesState.eventtypesImagelist.length + files.length;
      if (length <= 10) {
        _changeData();
        List<EventTypesImageMediaInfo> EventTypesImageMediaInfolist = [];

        for (int i = 0; i < files.length; i++) {
          PlatformFile file = files[i];

          if ((file.name.split('.').last).contains("jpg") ||
              (file.name.split('.').last).contains("JPG") ||
              (file.name.split('.').last).contains("png") ||
              (file.name.split('.').last).contains("PNG") ||
              (file.name.split('.').last).contains("jpeg") ||
              (file.name.split('.').last).contains("JPEG") ||
              (file.name.split('.').last).contains("heif") ||
              (file.name.split('.').last).contains("HEIF")) {
            EventTypesImageMediaInfo eventtypesImageMediaInfo =
                new EventTypesImageMediaInfo();

            eventtypesImageMediaInfo.id = 0;
            eventtypesImageMediaInfo.fileType = 0;
            eventtypesImageMediaInfo.refId = 0;
            eventtypesImageMediaInfo.url = "";
            eventtypesImageMediaInfo.isActive = 0;
            eventtypesImageMediaInfo.sequence = 0;
            eventtypesImageMediaInfo.type = 0;
            eventtypesImageMediaInfo.islive = false;
            eventtypesImageMediaInfo.ishover = false;
            eventtypesImageMediaInfo.appImage = file.bytes;
            eventtypesImageMediaInfo.ImageID = "0";
            eventtypesImageMediaInfo.fileName = file.name;
            EventTypesImageMediaInfolist.add(eventtypesImageMediaInfo);

            if (files.length - 1 == i) {
              List<EventTypesImageMediaInfo> mylist =
                  eventtypesState.eventtypesImagelist;
              mylist.addAll(EventTypesImageMediaInfolist);

              _store.dispatch(UpdateEventTypesImageList(mylist));
            }
          } else {
            ToastUtils.showCustomToast(
                context, GlobleString.PS3_EventTypes_Image_error1, false);
            break;
          }
        }
      } else {
        int length = 10 - eventtypesState.eventtypesImagelist.length;
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_EventTypes_Image_maximum, false);
      }
    }

    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  Widget back() {
    return InkWell(
      onTap: () {
        widget._callbackBack();
      },
      child: CustomeWidget.TenantBackButton(),
    );
  }

  Widget saveandnext(EventTypesState eventtypesState) {
    return InkWell(
      onTap: () {
        apiCallAndValidation(eventtypesState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  apiCallAndValidation(EventTypesState eventtypesState) {
    if (eventtypesState.Parkingstalls.isEmpty) {
      _store.dispatch(UpdateErrorParkingstalls(true));
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_EventTypes_Features_Parkingstalls_error, false);
    } else if (eventtypesState.storageavailableValue == null) {
      _store.dispatch(UpdateErrorStorageavailable(true));
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_EventTypes_Features_StorageAvailable_error, false);
    }
    /*else if (eventtypesState.eventtypesImagelist.length == 0) {
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_EventTypes_Features_image_error, false);
    }*/
    else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      List<EventTypesAminityUtility> aminityutilitylist =
          <EventTypesAminityUtility>[];

      for (int i = 0; i < eventtypesState.eventtypesamenitieslist.length; i++) {
        EventTypesAmenitiesUtility amenitiesUtility =
            eventtypesState.eventtypesamenitieslist[i];

        EventTypesAminityUtility eventtypesAminityUtility =
            new EventTypesAminityUtility();

        eventtypesAminityUtility.Prop_ID = Prefs.getString(PrefsName.EventTypesID);
        eventtypesAminityUtility.Feature_ID = amenitiesUtility.id.toString();
        eventtypesAminityUtility.Feature_Value =
            amenitiesUtility.value.toString();

        aminityutilitylist.add(eventtypesAminityUtility);
      }

      for (int i = 0; i < eventtypesState.eventtypesutilitieslist.length; i++) {
        EventTypesAmenitiesUtility amenitiesUtility =
            eventtypesState.eventtypesutilitieslist[i];

        EventTypesAminityUtility eventtypesAminityUtility =
            new EventTypesAminityUtility();

        eventtypesAminityUtility.Prop_ID = Prefs.getString(PrefsName.EventTypesID);
        eventtypesAminityUtility.Feature_ID = amenitiesUtility.id.toString();
        eventtypesAminityUtility.Feature_Value =
            amenitiesUtility.value.toString();

        aminityutilitylist.add(eventtypesAminityUtility);
      }

      EventTypesFeature eventtypesFeature = new EventTypesFeature();
      eventtypesFeature.Parking_Stalls =
          eventtypesState.Parkingstalls.toString().trim();
      eventtypesFeature.StorageAvailable =
          eventtypesState.storageavailableValue!.EnumDetailID.toString().trim();

      if (eventtypesState.PropDrafting >= 2 && eventtypesState.PropDrafting <= 3) {
        eventtypesFeature.PropDrafting = 3;
      } else {
        eventtypesFeature.PropDrafting = eventtypesState.PropDrafting;
      }

      EventTypesUpdate eventtypesUpdate = new EventTypesUpdate();
      eventtypesUpdate.ID = Prefs.getString(PrefsName.EventTypesID);
      eventtypesUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      PropID propID =
          new PropID(Prop_ID: Prefs.getString(PrefsName.EventTypesID));

      List<EventTypesImageMediaInfo> eventtypesimagelist = [];

      for (int i = 0; i < eventtypesState.eventtypesImagelist.length; i++) {
        EventTypesImageMediaInfo eventtypesImageMediaInfo =
            eventtypesState.eventtypesImagelist[i];
        if (eventtypesImageMediaInfo.appImage != null) {
          eventtypesimagelist.add(eventtypesImageMediaInfo);
        }
      }

      ApiManager().deleteAllAmenitiesUtilities(context, propID,
          (error, respoce) async {
        if (error) {
          ApiManager().AddEventTypesFeature(
              context, aminityutilitylist, eventtypesUpdate, eventtypesFeature,
              (error, responce) async {
            if (error) {
              if (eventtypesimagelist.length > 0) {
                insertEventTypesImageCall(
                    eventtypesimagelist, eventtypesState, eventtypesFeature);
              } else {
                await Prefs.setBool(PrefsName.EventTypesStep3, true);
                loader.remove();
                UpdateSummeryData(eventtypesState);
                _store.dispatch(
                    UpdateEventTypesDrafting(eventtypesFeature.PropDrafting!));
                _store.dispatch(UpdateSummeryEventTypesDrafting(
                    eventtypesFeature.PropDrafting!));

                ToastUtils.showCustomToast(
                    context, GlobleString.PS_Save_EventTypesse, true);

                if (!isGotoback) {
                  if (stepper == 0)
                    widget._callbackSaveandNext();
                  else
                    _store.dispatch(UpdateEventTypesForm(stepper));
                } else {
                  _store.dispatch(
                      UpdatePortalPage(1, GlobleString.NAV_Properties));
                }
              }
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, respoce, false);
          Helper.Log("respoce", respoce);
        }
      });
    }
  }

  void UpdateSummeryData(EventTypesState eventtypesState) {
    _store.dispatch(UpdateSummeryParkingstalls(eventtypesState.Parkingstalls));
    _store.dispatch(UpdateSummeryStorageAvailableValue(
        eventtypesState.storageavailableValue));
    _store.dispatch(UpdateSummeryEventTypesAmenitiesList(
        eventtypesState.eventtypesamenitieslist));
    _store.dispatch(UpdateSummeryEventTypesUtilitiesList(
        eventtypesState.eventtypesutilitieslist));
  }

  insertEventTypesImageCall(List<EventTypesImageMediaInfo> eventtypesimagelist,
      EventTypesState eventtypesState, EventTypesFeature eventtypesFeature) {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    ApiManager().EventTypesImagesUpload(context, eventtypesimagelist,
        (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertEventTypesImage> imagelist = <InsertEventTypesImage>[];

          for (int i = 0; i < listString.length; i++) {
            imagelist.add(new InsertEventTypesImage(
              Media_ID: listString[i],
              EventTypes_ID: Prefs.getString(PrefsName.EventTypesID),
              Owner_ID: Prefs.getString(PrefsName.OwnerID),
            ));
          }

          ApiManager().InsetEventTypesImages(context, imagelist,
              (status, responce) async {
            if (status) {
              getEventTypesImages(eventtypesState, eventtypesFeature);
            } else {
              loader.remove();
              ToastUtils.showCustomToast(context, responce, false);
            }
          });
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, responce, false);
      }
    });
  }

  getEventTypesImages(
      EventTypesState eventtypesState, EventTypesFeature eventtypesFeature) {
    SelectEventTypesImage check = new SelectEventTypesImage();
    check.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    check.EventTypes_ID = Prefs.getString(PrefsName.EventTypesID);

    ApiManager().getEventTypesImages(context, check, (error, respoce) async {
      if (error) {
        await Prefs.setBool(PrefsName.EventTypesStep3, true);
        loader.remove();
        UpdateSummeryData(eventtypesState);
        _store.dispatch(UpdateEventTypesDrafting(eventtypesFeature.PropDrafting!));
        _store.dispatch(
            UpdateSummeryEventTypesDrafting(eventtypesFeature.PropDrafting!));

        ToastUtils.showCustomToast(
            context, GlobleString.PS_Save_EventTypesse, true);

        if (!isGotoback) {
          if (stepper == 0)
            widget._callbackSaveandNext();
          else
            _store.dispatch(UpdateEventTypesForm(stepper));
        } else {
          _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
        }
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }
}
