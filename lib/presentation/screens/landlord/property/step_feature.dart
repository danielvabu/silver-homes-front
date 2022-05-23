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
import 'package:silverhome/domain/actions/landlord_action/property_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_feature_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/property_summery_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/propertyform_actions.dart';
import 'package:silverhome/domain/entities/property_amenities.dart';
import 'package:silverhome/presentation/models/landlord_models/property_summery_state.dart';
import 'package:silverhome/presentation/screens/landlord/property/add_edit_property.dart';
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
import 'package:silverhome/widget/landlord/property_images.dart';
import 'package:silverhome/widget/landlord/propertyfeature/property_amenities_header.dart';
import 'package:silverhome/widget/landlord/propertyfeature/property_amenities_item.dart';
import 'package:silverhome/widget/landlord/propertyfeature/property_utilities_header.dart';
import 'package:silverhome/widget/landlord/propertyfeature/property_utilities_item.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import '../../../models/landlord_models/property_state.dart';

class StepPropertyFeature extends StatefulWidget {
  final VoidCallback _callbackBack;
  final VoidCallback _callbackSaveandNext;

  StepPropertyFeature({
    required VoidCallback onPressedBack,
    required VoidCallback onPressedSave,
  })  : _callbackBack = onPressedBack,
        _callbackSaveandNext = onPressedSave;

  @override
  _StepPropertyFeatureState createState() => _StepPropertyFeatureState();
}

class _StepPropertyFeatureState extends State<StepPropertyFeature> {
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
    AddEditProperty.isValueUpdate = false;
    super.initState();
  }

  _changeData() {
    if (!change) {
      AddEditProperty.isValueUpdate = true;
      change = true;
    }
  }

  initNavigationBack() {
    navigationNotifier.addListener(() {
      if (mounted) if (navigationNotifier.backScreen ==
          NavigationConstant.featuresAndPhotos) {
        isGotoback = navigationNotifier.gotoBack;
        stepper = navigationNotifier.stepper;
        apiCallAndValidation(_store.state!.propertyState);
      }
    });
  }

  void filldata() {
    List<SystemEnumDetails> storageavailablelist = [];
    storageavailablelist = QueryFilter().PlainValues(eSystemEnums().Storage);

    _store.dispatch(UpdateStorageAvailableList(storageavailablelist));
  }

  void initilize() {
    AddEditProperty.isValueUpdate = false;

    if (_store.state!.propertySummeryState != null) {
      PropertySummeryState propertySummeryState =
          _store.state!.propertySummeryState;

      _store.dispatch(UpdatePropertyImageList(
          propertySummeryState.SummerypropertyImagelist));

      List<PropertyAmenitiesUtility> secondAmenityList =
          propertySummeryState.Summerypropertyamenitieslist.map(
              (item) => new PropertyAmenitiesUtility.clone(item)).toList();

      List<PropertyAmenitiesUtility> secondUtilityList =
          propertySummeryState.Summerypropertyutilitieslist.map(
              (item) => new PropertyAmenitiesUtility.clone(item)).toList();

      _store.dispatch(UpdatePropertyAmenitiesList(secondAmenityList));
      _store.dispatch(UpdatePropertyUtilitiesList(secondUtilityList));
      _store.dispatch(UpdateParkingstalls(propertySummeryState.Parkingstalls));
      _store.dispatch(UpdateStorageAvailableValue(
          propertySummeryState.storageavailableValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      width: sswidth,
      height: ssheight - 186,
      child: ConnectState<PropertyState>(
          map: (state) => state.propertyState,
          where: notIdentical,
          builder: (propertyState) {
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
                          GlobleString.PS3_Property_Features,
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
                          GlobleString.PS3_Property_Features_title,
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
                          PropertyAmenitiesHeader(),
                          PropertyAmenitiesItem(
                            listdata1: propertyState!.propertyamenitieslist,
                            callbackradio: (int pos, String value) {
                              //propertyState.propertyamenitieslist[pos].value = value;
                              // _store.dispatch(UpdatePropertyAmenitiesList(propertyState.propertyamenitieslist));
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
                          PropertyUtilitiesHeader(),
                          PropertyUtilitiesItem(
                            listdata1: propertyState.propertyutilitieslist,
                            callbackradio: (int pos, String value) {
                              // propertyState.propertyutilitieslist[pos].value = value;
                              //_store.dispatch(UpdatePropertyUtilitiesList(propertyState.propertyutilitieslist));
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
                              GlobleString.PS3_Property_Features_Parkingstalls,
                              style: MyStyles.Medium(14, myColor.black),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              initialValue: propertyState.Parkingstalls,
                              textAlign: TextAlign.start,
                              autofocus: false,
                              style: MyStyles.Regular(14, myColor.text_color),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [MaskedInputFormatter("0000")],
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState.error_Parkingstalls
                                            ? myColor.errorcolor
                                            : myColor.blue,
                                        width: 2),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: propertyState.error_Parkingstalls
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
                                  .PS3_Property_Features_StorageAvailable,
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
                                isError: propertyState.error_storageavailable,
                                popupBackgroundColor: myColor.white,
                                items: propertyState.storageavailablelist,
                                defultHeight: double.parse(
                                    (propertyState.storageavailablelist.length *
                                            35)
                                        .toString()),
                                textstyle:
                                    MyStyles.Medium(14, myColor.text_color),
                                itemAsString: (SystemEnumDetails? u) =>
                                    u != null ? u.displayValue : "",
                                hint: GlobleString.storage_availability,
                                showSearchBox: false,
                                selectedItem:
                                    propertyState.storageavailableValue != null
                                        ? propertyState.storageavailableValue
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
                      propertyImages(propertyState),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          back(),
                          SizedBox(width: 10),
                          saveandnext(propertyState)
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
  //   if (!firsttime && !AddEditProperty.isValueUpdate) {
  //     AddEditProperty.isValueUpdate = true;
  //     firsttime = false;
  //   } else if (firsttime) {
  //     AddEditProperty.isValueUpdate = false;
  //     firsttime = false;
  //   }

  //   return SizedBox(
  //     width: 0,
  //     height: 0,
  //   );
  // }

  Widget propertyImages(PropertyState propertyState) {
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
                      GlobleString.PS1_Property_Images,
                      style: MyStyles.Medium(20, myColor.Circle_main),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      " - ",
                      style: MyStyles.Regular(14, myColor.optional),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      GlobleString.PS1_Property_Images_optional,
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
              GlobleString.PS1_Property_Images_Allowed,
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
                  if (propertyState.propertyImagelist.length < 10)
                    InkWell(
                      onTap: () {
                        PickMultipleImage(propertyState);
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
                  if (propertyState.propertyImagelist.length < 10)
                    SizedBox(
                      width: 10,
                    ),
                  Expanded(
                    child: Scrollbar(
                      //isAlwaysShown: true,
                      child: ListView.builder(
                        itemCount: propertyState.propertyImagelist.length,
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (
                          context,
                          index,
                        ) {
                          return PropertyImagesCard(
                            callbackOnItemDelete: () {
                              deleteimage_dailogShow(
                                  propertyState,
                                  propertyState.propertyImagelist[index],
                                  index);
                            },
                            pos: index,
                            modelclass: propertyState.propertyImagelist[index],
                            callbackOnFeatured: (bool flag) {
                              if (flag) {
                                feature_dailogShow(
                                    propertyState,
                                    propertyState.propertyImagelist[index],
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

  deleteimage_dailogShow(PropertyState propertyState,
      PropertyImageMediaInfo propertyImageMediaInfo, int pos) {
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

            if (propertyImageMediaInfo.islive!) {
              CommonID propertyImageId = new CommonID();
              propertyImageId.ID = propertyImageMediaInfo.ImageID;

              CommonID mediaInfoId = new CommonID();
              mediaInfoId.ID = propertyImageMediaInfo.id.toString();

              loader = Helper.overlayLoader(context);
              Overlay.of(context)!.insert(loader);

              ApiManager()
                  .deletePropertyImage(context, propertyImageId, mediaInfoId,
                      (error, responce) async {
                if (error) {
                  loader.remove();
                  List<PropertyImageMediaInfo> PropertyImageMediaInfolist =
                      propertyState.propertyImagelist;
                  PropertyImageMediaInfolist.removeAt(pos);
                  _store.dispatch(
                      UpdatePropertyImageList(PropertyImageMediaInfolist));
                  _store.dispatch(UpdateSummeryPropertyImageList(
                      PropertyImageMediaInfolist));
                } else {
                  loader.remove();
                  ToastUtils.showCustomToast(context, responce, false);
                }
              });
            } else {
              List<PropertyImageMediaInfo> PropertyImageMediaInfolist =
                  propertyState.propertyImagelist;
              PropertyImageMediaInfolist.removeAt(pos);
              _store.dispatch(
                  UpdatePropertyImageList(PropertyImageMediaInfolist));
            }
          },
          onPressedNo: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  feature_dailogShow(PropertyState propertyState,
      PropertyImageMediaInfo propertyImageMediaInfo, int pos) {
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
                Prefs.getString(PrefsName.PropertyID),
                propertyImageMediaInfo.id.toString(), (error, responce) async {
              if (error) {
                loader.remove();
                List<PropertyImageMediaInfo> PropertyImageMediaInfolist =
                    propertyState.propertyImagelist;
                for (int i = 0; i < PropertyImageMediaInfolist.length; i++) {
                  PropertyImageMediaInfolist[i].IsFavorite = false;
                }
                PropertyImageMediaInfolist[pos].IsFavorite = true;
                _store.dispatch(
                    UpdatePropertyImageList(PropertyImageMediaInfolist));
                _store.dispatch(
                    UpdateSummeryPropertyImageList(PropertyImageMediaInfolist));
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

  void PickMultipleImage(PropertyState propertyState) async {
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

      int length = propertyState.propertyImagelist.length + files.length;
      if (length <= 10) {
        _changeData();
        List<PropertyImageMediaInfo> PropertyImageMediaInfolist = [];

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
            PropertyImageMediaInfo propertyImageMediaInfo =
                new PropertyImageMediaInfo();

            propertyImageMediaInfo.id = 0;
            propertyImageMediaInfo.fileType = 0;
            propertyImageMediaInfo.refId = 0;
            propertyImageMediaInfo.url = "";
            propertyImageMediaInfo.isActive = 0;
            propertyImageMediaInfo.sequence = 0;
            propertyImageMediaInfo.type = 0;
            propertyImageMediaInfo.islive = false;
            propertyImageMediaInfo.ishover = false;
            propertyImageMediaInfo.appImage = file.bytes;
            propertyImageMediaInfo.ImageID = "0";
            propertyImageMediaInfo.fileName = file.name;
            PropertyImageMediaInfolist.add(propertyImageMediaInfo);

            if (files.length - 1 == i) {
              List<PropertyImageMediaInfo> mylist =
                  propertyState.propertyImagelist;
              mylist.addAll(PropertyImageMediaInfolist);

              _store.dispatch(UpdatePropertyImageList(mylist));
            }
          } else {
            ToastUtils.showCustomToast(
                context, GlobleString.PS3_Property_Image_error1, false);
            break;
          }
        }
      } else {
        int length = 10 - propertyState.propertyImagelist.length;
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_Property_Image_maximum, false);
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

  Widget saveandnext(PropertyState propertyState) {
    return InkWell(
      onTap: () {
        apiCallAndValidation(propertyState);
        //widget._callbackSaveandNext();
      },
      child: CustomeWidget.SaveAndNext(GlobleString.Save_and_next),
    );
  }

  apiCallAndValidation(PropertyState propertyState) {
    if (propertyState.Parkingstalls.isEmpty) {
      _store.dispatch(UpdateErrorParkingstalls(true));
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_Property_Features_Parkingstalls_error, false);
    } else if (propertyState.storageavailableValue == null) {
      _store.dispatch(UpdateErrorStorageavailable(true));
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_Property_Features_StorageAvailable_error, false);
    }
    /*else if (propertyState.propertyImagelist.length == 0) {
      ToastUtils.showCustomToast(context,
          GlobleString.PS3_Property_Features_image_error, false);
    }*/
    else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      List<PropertyAminityUtility> aminityutilitylist =
          <PropertyAminityUtility>[];

      for (int i = 0; i < propertyState.propertyamenitieslist.length; i++) {
        PropertyAmenitiesUtility amenitiesUtility =
            propertyState.propertyamenitieslist[i];

        PropertyAminityUtility propertyAminityUtility =
            new PropertyAminityUtility();

        propertyAminityUtility.Prop_ID = Prefs.getString(PrefsName.PropertyID);
        propertyAminityUtility.Feature_ID = amenitiesUtility.id.toString();
        propertyAminityUtility.Feature_Value =
            amenitiesUtility.value.toString();

        aminityutilitylist.add(propertyAminityUtility);
      }

      for (int i = 0; i < propertyState.propertyutilitieslist.length; i++) {
        PropertyAmenitiesUtility amenitiesUtility =
            propertyState.propertyutilitieslist[i];

        PropertyAminityUtility propertyAminityUtility =
            new PropertyAminityUtility();

        propertyAminityUtility.Prop_ID = Prefs.getString(PrefsName.PropertyID);
        propertyAminityUtility.Feature_ID = amenitiesUtility.id.toString();
        propertyAminityUtility.Feature_Value =
            amenitiesUtility.value.toString();

        aminityutilitylist.add(propertyAminityUtility);
      }

      PropertyFeature propertyFeature = new PropertyFeature();
      propertyFeature.Parking_Stalls =
          propertyState.Parkingstalls.toString().trim();
      propertyFeature.StorageAvailable =
          propertyState.storageavailableValue!.EnumDetailID.toString().trim();

      if (propertyState.PropDrafting >= 2 && propertyState.PropDrafting <= 3) {
        propertyFeature.PropDrafting = 3;
      } else {
        propertyFeature.PropDrafting = propertyState.PropDrafting;
      }

      PropertyUpdate propertyUpdate = new PropertyUpdate();
      propertyUpdate.ID = Prefs.getString(PrefsName.PropertyID);
      propertyUpdate.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      PropID propID =
          new PropID(Prop_ID: Prefs.getString(PrefsName.PropertyID));

      List<PropertyImageMediaInfo> propertyimagelist = [];

      for (int i = 0; i < propertyState.propertyImagelist.length; i++) {
        PropertyImageMediaInfo propertyImageMediaInfo =
            propertyState.propertyImagelist[i];
        if (propertyImageMediaInfo.appImage != null) {
          propertyimagelist.add(propertyImageMediaInfo);
        }
      }

      ApiManager().deleteAllAmenitiesUtilities(context, propID,
          (error, respoce) async {
        if (error) {
          ApiManager().AddPropertyFeature(
              context, aminityutilitylist, propertyUpdate, propertyFeature,
              (error, responce) async {
            if (error) {
              if (propertyimagelist.length > 0) {
                insertPropertyImageCall(
                    propertyimagelist, propertyState, propertyFeature);
              } else {
                await Prefs.setBool(PrefsName.PropertyStep3, true);
                loader.remove();
                UpdateSummeryData(propertyState);
                _store.dispatch(
                    UpdatePropertyDrafting(propertyFeature.PropDrafting!));
                _store.dispatch(UpdateSummeryPropertyDrafting(
                    propertyFeature.PropDrafting!));

                ToastUtils.showCustomToast(
                    context, GlobleString.PS_Save_Propertyse, true);

                if (!isGotoback) {
                  if (stepper == 0)
                    widget._callbackSaveandNext();
                  else
                    _store.dispatch(UpdatePropertyForm(stepper));
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

  void UpdateSummeryData(PropertyState propertyState) {
    _store.dispatch(UpdateSummeryParkingstalls(propertyState.Parkingstalls));
    _store.dispatch(UpdateSummeryStorageAvailableValue(
        propertyState.storageavailableValue));
    _store.dispatch(UpdateSummeryPropertyAmenitiesList(
        propertyState.propertyamenitieslist));
    _store.dispatch(UpdateSummeryPropertyUtilitiesList(
        propertyState.propertyutilitieslist));
  }

  insertPropertyImageCall(List<PropertyImageMediaInfo> propertyimagelist,
      PropertyState propertyState, PropertyFeature propertyFeature) {
    /* loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);*/

    ApiManager().PropertyImagesUpload(context, propertyimagelist,
        (status, listString, responce) {
      if (status) {
        if (listString.length > 0) {
          List<InsertPropertyImage> imagelist = <InsertPropertyImage>[];

          for (int i = 0; i < listString.length; i++) {
            imagelist.add(new InsertPropertyImage(
              Media_ID: listString[i],
              Property_ID: Prefs.getString(PrefsName.PropertyID),
              Owner_ID: Prefs.getString(PrefsName.OwnerID),
            ));
          }

          ApiManager().InsetPropertyImages(context, imagelist,
              (status, responce) async {
            if (status) {
              getPropertyImages(propertyState, propertyFeature);
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

  getPropertyImages(
      PropertyState propertyState, PropertyFeature propertyFeature) {
    SelectPropertyImage check = new SelectPropertyImage();
    check.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    check.Property_ID = Prefs.getString(PrefsName.PropertyID);

    ApiManager().getPropertyImages(context, check, (error, respoce) async {
      if (error) {
        await Prefs.setBool(PrefsName.PropertyStep3, true);
        loader.remove();
        UpdateSummeryData(propertyState);
        _store.dispatch(UpdatePropertyDrafting(propertyFeature.PropDrafting!));
        _store.dispatch(
            UpdateSummeryPropertyDrafting(propertyFeature.PropDrafting!));

        ToastUtils.showCustomToast(
            context, GlobleString.PS_Save_Propertyse, true);

        if (!isGotoback) {
          if (stepper == 0)
            widget._callbackSaveandNext();
          else
            _store.dispatch(UpdatePropertyForm(stepper));
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
