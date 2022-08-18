import 'dart:html' as html;
import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/landlord_profile_actions.dart';
import 'package:silverhome/domain/actions/landlord_action/portal_actions.dart';
import 'package:silverhome/navigation/route_names.dart';
import 'package:silverhome/presentation/models/landlord_models/landlord_profile_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/widget/_network_image_web.dart';
import 'package:string_validator/string_validator.dart';

class LandlordProfileScreen extends StatefulWidget {
  @override
  _LandlordProfileScreenState createState() => _LandlordProfileScreenState();
}

class _LandlordProfileScreenState extends State<LandlordProfileScreen> {
  final _store = getIt<AppStore>();
  double ssheight = 0, sswidth = 0;

  late OverlayEntry loader;
  FocusNode _focus1 = new FocusNode();

  final _textCurrentPwd = TextEditingController();
  final _textNewPwd = TextEditingController();
  final _textConfirmPwd = TextEditingController();
  bool CpasswordVisible = true;
  bool NpasswordVisible = true;
  bool NCpasswordVisible = true;

  @override
  void initState() {
    super.initState();
    // Prevent default event handler
    html.document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  Widget build(BuildContext context) {
    ssheight = MediaQuery.of(context).size.height - 70;
    sswidth = MediaQuery.of(context).size.width - 230;

    return Container(
      height: ssheight,
      width: sswidth,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Container(
            height: ssheight,
            width: sswidth,
            decoration: BoxDecoration(
              color: myColor.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: myColor.application_boreder, width: 1),
            ),
            padding: EdgeInsets.only(top: 30, bottom: 30, left: 30, right: 30),
            child: ConnectState<LandlordProfileState>(
              map: (state) => state.profileState,
              where: notIdentical,
              builder: (profileState) {
                return SingleChildScrollView(
                  child: Container(
                    width: sswidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.LL_Profile_title,
                          style: MyStyles.SemiBold(16, myColor.black),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        companylogo(profileState!),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 800,
                          child: FocusScope(
                            node: new FocusScopeNode(),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (profileState
                                    .CustomerFeatureListingURL.isNotEmpty)
                                  customerfeaturelist(profileState),
                                Container(
                                  height: 33,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: myColor.gray,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 33,
                                        color: Colors.black12,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Text(
                                          Weburl.CustomerFeaturedPage,
                                          style: MyStyles.Medium(
                                              14, myColor.black),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          onChanged: (newValue) {
                                            _store.dispatch(
                                                UpdateLandlordProfileCustomerFeatureListingURL_update(
                                                    newValue));
                                          },
                                          initialValue: profileState
                                              .CustomerFeatureListingURL_update,
                                          keyboardType: TextInputType.text,
                                          autofocus: true,
                                          focusNode: _focus1,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp("[a-zA-Z0-9]"))
                                          ],
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: GlobleString.LL_cfl_hint,
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            contentPadding: EdgeInsets.all(12),
                                            isDense: true,
                                          ),
                                          style: MyStyles.Medium(
                                              14, myColor.text_color),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
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
                                            GlobleString.LL_Profile_Companyname,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            initialValue:
                                                profileState.companyname,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  25),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.blue,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateLandlordProfileCompanyname(
                                                      value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString
                                                .LL_Profile_Homepagelink,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            initialValue:
                                                profileState.homepagelink,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.blue,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateLandlordProfileHomepagelink(
                                                      value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Row(
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
                                            GlobleString.LL_Profile_Firstname,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            initialValue:
                                                profileState.firstname,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  25),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.blue,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateLandlordProfileFirstname(
                                                      value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            GlobleString.LL_Profile_Lastname,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            initialValue: profileState.lastname,
                                            textAlign: TextAlign.start,
                                            style: MyStyles.Regular(
                                                14, myColor.text_color),
                                            decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.blue,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: myColor.gray,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateLandlordProfileLastname(
                                                      value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                Row(
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
                                            GlobleString.LL_Profile_Email,
                                            style: MyStyles.Medium(
                                                14, myColor.black),
                                            textAlign: TextAlign.start,
                                          ),
                                          const SizedBox(height: 5.0),
                                          TextFormField(
                                            initialValue: profileState.email,
                                            textAlign: TextAlign.start,
                                            readOnly: true,
                                            style: MyStyles.Regular(
                                                14, myColor.disablecolor),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  25),
                                              /* FilteringTextInputFormatter.allow(
                                        RegExp("[a-z A-Z]")),*/
                                            ],
                                            decoration: const InputDecoration(
                                                //border: InputBorder.none,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          myColor.disablecolor,
                                                      width: 2),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color:
                                                          myColor.disablecolor,
                                                      width: 1.0),
                                                ),
                                                isDense: true,
                                                contentPadding:
                                                    EdgeInsets.all(12),
                                                fillColor: myColor.white,
                                                filled: true),
                                            onChanged: (value) {
                                              _store.dispatch(
                                                  UpdateLandlordProfileEmail(
                                                      value));
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 30.0),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                GlobleString
                                                    .LL_Profile_Phonenumber,
                                                style: MyStyles.Medium(
                                                    14, myColor.black),
                                                textAlign: TextAlign.start,
                                              ),
                                              const SizedBox(width: 10.0),
                                              Text(
                                                GlobleString.Optional,
                                                style: MyStyles.Regular(
                                                    12, myColor.optional),
                                                textAlign: TextAlign.start,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5.0),
                                          Container(
                                            height: 32,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: myColor.gray,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                CountryCodePicker(
                                                  onChanged: (value) {
                                                    _store.dispatch(
                                                        UpdateLandlordProfileCountrycode(
                                                            value.code!));
                                                    _store.dispatch(
                                                        UpdateLandlordProfileDialcode(
                                                            value.dialCode!));
                                                    //widget.newleadlist.insert(widget.pos, widget.dmodel);
                                                  },
                                                  initialSelection:
                                                      profileState.countrycode,
                                                  showFlag: true,
                                                  textStyle: MyStyles.Medium(
                                                      14, myColor.text_color),
                                                  dialogTextStyle:
                                                      MyStyles.Medium(14,
                                                          myColor.text_color),
                                                  //showDropDownButton: true,
                                                ),
                                                Expanded(
                                                  child: TextFormField(
                                                    initialValue: profileState
                                                        .phonenumber,
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    inputFormatters: [
                                                      MaskedInputFormatter(
                                                          "(000) 000 0000")
                                                    ],
                                                    decoration:
                                                        const InputDecoration(
                                                      border: InputBorder.none,
                                                      hintStyle: TextStyle(
                                                          color: Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.all(10),
                                                      isDense: true,
                                                    ),
                                                    style: MyStyles.Medium(
                                                        14, myColor.text_color),
                                                    onChanged: (value) {
                                                      _store.dispatch(
                                                          UpdateLandlordProfilePhonenumber(
                                                              value));
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        validation(profileState);
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 100,
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: myColor.Circle_main,
                                        ),
                                        child: Text(
                                          GlobleString.LL_Profile_Save,
                                          style: MyStyles.Medium(
                                              14, myColor.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        changePassword()
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customerfeaturelist(LandlordProfileState profileState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              GlobleString.LL_Profile_customerfeaturelist + " : ",
              style: MyStyles.Medium(14, myColor.black),
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 10.0),
            Listener(
              child: Text(
                Weburl.CustomerFeaturedPage +
                    profileState.CustomerFeatureListingURL,
                style: MyStyles.Medium(14, myColor.blue),
                textAlign: TextAlign.center,
              ),
              onPointerDown: (event) async {
                if (event.kind == PointerDeviceKind.mouse &&
                    event.buttons == kSecondaryMouseButton) {
                  final overlay = Overlay.of(context)!
                      .context
                      .findRenderObject() as RenderBox;
                  final menuItem = await showMenu<int>(
                      context: context,
                      items: [
                        PopupMenuItem(
                          height: 30,
                          child: Text(
                            'Copy link',
                            style: MyStyles.Regular(12, myColor.black),
                          ),
                          value: 1,
                        ),
                      ],
                      position: RelativeRect.fromSize(
                          event.position & Size(48.0, 48.0), overlay.size));
                  // Check if menu item clicked
                  switch (menuItem) {
                    case 1:
                      String url = Weburl.CustomerFeaturedPage +
                          "" +
                          profileState.CustomerFeatureListingURL;

                      Helper.copyToClipboardHack(context, url);
                      break;
                    default:
                  }
                }
              },
            ),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () async {
                String url = Weburl.CustomerFeaturedPage +
                    "" +
                    profileState.CustomerFeatureListingURL;

                print("CustomerFeaturedPage" + url);

                Helper.copyToClipboardHack(context, url);
              },
              child: Tooltip(
                message: "Click to copy link",
                child: Container(
                  decoration: BoxDecoration(
                    color: myColor.pf_available,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.copy,
                    color: myColor.black,
                    size: 17,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 5.0),
        Text(
          GlobleString.LL_Copy_title,
          style: MyStyles.Regular(13, Colors.grey),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 30.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              GlobleString.LL_Profile_tenant_portal + " : ",
              style: MyStyles.Medium(14, myColor.black),
              textAlign: TextAlign.start,
            ),
            const SizedBox(width: 10.0),
            Text(
              Weburl.CustomerFeaturedPage +
                  profileState.CustomerFeatureListingURL +
                  "/" +
                  RouteNames.Basic_Tenant_Login,
              style: MyStyles.Medium(14, myColor.blue),
              textAlign: TextAlign.center,
            ),
            const SizedBox(width: 10.0),
            InkWell(
              onTap: () async {
                String url = Weburl.CustomerFeaturedPage +
                    profileState.CustomerFeatureListingURL +
                    "/" +
                    RouteNames.Basic_Tenant_Login;

                print("CustomerFeaturedPage" + url);

                Helper.copyToClipboardHack(context, url);
              },
              child: Tooltip(
                message: "Click to copy link",
                child: Container(
                  decoration: BoxDecoration(
                    color: myColor.pf_available,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: EdgeInsets.all(7),
                  child: Icon(
                    Icons.copy,
                    color: myColor.black,
                    size: 17,
                  ),
                ),
              ),
            )
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget companylogo(LandlordProfileState profileState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              GlobleString.LL_Profile_Companylogo,
              style: MyStyles.Medium(14, myColor.black),
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
          height: 15,
        ),
        profileState.companylogo != null && profileState.companylogo!.id != null
            ? Container(
                width: 150.0,
                height: 150.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: myColor.white,
                  border: Border.all(width: 2, color: myColor.blue),
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: CustomNetworkImage(
                        Weburl.image_API +
                            profileState.companylogo!.id.toString(),
                        scale: 1,
                        headers: {
                          'Authorization':
                              'bearer ' + Prefs.getString(PrefsName.userTokan),
                          'ApplicationCode': Weburl.API_CODE,
                        }),
                  ),
                ),
              )
            : profileState.companyimage != null
                ? Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: myColor.white,
                      border: Border.all(width: 2, color: myColor.blue),
                    ),
                    child: Image.memory(
                      profileState.companyimage!,
                      fit: BoxFit.contain,
                      width: 148,
                      height: 148,
                    ),
                  )
                : Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: myColor.white,
                      border: Border.all(width: 2, color: myColor.blue),
                    ),
                    padding: EdgeInsets.all(2),
                    child: Image.asset(
                      "assets/images/imageplace.png",
                      width: 70,
                      height: 70,
                      alignment: Alignment.center,
                    ),
                  ),
        SizedBox(
          height: 15,
        ),
        InkWell(
          onTap: () {
            pickImage();
          },
          child: Container(
            height: 35,
            width: 150,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: myColor.Circle_main,
            ),
            child: Text(
              GlobleString.LL_Profile_Uploadlogo,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ),
        )
      ],
    );
  }

  Widget changePassword() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          GlobleString.BT_Change_Password,
          style: MyStyles.Medium(20, myColor.Circle_main),
          textAlign: TextAlign.center,
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
                    GlobleString.BT_old_Password,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _textCurrentPwd,
                    textAlign: TextAlign.start,
                    style: MyStyles.Regular(14, myColor.Circle_main),
                    obscureText: CpasswordVisible,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            CpasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              CpasswordVisible = !CpasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: myColor.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: myColor.disablecolor, width: 1.0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        fillColor: myColor.white,
                        filled: true),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(
          height: 10,
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
                    GlobleString.BT_new_Password,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _textNewPwd,
                    textAlign: TextAlign.start,
                    style: MyStyles.Regular(14, myColor.Circle_main),
                    obscureText: NpasswordVisible,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            NpasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              NpasswordVisible = !NpasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: myColor.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: myColor.disablecolor, width: 1.0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        fillColor: myColor.white,
                        filled: true),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(
          height: 10,
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
                    GlobleString.BT_confirm_Password,
                    style: MyStyles.Medium(14, myColor.black),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: _textConfirmPwd,
                    textAlign: TextAlign.start,
                    style: MyStyles.Regular(14, myColor.Circle_main),
                    obscureText: NCpasswordVisible,
                    decoration: InputDecoration(
                        //border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            NCpasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              NCpasswordVisible = !NCpasswordVisible;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: myColor.blue, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: myColor.disablecolor, width: 1.0),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(12),
                        fillColor: myColor.white,
                        filled: true),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 30,
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            SavePassword();
          },
          child: Container(
            height: 35,
            width: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: myColor.Circle_main,
            ),
            child: Text(
              GlobleString.BT_Submitpassword,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ),
        ),
      ],
    );
  }

  void pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );
    if (result != null) {
      PlatformFile file = result.files.first;

      if ((file.name.split('.').last).contains("jpg") ||
          (file.name.split('.').last).contains("JPG") ||
          (file.name.split('.').last).contains("png") ||
          (file.name.split('.').last).contains("PNG") ||
          (file.name.split('.').last).contains("jpeg") ||
          (file.name.split('.').last).contains("JPEG")) {
        _store.dispatch(UpdateLandlordProfileCompanylogo(null));
        _store.dispatch(UpdateLandlordProfileUint8List(file.bytes!));

        final String id = '__file_picker_web-file-input';
        var element = html.document.getElementById(id);
        if (element != null) {
          element.remove();
        }
      } else {
        ToastUtils.showCustomToast(
            context, GlobleString.PS3_Property_Image_error, false);
      }
    }
    final String id = '__file_picker_web-file-input';
    var element = html.document.getElementById(id);
    if (element != null) {
      element.remove();
    }
  }

  void validation(LandlordProfileState profileState) {
    /* if (profileState.companylogo == null && profileState.companyimage == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_clogo, false);
    } else*/

    if (profileState.CustomerFeatureListingURL_update == null ||
        profileState.CustomerFeatureListingURL_update.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_Customerfeaturelisting, false);
    } else if (profileState.companyname == null ||
        profileState.companyname.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_cname, false);
    } else if (profileState.homepagelink == null ||
        profileState.homepagelink.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_homepage, false);
    } else if (isURL(profileState.homepagelink.toString(), {
          //'protocols': ['http', 'https'],
          'require_tld': true,
          'require_protocol': false,
          'allow_underscores': false
        }) ==
        false) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_validhomepage, false);
    }

    /* if(!Uri.parse( profileState.homepagelink.toString()).isAbsolute){
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_validhomepage, false);
    }*/
    else if (profileState.firstname == null || profileState.firstname.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_firstname, false);
    } else if (profileState.lastname == null || profileState.lastname.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_lastname, false);
    } else if (profileState.email == null || profileState.email.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_email, false);
    }
    /*else if (profileState.phonenumber == null ||
        profileState.phonenumber.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_phone, false);
    } else if (Helper.ValidPhonenumber(profileState.phonenumber.toString())) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_validphone, false);
    }*/
    else if (profileState.phonenumber != null &&
        profileState.phonenumber.isNotEmpty &&
        Helper.ValidPhonenumber(profileState.phonenumber.toString())) {
      ToastUtils.showCustomToast(
          context, GlobleString.LL_Profile_error_validphone, false);
    } else {
      _addSaveAndFinishCall(profileState);
    }
  }

  _addSaveAndFinishCall(LandlordProfileState profileState) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    if (profileState.companyimage != null) {
      ApiManager().AddSingleImage(context, profileState.companyimage!,
          (status, responce) {
        if (status) {
          final String id = '__file_picker_web-file-input';
          var element = html.document.getElementById(id);
          if (element != null) {
            element.remove();
          }

          updateProfile(profileState, responce);
        } else {
          loader.remove();
          ToastUtils.showCustomToast(context, responce, false);
        }
      });
    } else {
      updateProfile(profileState, "");
    }
  }

  updateProfile(LandlordProfileState profileState, String mid) {
    PersonDataId personid = new PersonDataId();
    personid.id = profileState.PersonID;
    personid.firstName = profileState.firstname;
    personid.lastName = profileState.lastname;
    personid.email = profileState.email;
    personid.mobileNumber = profileState.phonenumber;
    personid.Country_Code = profileState.countrycode;
    personid.Dial_Code = profileState.dialcode;

    ProfileData uPojo = new ProfileData();
    uPojo.Company_logo = mid == ""
        ? profileState.companylogo != null
            ? profileState.companylogo!.id.toString()
            : ""
        : mid;
    uPojo.CompanyName = profileState.companyname;
    uPojo.CustomerFeatureListingURL =
        profileState.CustomerFeatureListingURL_update;
    uPojo.HomePageLink = profileState.homepagelink;
    uPojo.personId = personid;

    CommonID cPojo = new CommonID();
    cPojo.ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().UpdateProfileData(context, cPojo, uPojo,
        (error, respoce) async {
      if (error) {
        await Prefs.setString(PrefsName.user_Email, profileState.email);
        await Prefs.setString(PrefsName.user_fname, profileState.firstname);
        await Prefs.setString(PrefsName.user_lname, profileState.firstname);
        await Prefs.setString(PrefsName.user_CustomerFeatureListingURL,
            profileState.CustomerFeatureListingURL_update);
        await Prefs.setString(
            PrefsName.user_CompanyName, profileState.companyname);

        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.LL_Profile_success, true);
        _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
      } else {
        loader.remove();
        ToastUtils.showCustomToast(context, respoce, false);
      }
    });
  }

  void SavePassword() {
    String curpass = _textCurrentPwd.text.toString().trim();
    String newpass = _textNewPwd.text.toString().trim();
    String confirmpass = _textConfirmPwd.text.toString().trim();

    if (curpass.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.tenant_cuurent_error, false);
    } else if (newpass.isEmpty) {
      ToastUtils.showCustomToast(context, GlobleString.tenant_new_error, false);
    } else if (newpass == curpass) {
      ToastUtils.showCustomToast(
          context, GlobleString.tenant_password_same_error, false);
    } else if (!Helper.isPasswordCompliant(newpass)) {
      ToastUtils.showCustomToast(context, GlobleString.password_error, false);
    } else if (confirmpass.isEmpty) {
      ToastUtils.showCustomToast(
          context, GlobleString.tenant_newconfirm_error, false);
    } else if (newpass != confirmpass) {
      ToastUtils.showCustomToast(
          context, GlobleString.tenant_confirm_password_error, false);
    } else {
      loader = Helper.overlayLoader(context);
      Overlay.of(context)!.insert(loader);

      ApiManager().ChangePasswordAPI(
          context, Prefs.getString(PrefsName.user_Email), curpass, newpass,
          (error, respoce) {
        if (error) {
          loader.remove();
          ToastUtils.showCustomToast(
              context, GlobleString.tenant_password_success, true);
          _store.dispatch(UpdatePortalPage(1, GlobleString.NAV_Properties));
        } else {
          loader.remove();
          ToastUtils.showCustomToast(
              context, GlobleString.tenant_password_error, false);
        }
      });
    }
  }
}
