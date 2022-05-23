import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/actions/landlord_action/editlead_actions.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';

import '../../../presentation/models/landlord_models/editlead_state.dart';

class LeadInfoDialogBox extends StatefulWidget {
  String? applicantID = "";
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  LeadInfoDialogBox({
    required String? applicantid,
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : applicantID = applicantid,
        _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _LeadInfoDialogBoxState createState() => _LeadInfoDialogBoxState();
}

class _LeadInfoDialogBoxState extends State<LeadInfoDialogBox> {
  final FocusScopeNode _focusScopeNode = FocusScopeNode();
  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  void apimanager() async {
    await Prefs.init();

    PropertyListInDropDown propertyListInDropDown =
        new PropertyListInDropDown();
    propertyListInDropDown.IsActive = "1";
    propertyListInDropDown.Owner_ID = Prefs.getString(PrefsName.OwnerID);

    ApiManager().PropertyListInDropDownApi(context, propertyListInDropDown,
        (mylitems, error) {
      List<PropertyData> propertylist = <PropertyData>[];
      if (error) {
        propertylist = mylitems;
        _store.dispatch(UpdateEditLeadPropertyList(propertylist));
      } else {
        _store.dispatch(UpdateEditLeadPropertyList(propertylist));
      }
    });
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
            constraints: BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 350, maxHeight: 430),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: ConnectState<EditLeadState>(
                  map: (state) => state.editLeadState,
                  where: notIdentical,
                  builder: (editLeadState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.topLeft,
                              padding:
                                  EdgeInsets.only(top: 20, left: 30, right: 30),
                              child: Text(
                                GlobleString.NL_Lead_Information,
                                style: MyStyles.Medium(20, myColor.text_color),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 20, left: 30, right: 30),
                                  child: InkWell(
                                    onTap: () {
                                      widget._callbackClose();
                                    },
                                    child: Icon(Icons.clear, size: 25),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_PropertyName,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState!.propertyValue != null
                                            ? editLeadState
                                                .propertyValue!.propertyName
                                                .toString()
                                            : "",
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_dark,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_Lead_name,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.firstname! +
                                            " " +
                                            editLeadState.lastname!,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_Email,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.Email!,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_dark,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.TA_Phone_number,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.phoneNumber != null &&
                                                editLeadState
                                                    .phoneNumber!.isNotEmpty
                                            ? editLeadState.CountrydialCode! +
                                                " " +
                                                editLeadState.phoneNumber
                                                    .toString()
                                            : "",
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_Noofoccupants,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.Lead_occupant!,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_dark,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_Noofchildren,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.Lead_children!,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                color: myColor.TA_light,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        GlobleString.LeadInfo_Notes,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        editLeadState.PrivateNotes!,
                                        style: MyStyles.Regular(
                                            14, myColor.text_color),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
