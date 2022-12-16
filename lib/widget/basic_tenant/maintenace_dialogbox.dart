import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/maintenance_action/maintenance_details_action.dart';
import 'package:silverhome/domain/entities/maintenance_vendor.dart';
import 'package:silverhome/domain/entities/property_maintenance_images.dart';
import 'package:silverhome/presentation/models/maintenance/maintenance_details_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/weburl.dart';

import '../internet/_network_image_web.dart';

typedef VoidCallEdit = void Function(String mid);

class MaintenanceRequestDialogBox extends StatefulWidget {
  final VoidCallback _callbackClose;
  final VoidCallEdit _callbackEdit;
  final bool? isShowEdit;
  final String? mID;

  MaintenanceRequestDialogBox({
    required VoidCallback onPressedClose,
    required VoidCallEdit onPressedEdit,
    bool? showEdit,
    String? mID,
  })  : _callbackClose = onPressedClose,
        _callbackEdit = onPressedEdit,
        isShowEdit = showEdit,
        mID = mID;

  @override
  _MaintenanceRequestDialogBoxState createState() => _MaintenanceRequestDialogBoxState();
}

class _MaintenanceRequestDialogBoxState extends State<MaintenanceRequestDialogBox> {
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  double width = 900;
  bool isloading = true;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();
    await clearMainatenanceDetailsState();

    if (widget.mID != null && widget.mID!.isNotEmpty) {
      ApiManager().maintenanceDetailsApi(context, widget.mID!, (status, responce) {
        if (status) {
          ApiManager().MaintenanceImagesApi(context, widget.mID!, (status, responce, maintenanceImageslist) {
            if (status) {
              _store.dispatch(UpdateMDA_maintenanceImageslist(maintenanceImageslist));
            } else {
              _store.dispatch(UpdateMDA_maintenanceImageslist([]));
            }
          });

          ApiManager().MaintenanceVendorDetailsApi(context, widget.mID!, (status, responce, maintenanceVendorlist) {
            if (status) {
              _store.dispatch(UpdateMDA_maintenanceVendorlist(maintenanceVendorlist));
            } else {
              _store.dispatch(UpdateMDA_maintenanceVendorlist([]));
            }
          });

          setState(() {
            isloading = false;
          });
        } else {
          isloading = true;
          Helper.Log("respoce", responce);
        }
      });
    }
  }

  clearMainatenanceDetailsState() {
    _store.dispatch(UpdateMDA_mID(""));
    _store.dispatch(UpdateMDA_Date_Created(""));
    _store.dispatch(UpdateMDA_IsLock(false));
    _store.dispatch(UpdateMDA_Describe_Issue(""));
    _store.dispatch(UpdateMDA_Type_User(0));
    _store.dispatch(UpdateMDA_RequestName(""));
    _store.dispatch(UpdateMDA_Priority(null));
    _store.dispatch(UpdateMDA_Status(null));
    _store.dispatch(UpdateMDA_Category(null));

    _store.dispatch(UpdateMDA_Prop_ID(""));
    _store.dispatch(UpdateMDA_PropertyName(""));
    _store.dispatch(UpdateMDA_Suite_Unit(""));
    _store.dispatch(UpdateMDA_Property_Address(""));

    _store.dispatch(UpdateMDA_Applicant_ID(""));
    _store.dispatch(UpdateMDA_Applicant_UserID(""));
    _store.dispatch(UpdateMDA_Applicant_email(""));
    _store.dispatch(UpdateMDA_Applicant_firstname(""));
    _store.dispatch(UpdateMDA_Applicant_lastname(""));
    _store.dispatch(UpdateMDA_Applicant_mobile(""));
    _store.dispatch(UpdateMDA_Applicant_dialcode("+91"));

    _store.dispatch(UpdateMDA_Owner_ID(""));
    _store.dispatch(UpdateMDA_HomePageLink(""));
    _store.dispatch(UpdateMDA_CompanyName(""));
    _store.dispatch(UpdateMDA_Owner_email(""));
    _store.dispatch(UpdateMDA_Owner_firstname(""));
    _store.dispatch(UpdateMDA_Owner_lastname(""));
    _store.dispatch(UpdateMDA_Owner_mobile(""));
    _store.dispatch(UpdateMDA_Owner_dialcode("+91"));
    _store.dispatch(UpdateMDA_Company_logo(null));

    List<MaintenanceVendor> maintenanceVendorlist = <MaintenanceVendor>[];
    List<PropertyMaintenanceImages> maintenanceImageslist = <PropertyMaintenanceImages>[];

    _store.dispatch(UpdateMDA_maintenanceImageslist(maintenanceImageslist));
    _store.dispatch(UpdateMDA_maintenanceVendorlist(maintenanceVendorlist));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 905, maxWidth: 905, minHeight: 600),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: _initialview(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _initialview() {
    return isloading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*Image.asset(
                  "assets/images/silverhome.png",
                  height: 100,
                  //width: 180,
                ),*/
                Text(
                  GlobleString.Please_Wait,
                  style: MyStyles.Medium(20, myColor.black),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator()
              ],
            ),
          )
        : ConnectState<MaintenanceDetailsState>(
            map: (state) => state.maintenanceDetailsState,
            where: notIdentical,
            builder: (mDetailsState) {
              return Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          widget._callbackClose();
                        },
                        child: Icon(Icons.clear, size: 25),
                      ),
                    ],
                  ),
                  Container(
                    //height: 526,
                    margin: EdgeInsets.only(top: 5),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            headerview(mDetailsState!),
                            Container(
                              color: myColor.white,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  propertyDetails(mDetailsState),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  maintenaceRequest(mDetailsState),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  contactDetails(mDetailsState),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  vendorDetails(mDetailsState),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          widget._callbackClose();
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          padding: EdgeInsets.only(left: 25, right: 25),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(5)),
                                            border: Border.all(color: myColor.Circle_main, width: 1),
                                            color: myColor.white,
                                          ),
                                          child: Text(
                                            GlobleString.Mant_DL_Cancel,
                                            style: MyStyles.Medium(12, myColor.Circle_main),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );
  }

  Widget headerview(MaintenanceDetailsState mDetailsState) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        //border: Border.all(color: myColor.CM_Lead_border, width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
        color: myColor.mant_header,
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: mDetailsState.Company_logo != null && mDetailsState.Company_logo!.id != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Container(
                          alignment: Alignment.topLeft,
                          height: 80,
                          decoration: new BoxDecoration(
                            shape: BoxShape.rectangle,
                            image: new DecorationImage(
                              alignment: Alignment.topLeft,
                              fit: BoxFit.contain,
                              image: CustomNetworkImage(
                                Weburl.image_API + mDetailsState.Company_logo!.id.toString(),
                                scale: 1.5,
                                headers: {
                                  'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
                                  'ApplicationCode': Weburl.API_CODE,
                                },
                              ),
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              Helper.urlload(mDetailsState.HomePageLink);
                            },
                            hoverColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                        ),
                      )
                    ],
                  )
                : Image.asset(
                    "assets/images/silverhome.png",
                    width: 250,
                    height: 50,
                    alignment: Alignment.topLeft,
                  ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    GlobleString.Mant_view_MaintenanceRequest,
                    style: MyStyles.Medium(20, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    mDetailsState.RequestName,
                    style: MyStyles.Medium(20, myColor.black),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              GlobleString.Mant_view_Status,
                              style: MyStyles.Medium(12, myColor.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: myColor.TA_Border, width: 1),
                              color: myColor.white,
                            ),
                            child: Text(
                              mDetailsState.Status != null ? mDetailsState.Status!.displayValue : "",
                              style: MyStyles.Medium(12, myColor.black),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 30,
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(
                              GlobleString.Mant_view_Priority,
                              style: MyStyles.Medium(12, myColor.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 30,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: myColor.Status_border, width: 1),
                              color: myColor.Status_bg,
                            ),
                            child: Text(
                              mDetailsState.Priority != null ? mDetailsState.Priority!.displayValue : "",
                              style: MyStyles.Medium(12, myColor.Status_border),
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyDetails(MaintenanceDetailsState mDetailsState) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: myColor.mant_Property,
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  GlobleString.Mant_view_PropertyDetails,
                  style: MyStyles.SemiBold(17, myColor.black),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  GlobleString.Mant_view_PropertyName +
                      " " +
                      mDetailsState.PropertyName +
                      "" +
                      (mDetailsState.Suite_Unit.isNotEmpty ? " - " + mDetailsState.Suite_Unit : ""),
                  style: MyStyles.Medium(14, myColor.black),
                  textAlign: TextAlign.start,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  GlobleString.Mant_view_Address + " " + mDetailsState.Property_Address,
                  style: MyStyles.Medium(14, myColor.black),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
          if (widget.isShowEdit != null && widget.isShowEdit!)
            InkWell(
              onTap: () {
                widget._callbackEdit(mDetailsState.mID);
              },
              child: Tooltip(
                message: "Edit",
                child: Container(
                  width: 23,
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset(
                    "assets/images/ic_edit.png",
                    /* width: 23,
                                            height: 23,*/
                    color: Colors.black,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget maintenaceRequest(MaintenanceDetailsState mDetailsState) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: myColor.CM_Lead_border, width: 1.0),
        borderRadius: BorderRadius.all(
          Radius.circular(0.0),
        ),
        color: myColor.white,
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            GlobleString.Mant_view_MaintenanceRequestInformation,
            style: MyStyles.SemiBold(17, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            GlobleString.Mant_view_RequestName + " " + mDetailsState.RequestName,
            style: MyStyles.Medium(14, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            GlobleString.Mant_view_Category + " " + (mDetailsState.Category != null ? mDetailsState.Category!.displayValue : ""),
            style: MyStyles.Medium(14, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            GlobleString.Mant_view_Describetheissue,
            style: MyStyles.Medium(14, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            mDetailsState.Describe_Issue,
            style: MyStyles.Regular(13, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            GlobleString.Mant_view_FilesUploaded,
            style: MyStyles.Medium(14, myColor.black),
            textAlign: TextAlign.start,
          ),
          SizedBox(
            height: 15,
          ),
          ListView.builder(
            itemCount: mDetailsState.maintenanceImageslist.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              PropertyMaintenanceImages maintenanceimage = mDetailsState.maintenanceImageslist[index];

              return Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (maintenanceimage.mediaId != null &&
                            maintenanceimage.mediaId!.url != null &&
                            maintenanceimage.mediaId!.url != "") {
                          await Helper.launchURL(maintenanceimage.mediaId!.url!);
                        }
                      },
                      child: Container(
                        width: 400,
                        child: Text(
                          maintenanceimage.mediaId != null ? Helper.FileName(maintenanceimage.mediaId!.url!) : "",
                          style: MyStyles.Regular(13, myColor.blue1),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        if (maintenanceimage.mediaId != null &&
                            maintenanceimage.mediaId!.url != null &&
                            maintenanceimage.mediaId!.url != "") {
                          await Helper.download(context, maintenanceimage.mediaId!.toString(), maintenanceimage.mediaId!.id.toString(),
                              Helper.FileNameWithTime(maintenanceimage.mediaId!.url!), 1);
                        }
                      },
                      child: Container(
                        height: 25,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(color: myColor.black, width: 1),
                          color: myColor.white,
                        ),
                        child: Text(
                          GlobleString.Mant_view_Download,
                          style: MyStyles.Regular(12, myColor.black),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget contactDetails(MaintenanceDetailsState mDetailsState) {
    return IntrinsicHeight(
      child: Container(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  /* border: Border.all(
                                              color: myColor.CM_Lead_border,
                                              width: 1.0),*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                  color: myColor.mant_Landlord,
                ),
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      GlobleString.Mant_view_LandlordContactDetails,
                      style: MyStyles.SemiBold(17, myColor.black),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      GlobleString.Mant_view_FullName + " " + mDetailsState.Owner_firstname + " " + mDetailsState.Owner_lastname,
                      style: MyStyles.Medium(14, myColor.black),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      GlobleString.Mant_view_Email + " " + mDetailsState.Owner_email,
                      style: MyStyles.Medium(14, myColor.black),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      GlobleString.Mant_view_Phone + " " + mDetailsState.Owner_mobile,
                      style: MyStyles.Medium(14, myColor.black),
                      textAlign: TextAlign.start,
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
                height: double.infinity,
                decoration: BoxDecoration(
                  /* border: Border.all(
                                              color: myColor.CM_Lead_border,
                                              width: 1.0),*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                  color: myColor.mant_Tenant,
                ),
                padding: EdgeInsets.all(15),
                child: mDetailsState.Applicant_ID != ""
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            GlobleString.Mant_view_TenantContactDetails,
                            style: MyStyles.SemiBold(17, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            GlobleString.Mant_view_FullName +
                                " " +
                                mDetailsState.Applicant_firstname +
                                " " +
                                mDetailsState.Applicant_lastname,
                            style: MyStyles.Medium(14, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            GlobleString.Mant_view_Email + " " + mDetailsState.Applicant_email,
                            style: MyStyles.Medium(14, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            GlobleString.Mant_view_Phone + " " + mDetailsState.Applicant_mobile,
                            style: MyStyles.Medium(14, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            GlobleString.Maintenance_property_vacant,
                            style: MyStyles.SemiBold(17, myColor.black),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget vendorDetails(MaintenanceDetailsState mDetailsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          GlobleString.Mant_view_VendorDetails,
          style: MyStyles.SemiBold(17, myColor.black),
          textAlign: TextAlign.start,
        ),
        SizedBox(
          height: 15,
        ),
        mDetailsState.maintenanceVendorlist.length > 0
            ? ListView.builder(
                itemCount: mDetailsState.maintenanceVendorlist.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  MaintenanceVendor vendordata = mDetailsState.maintenanceVendorlist[index];
                  return Container(
                    width: 900,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 0.5,
                          color: myColor.CM_Lead_border,
                        ),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width / 5,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vendordata.companyName!,
                                  textAlign: TextAlign.center,
                                  style: MyStyles.SemiBold(12, myColor.Circle_main),
                                ),
                              ),
                              Container(
                                width: width / 7,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vendordata.category != null ? vendordata.category!.displayValue : "",
                                  textAlign: TextAlign.center,
                                  style: MyStyles.SemiBold(12, myColor.Circle_main),
                                ),
                              ),
                              Container(
                                width: width / 4,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vendordata.email!,
                                  textAlign: TextAlign.center,
                                  style: MyStyles.SemiBold(12, myColor.Circle_main),
                                ),
                              ),
                              Container(
                                width: width / 7,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  vendordata.mobileNumber!,
                                  textAlign: TextAlign.center,
                                  style: MyStyles.SemiBold(12, myColor.Circle_main),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (vendordata.showInstruction!) {
                                          mDetailsState.maintenanceVendorlist[index].showInstruction = false;
                                          _store.dispatch(UpdateMDA_maintenanceVendorlist(mDetailsState.maintenanceVendorlist));
                                        } else {
                                          mDetailsState.maintenanceVendorlist[index].showInstruction = true;
                                          _store.dispatch(UpdateMDA_maintenanceVendorlist(mDetailsState.maintenanceVendorlist));
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 140,
                                        margin: EdgeInsets.only(left: 20),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: myColor.Circle_main, width: 1.0),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          color: vendordata.showInstruction! ? myColor.Circle_main : myColor.white,
                                        ),
                                        child: Text(
                                          vendordata.showInstruction!
                                              ? GlobleString.Mant_view_HideInstructions
                                              : GlobleString.Mant_view_ViewInstructions,
                                          textAlign: TextAlign.center,
                                          style: MyStyles.Medium(12, vendordata.showInstruction! ? myColor.white : myColor.Circle_main),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        if (vendordata.showInstruction!)
                          Container(
                            width: width,
                            decoration: BoxDecoration(
                              /* border: Border.all(
                                          color: myColor.CM_Lead_border,
                                          width: 1.0),*/
                              borderRadius: BorderRadius.all(
                                Radius.circular(0.0),
                              ),
                              color: myColor.mant_Property,
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  GlobleString.Mant_view_Instructions,
                                  textAlign: TextAlign.start,
                                  style: MyStyles.SemiBold(12, myColor.Circle_main),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  vendordata.Instruction!,
                                  textAlign: TextAlign.start,
                                  style: MyStyles.Regular(13, myColor.Circle_main),
                                ),
                              ],
                            ),
                          ),
                        if ((mDetailsState.maintenanceVendorlist.length - 1) < index)
                          Container(
                            height: 0.5,
                            color: myColor.CM_Lead_border,
                          )
                        else
                          Container(
                            height: 0.5,
                            color: Colors.transparent,
                          )
                      ],
                    ),
                  );
                },
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    GlobleString.No_Vendors_Assigned_Msg,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ],
    );
  }
}
