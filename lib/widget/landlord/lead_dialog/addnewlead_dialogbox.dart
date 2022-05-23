import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/newlead_actions.dart';
import 'package:silverhome/domain/entities/emailcheck.dart';
import 'package:silverhome/domain/entities/newlead.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/landlord_models/newlead_state.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/store/utils.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/widget/alert_dialogbox.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

import 'addnewleadwidget.dart';

class AddNewLeadDialogBox extends StatefulWidget {
  final VoidCallback _callbackSave;
  final VoidCallback _callbackClose;

  AddNewLeadDialogBox({
    required VoidCallback onPressedSave,
    required VoidCallback onPressedClose,
  })  : _callbackSave = onPressedSave,
        _callbackClose = onPressedClose;

  @override
  _AddNewLeadDialogBoxState createState() => _AddNewLeadDialogBoxState();
}

class _AddNewLeadDialogBoxState extends State<AddNewLeadDialogBox> {
  static List<NewLead> newleadlist = [];

  late OverlayEntry loader;
  final _store = getIt<AppStore>();

  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
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
        _store.dispatch(UpdateNewLeadPropertyList(propertylist));
      } else {
        _store.dispatch(UpdateNewLeadPropertyList(propertylist));
      }

      _store.dispatch(UpdateNewLeadProperty(null));
    });

    newleadlist.clear();
    NewLead newLead = new NewLead();
    newLead.id = 0;
    newLead.CountryCode = "CA";
    newLead.CountrydialCode = "+1";
    newleadlist.add(newLead);

    _store.dispatch(UpdateNewLeadNewLeadList(newleadlist));
  }

  @override
  Widget build(BuildContext context) {
    /* return StatefulBuilder(builder: (context, setState) {

    });*/

    return Align(
      alignment: Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: 700, maxWidth: 700, minHeight: 550, maxHeight: 550),
            //maxHeight: newleadlist.length > 1 ? 1000 : 550),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              child: ConnectState<NewLeadState>(
                  map: (state) => state.newLeadState,
                  where: notIdentical,
                  builder: (newleadstate) {
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
                                      closevalidation(newleadstate!);
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      GlobleString.NL_Select_property,
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 30,
                                      // ignore: missing_required_param
                                      child: DropdownSearch<PropertyData>(
                                        key: UniqueKey(),
                                        mode: Mode.MENU,
                                        focuscolor: myColor.blue,
                                        focusWidth: 2,
                                        defultHeight:
                                            newleadstate!.propertylist.length >
                                                    5
                                                ? 300
                                                : (newleadstate.propertylist
                                                            .length *
                                                        35) +
                                                    50,
                                        textstyle: MyStyles.Medium(
                                            12, myColor.text_color),
                                        items: newleadstate.propertylist,
                                        itemAsString: (PropertyData? u) =>
                                            u!.propertyName!,
                                        hint: GlobleString.Select_Property,
                                        showSearchBox: true,
                                        selectedItem:
                                            newleadstate.propertyValue != null
                                                ? newleadstate.propertyValue
                                                : null,
                                        isFilteredOnline: true,
                                        onChanged: (data) {
                                          _store.dispatch(
                                              UpdateNewLeadProperty(data));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: ListView.builder(
                                key: UniqueKey(),
                                shrinkWrap: true,
                                itemCount: newleadstate.newleadlist.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return AddNewLeadWidget(
                                    newleadlist1: newleadstate.newleadlist,
                                    dmodel1: newleadstate.newleadlist[index],
                                    pos: index,
                                    count: newleadstate.newleadlist.length,
                                    onPressedDelete: (int pos) {
                                      removeLeadAlert(pos, newleadstate);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          child: InkWell(
                            onTap: () {
                              addNewLeadValidation(newleadstate);
                            },
                            child: Container(
                              height: 32,
                              //padding: EdgeInsets.only(left: 15, right: 15),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: myColor.Circle_main,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    GlobleString.NL_Add_New_Lead,
                                    style: MyStyles.Regular(
                                        14, myColor.Circle_main),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.only(bottom: 20, left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  checkValidation(context, newleadstate);
                                },
                                child: Container(
                                  height: 35,
                                  padding: EdgeInsets.only(left: 25, right: 25),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    color: myColor.Circle_main,
                                  ),
                                  child: Text(
                                    GlobleString.NL_SAVE,
                                    style: MyStyles.Medium(14, myColor.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  closevalidation(NewLeadState newleadstate) {
    bool isAdd = false;

    for (int i = 0; i < newleadstate.newleadlist.length; i++) {
      NewLead lead = newleadstate.newleadlist[i];

      if (lead.firstname != null && lead.firstname!.isNotEmpty) {
        isAdd = true;
      } else if (lead.lastname != null && lead.lastname!.isNotEmpty) {
        isAdd = true;
      } else if (lead.Email != null && lead.Email!.isNotEmpty) {
        isAdd = true;
      } else if (lead.phoneNumber != null && lead.phoneNumber!.isNotEmpty) {
        isAdd = true;
      }

      if ((newleadstate.newleadlist.length - 1) == i && isAdd) {
        showDialog(
          context: context,
          barrierColor: Colors.black45,
          useSafeArea: true,
          barrierDismissible: false,
          builder: (BuildContext context1) {
            return AlertDialogBox(
              title: GlobleString.NL_Lead_close_msg,
              positiveText: GlobleString.NL_Lead_close_yes,
              negativeText: GlobleString.NL_Lead_close_NO,
              onPressedYes: () {
                Navigator.of(context1).pop();
              },
              onPressedNo: () {
                Navigator.of(context1).pop();
                widget._callbackClose();
              },
            );
          },
        );
      } else if ((newleadstate.newleadlist.length - 1) == i && !isAdd) {
        widget._callbackClose();
      }
    }
  }

  removeLeadAlert(int pos, NewLeadState newleadstate) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialogBox(
          title: GlobleString.NL_Lead_delete_msg,
          positiveText: GlobleString.VDH_delete_yes,
          negativeText: GlobleString.VDH_delete_cancel,
          onPressedYes: () {
            Navigator.of(context1).pop();

            newleadstate.newleadlist.removeAt(pos);
            _store.dispatch(UpdateNewLeadNewLeadList(newleadstate.newleadlist));
          },
          onPressedNo: () {
            Navigator.of(context1).pop();
          },
        );
      },
    );
  }

  addNewLeadValidation(NewLeadState newleadstate) {
    bool isAdd = false;

    for (int i = 0; i < newleadstate.newleadlist.length; i++) {
      NewLead lead = newleadstate.newleadlist[i];

      if (lead.firstname == null || lead.firstname!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_First_name, false);
        break;
      } else if (lead.lastname == null || lead.lastname!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_Last_name, false);
        break;
      } else if (lead.Email == null || lead.Email!.isEmpty) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_Enter_email, false);
        break;
      } else if (Helper.ValidEmail(lead.Email!.trim().toString()) != true) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_valid_email, false);
        break;
      } else if (lead.phoneNumber != null &&
          lead.phoneNumber!.isNotEmpty &&
          lead.phoneNumber!.length < 10) {
        isAdd = true;
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_valid_phone, false);
        break;
      } else {
        if ((newleadstate.newleadlist.length - 1) == i && !isAdd) {
          NewLead newLead = new NewLead();
          newLead.id = newleadstate.newleadlist.length;
          newLead.CountryCode = "CA";
          newLead.CountrydialCode = "+1";
          newleadstate.newleadlist.add(newLead);

          _store.dispatch(UpdateNewLeadNewLeadList(newleadstate.newleadlist));

          Helper.Log("Length", newleadstate.newleadlist.length.toString());
          startTime(newleadstate.newleadlist.length);

          break;
        }
      }
    }
  }

  startTime(int pos) {
    new Timer(Duration(seconds: 4), _scrollToIndex(pos));
  }

  _scrollToIndex(int pos) {
    double index = 350.00 * pos;

    setState(() {
      _scrollController.animateTo(index,
          duration: const Duration(seconds: 2), curve: Curves.ease);
    });

    //_store.dispatch(UpdateNewLeadisreferesh(""));
  }

  checkValidation(BuildContext context, NewLeadState newleadstate) {
    if (newleadstate.propertyValue == null) {
      ToastUtils.showCustomToast(
          context, GlobleString.NL_error_Select_property, false);
    } else {
      List<AddLead> applicantIdlist = <AddLead>[];
      List<String> emaillist = <String>[];

      bool isAdd = false;
      for (int i = 0; i < newleadstate.newleadlist.length; i++) {
        NewLead lead = newleadstate.newleadlist[i];

        if (lead.firstname == null || lead.firstname!.isEmpty) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.NL_error_First_name, false);
          break;
        } else if (lead.lastname == null || lead.lastname!.isEmpty) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.NL_error_Last_name, false);
          break;
        } else if (lead.Email == null || lead.Email!.isEmpty) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.NL_error_Enter_email, false);
          break;
        } else if (Helper.ValidEmail(lead.Email!.trim().toString()) != true) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.NL_error_valid_email, false);
          break;
        } else if (lead.phoneNumber != null &&
            lead.phoneNumber!.isNotEmpty &&
            lead.phoneNumber!.length < 10) {
          isAdd = true;
          ToastUtils.showCustomToast(
              context, GlobleString.NL_error_valid_phone, false);
          break;
        } else {
          emaillist.add(lead.Email.toString());

          PersonId personid = new PersonId();
          personid.firstName = lead.firstname;
          personid.lastName = lead.lastname;
          personid.email = lead.Email;
          personid.mobileNumber = lead.phoneNumber;
          personid.Country_Code = lead.CountryCode;
          personid.Dial_Code = lead.CountrydialCode;

          ApplicantId applicationid = new ApplicantId();
          applicationid.note = lead.PrivateNotes;
          applicationid.personId = personid;

          AddLead addlead = new AddLead();
          addlead.propId = newleadstate.propertyValue!.ID.toString();
          addlead.applicationStatus = "1";
          addlead.docReviewStatus = "2";
          addlead.referenceStatus = null;
          addlead.leaseStatus = "2";
          addlead.applicantId = applicationid;
          addlead.Owner_ID = Prefs.getString(PrefsName.OwnerID);

          applicantIdlist.add(addlead);
        }

        if ((newleadstate.newleadlist.length - 1) == i && !isAdd) {
          String emaildata = emaillist.join(',');

          checkEmail(newleadstate, emaildata, applicantIdlist);
          //
        }
      }
    }
  }

  checkEmail(NewLeadState newleadstate, String emaildata,
      List<AddLead> applicantIdlist) {
    loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    ApiManager().checkEmailAddressExit(
        context, newleadstate.propertyValue!.ID.toString(), emaildata,
        (status, responce, emaillist) {
      if (status) {
        //loader.remove();
        leadcall(applicantIdlist);
      } else {
        loader.remove();
        if (responce == "1") {
          /* ToastUtils.showCustomToast(
              context, GlobleString.CSM_Lead_already_Email_new, false);*/

          errorDialog(emaillist);
        } else {
          ToastUtils.showCustomToast(context, responce, false);
        }
      }
    });
  }

  errorDialog(List<EmailExit> emaillist) {
    showDialog(
      barrierColor: Colors.black26,
      context: context,
      useSafeArea: true,
      builder: (BuildContext context1) {
        return StatefulBuilder(builder: (context1, setState) {
          return Align(
            alignment: Alignment(0, 0),
            child: Material(
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 500,
                    maxWidth: 500,
                    minHeight: 450,
                    maxHeight: 450,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.0),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        color: Colors.white),
                    padding: EdgeInsets.only(
                        top: 20, bottom: 10, left: 20, right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobleString.Lead_email_title,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: MyStyles.SemiBold(20, myColor.text_color),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            GlobleString.Lead_email_subtitle,
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: MyStyles.Medium(14, myColor.text_color),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 40,
                          color: myColor.Circle_main,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 40,
                                width: 70,
                                padding: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "No.",
                                  textAlign: TextAlign.center,
                                  style: MyStyles.Medium(13, myColor.white),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 35,
                                  padding: EdgeInsets.only(left: 10),
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Email",
                                    textAlign: TextAlign.start,
                                    style: MyStyles.Medium(13, myColor.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          height: 200,
                          child: ListView.separated(
                              key: UniqueKey(),
                              itemCount: emaillist.length,
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.black12,
                                    thickness: 1,
                                    height: 1,
                                  ),
                              itemBuilder: (BuildContext context, int index) {
                                EmailExit error = emaillist[index];

                                int count = index + 1;
                                return Container(
                                  color: count % 2 == 0
                                      ? Colors.white
                                      : myColor.embg,
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 35,
                                        width: 75,
                                        //color: Colors.white,
                                        padding: EdgeInsets.only(left: 15),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          count.toString(),
                                          textAlign: TextAlign.center,
                                          style: MyStyles.Medium(
                                              13, myColor.text_color),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 35,
                                          padding: EdgeInsets.only(left: 10),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            error.email.toString(),
                                            textAlign: TextAlign.start,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            softWrap: false,
                                            style: MyStyles.Medium(
                                                13, Colors.redAccent),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.of(context1).pop();
                              },
                              child: Container(
                                height: 35,
                                width: 90,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: myColor.Circle_main,
                                  border: Border.all(
                                      color: myColor.Circle_main, width: 1),
                                ),
                                child: Text(
                                  GlobleString.Lead_email_OK,
                                  style: MyStyles.Medium(14, myColor.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  leadcall(List<AddLead> applicantIdlist) {
    ApiManager().InsetNewLeadAPI(context, applicantIdlist, (error, respoce) {
      if (error) {
        ToastUtils.showCustomToast(context, GlobleString.NL_Lead_Success, true);
        loader.remove();
        _store.dispatch(UpdateNewLeadProperty(null));
        widget._callbackSave();
      } else {
        loader.remove();
        ToastUtils.showCustomToast(
            context, GlobleString.NL_error_insertcall, false);
      }
    });
  }
}
