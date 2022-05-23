import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/actions/landlord_action/tenancyfilter_actions.dart';
import 'package:silverhome/domain/entities/filter_item.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/presentation/models/landlord_models/tenantsfilter_state.dart';
import 'package:silverhome/store/connect_state.dart';
import 'package:silverhome/store/store.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/query_pojo.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';

typedef VoidCallbackFilter = void Function(String json, bool isclear);

class FilterView extends StatefulWidget {
  final VoidCallback _callbackclose;
  final VoidCallbackFilter _callbackApply;
  PropertyData? selectpropertyValue;
  bool isfunnel;

  FilterView({
    PropertyData? propertyValue,
    required VoidCallbackFilter onApply,
    required VoidCallback onclose,
    required bool isfunnelview,
  })  : selectpropertyValue = propertyValue,
        _callbackApply = onApply,
        _callbackclose = onclose,
        isfunnel = isfunnelview;

  @override
  _FilterViewState createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final _store = getIt<AppStore>();

  static List<SystemEnumDetails> empstatuslist = [];
  static List<SystemEnumDetails> anualincomelist = [];
  static List<SystemEnumDetails> applicationStatuslist = [];
  List<FilterPropertyItem> propertyitemslist1 = [];
  List<FilterCityItem> cityitemslist1 = [];

  bool isloading = false;

  @override
  void initState() {
    apimanager();
    super.initState();
  }

  apimanager() async {
    await Prefs.init();

    if (!Prefs.getBool(PrefsName.IsApplyFilterList) &&
        !Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
      updateLoading(true);

      empstatuslist.clear();
      anualincomelist.clear();
      empstatuslist =
          QueryFilter().PlainValues(eSystemEnums().EmploymentStatus);
      anualincomelist =
          QueryFilter().PlainValues(eSystemEnums().AnnualIncomeStatus);
      applicationStatuslist =
          QueryFilter().PlainValues(eSystemEnums().ApplicationStatus);

      OwnerActiveProperty property = new OwnerActiveProperty();
      property.IsActive = true;
      property.Owner_ID = Prefs.getString(PrefsName.OwnerID);

      await ApiManager().getActivePropertyData(context, property,
          (status, responce, propertylist) {
        if (status) {
          propertyitemslist1 = propertylist;

          OwnerCityProperty city = new OwnerCityProperty();
          city.Owner_ID = Prefs.getString(PrefsName.OwnerID);

          ApiManager().getCityinProperty(context, city,
              (status, responce, citylist) async {
            if (status) {
              cityitemslist1 = citylist;

              if (!Prefs.getBool(PrefsName.IsApplyFilterList) &&
                  !Prefs.getBool(PrefsName.IsApplyFilterFunnel)) {
                await _initializefilterData(false);
              }

              updateLoading(false);
            } else {
              ToastUtils.showCustomToast(
                  context, GlobleString.login_error, false);
            }
          });
        } else {
          ToastUtils.showCustomToast(context, GlobleString.login_error, false);
          Helper.Log("respoce", responce);
        }
      });
    }
  }

  updateLoading(bool val) {
    setState(() {
      isloading = val;
    });
  }

  _initializefilterData(bool check) {
    List<FilterPropertyItem> propertyitemslist = [];
    List<FilterCityItem> cityitemslist = [];
    List<FilterRatingItem> ratingitemslist = [];
    List<FilterApplicationReceived> applicationReceivedtemslist = [];
    List<SystemEnumDetails> appStatuslist = [];
    List<SystemEnumDetails> employmentStatusitemslist = [];
    List<SystemEnumDetails> annualIncomeitemslist = [];
    List<FilterNumberOfOccupants> numberofoccupantitemslist = [];
    List<FilterPets> petsitemslist = [];
    List<FilterSmoking> smokingitemslist = [];
    List<FilterVehical> vehicalitemslist = [];

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var i = 0; i < propertyitemslist1.length; i++) {
      FilterPropertyItem propertyItem = propertyitemslist1[i];
      propertyItem.isSelected = check;
      propertyitemslist.add(propertyItem);
    }

    for (var i = 0; i < cityitemslist1.length; i++) {
      FilterCityItem cityItem = cityitemslist1[i];
      cityItem.isSelected = check;
      cityitemslist.add(cityItem);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var j = 0; j < 6; j++) {
      FilterRatingItem ratingItem = new FilterRatingItem();
      ratingItem.rating = (5 - j);
      ratingItem.ratingvalue = (5 - j);
      ratingItem.isSelected = check;
      ratingitemslist.add(ratingItem);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var k = 0; k < empstatuslist.length; k++) {
      SystemEnumDetails systemEnumDetails = empstatuslist[k];
      systemEnumDetails.ischeck = check;
      employmentStatusitemslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var m = 0; m < anualincomelist.length; m++) {
      SystemEnumDetails systemEnumDetails = anualincomelist[m];
      systemEnumDetails.ischeck = check;
      annualIncomeitemslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var a = 1; a < 6; a++) {
      FilterNumberOfOccupants numberOfOccupants1 =
          new FilterNumberOfOccupants();
      if (a == 5) {
        numberOfOccupants1.noName = a.toString() + "+";
      } else {
        numberOfOccupants1.noName = a.toString();
      }
      numberOfOccupants1.noValue = a.toString();
      numberOfOccupants1.isSelected = check;
      numberofoccupantitemslist.add(numberOfOccupants1);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var k = 0; k < applicationStatuslist.length; k++) {
      SystemEnumDetails systemEnumDetails = applicationStatuslist[k];
      systemEnumDetails.ischeck = check;
      appStatuslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterApplicationReceived applicationReceived =
        new FilterApplicationReceived();
    applicationReceived.apprecId = "1";
    applicationReceived.apprecName = "Received";
    applicationReceived.isSelected = check;
    applicationReceivedtemslist.add(applicationReceived);

    FilterApplicationReceived applicationReceived1 =
        new FilterApplicationReceived();
    applicationReceived1.apprecId = "0";
    applicationReceived1.apprecName = "Not received";
    applicationReceived1.isSelected = check;
    applicationReceivedtemslist.add(applicationReceived1);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterPets pets1 = new FilterPets();
    pets1.petsValue = true;
    pets1.petsName = "Yes";
    pets1.isSelected = check;
    petsitemslist.add(pets1);

    FilterPets pets2 = new FilterPets();
    pets2.petsValue = false;
    pets2.petsName = "No";
    pets2.isSelected = check;
    petsitemslist.add(pets2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterSmoking smoking1 = new FilterSmoking();
    smoking1.smokingValue = true;
    smoking1.smokingName = "Yes";
    smoking1.isSelected = check;
    smokingitemslist.add(smoking1);

    FilterSmoking smoking2 = new FilterSmoking();
    smoking2.smokingValue = false;
    smoking2.smokingName = "No";
    smoking2.isSelected = check;
    smokingitemslist.add(smoking2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterVehical vehical1 = new FilterVehical();
    vehical1.vehicalValue = true;
    vehical1.vehicalName = "Yes";
    vehical1.isSelected = check;
    vehicalitemslist.add(vehical1);

    FilterVehical vehical2 = new FilterVehical();
    vehical2.vehicalValue = false;
    vehical2.vehicalName = "No";
    vehical2.isSelected = check;
    vehicalitemslist.add(vehical2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    _store.dispatch(UpdateFilterProperty(propertyitemslist));
    _store.dispatch(UpdateFilterCity(cityitemslist));
    _store.dispatch(UpdateFilterRating(ratingitemslist));
    _store
        .dispatch(UpdateFilterApplicationReceived(applicationReceivedtemslist));
    _store.dispatch(UpdateFilterStatus(appStatuslist));
    _store.dispatch(UpdateFilterEmploymentStatus(employmentStatusitemslist));
    _store.dispatch(UpdateFilterAnnualIncome(annualIncomeitemslist));
    _store.dispatch(UpdateFilterNumberOfOccupants(numberofoccupantitemslist));
    _store.dispatch(UpdateFilterPets(petsitemslist));
    _store.dispatch(UpdateFilterSmoking(smokingitemslist));
    _store.dispatch(UpdateFilterVehical(vehicalitemslist));

    _store.dispatch(UpdateFilterisExpandProperties(false));
    _store.dispatch(UpdateFilterisExpandCity(false));
    _store.dispatch(UpdateFilterisExpandRating(false));
    _store.dispatch(UpdateFilterisExpandApplicationReceived(false));
    _store.dispatch(UpdateFilterisExpandStatus(false));
    _store.dispatch(UpdateFilterisExpandEmploymentStatus(false));
    _store.dispatch(UpdateFilterisExpandAnnualincome(false));
    _store.dispatch(UpdateFilterisExpandNumberOfOccupation(false));
    _store.dispatch(UpdateFilterisExpandPets(false));
    _store.dispatch(UpdateFilterisExpandSmoking(false));
    _store.dispatch(UpdateFilterisExpandVehical(false));
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15),
        child: isloading
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
                    CircularProgressIndicator()
                  ],
                ),
              )
            : Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        //margin: EdgeInsets.only(top: 30.0),
                        child: Text(
                          GlobleString.Fl_title,
                          style: MyStyles.Medium(18, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              widget._callbackclose();
                            },
                            child: Icon(Icons.clear, size: 25),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height - 85,
                    child: SingleChildScrollView(
                      child: Container(
                        width: 370,
                        child: ConnectState<TenantFilterState>(
                            map: (state) => state.tenantFilterState,
                            where: notIdentical,
                            builder: (tenantFilterState) {
                              return Column(
                                children: [
                                  selectallANDclearbutton(tenantFilterState!),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  if (!widget.isfunnel)
                                    propertyfilter(tenantFilterState),
                                  if (!widget.isfunnel)
                                    SizedBox(
                                      height: 20,
                                    ),
                                  if (!widget.isfunnel)
                                    cityfilter(tenantFilterState),
                                  if (!widget.isfunnel)
                                    SizedBox(
                                      height: 20,
                                    ),
                                  Ratingfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ApplicationReceivedfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Statusfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  EmploymentStatusfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AnnualIncomefilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  NumberofOccupantsfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Petsfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Smokingfilter(tenantFilterState),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Vehicalfilter(tenantFilterState),
                                  SizedBox(
                                    height: 40,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  selectallANDclearbutton(TenantFilterState filterState) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            _store.dispatch(UpdateFilterisExpandProperties(true));
            _store.dispatch(UpdateFilterisExpandCity(true));
            _store.dispatch(UpdateFilterisExpandRating(true));
            _store.dispatch(UpdateFilterisExpandApplicationReceived(true));
            _store.dispatch(UpdateFilterisExpandStatus(true));
            _store.dispatch(UpdateFilterisExpandEmploymentStatus(true));
            _store.dispatch(UpdateFilterisExpandAnnualincome(true));
            _store.dispatch(UpdateFilterisExpandNumberOfOccupation(true));
            _store.dispatch(UpdateFilterisExpandPets(true));
            _store.dispatch(UpdateFilterisExpandSmoking(true));
            _store.dispatch(UpdateFilterisExpandVehical(true));

            _setfilterData(true, filterState);
          },
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              border: Border.all(color: myColor.Circle_main, width: 1),
            ),
            child: Text(
              GlobleString.Fl_Select_all,
              style: MyStyles.Medium(14, myColor.text_color),
            ),
          ),
        ),
        SizedBox(width: 15),
        InkWell(
          onTap: () {
            _setfilterData(false, filterState);
          },
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              border: Border.all(color: myColor.Circle_main, width: 1),
            ),
            child: Text(
              GlobleString.Fl_Clear_all,
              style: MyStyles.Medium(14, myColor.text_color),
            ),
          ),
        ),
        SizedBox(width: 15),
        InkWell(
          onTap: () {
            FilterApply(filterState);
          },
          child: Container(
            height: 30,
            padding: EdgeInsets.only(left: 15, right: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              border: Border.all(color: myColor.Circle_main, width: 1),
              color: myColor.Circle_main,
            ),
            child: Text(
              GlobleString.Fl_Apply,
              style: MyStyles.Medium(14, myColor.white),
            ),
          ),
        ),
      ],
    );
  }

  propertyfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandProperties) {
              _store.dispatch(UpdateFilterisExpandProperties(false));
            } else {
              _store.dispatch(UpdateFilterisExpandProperties(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Property_Name,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandProperties
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandProperties
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.properties.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.properties[Index].isSelected,
                          onChanged: (value) {
                            filterState.properties[Index].isSelected = value;
                            _store.dispatch(
                                UpdateFilterProperty(filterState.properties));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.properties[Index].propertyName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  cityfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandCity) {
              _store.dispatch(UpdateFilterisExpandCity(false));
            } else {
              _store.dispatch(UpdateFilterisExpandCity(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_City,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandCity
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandCity
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.cities.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.cities[Index].isSelected,
                          onChanged: (value) {
                            filterState.cities[Index].isSelected = value;
                            _store
                                .dispatch(UpdateFilterCity(filterState.cities));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.cities[Index].cityName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Ratingfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandRating) {
              _store.dispatch(UpdateFilterisExpandRating(false));
            } else {
              _store.dispatch(UpdateFilterisExpandRating(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Rating,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandRating
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandRating
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.ratinglist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.ratinglist[Index].isSelected,
                          onChanged: (value) {
                            filterState.ratinglist[Index].isSelected = value;
                            _store.dispatch(
                                UpdateFilterRating(filterState.ratinglist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        RatingBarIndicator(
                          rating: double.parse(
                              filterState.ratinglist[Index].rating.toString()),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: myColor.blue,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  ApplicationReceivedfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandApplicationReceived) {
              _store.dispatch(UpdateFilterisExpandApplicationReceived(false));
            } else {
              _store.dispatch(UpdateFilterisExpandApplicationReceived(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Application_Received,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandApplicationReceived
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandApplicationReceived
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.applicationreceivelist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState
                              .applicationreceivelist[Index].isSelected,
                          onChanged: (value) {
                            filterState.applicationreceivelist[Index]
                                .isSelected = value;
                            _store.dispatch(UpdateFilterApplicationReceived(
                                filterState.applicationreceivelist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.applicationreceivelist[Index].apprecName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Statusfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandStatus) {
              _store.dispatch(UpdateFilterisExpandStatus(false));
            } else {
              _store.dispatch(UpdateFilterisExpandStatus(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Status,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandStatus
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandStatus
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.statuslist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.statuslist[Index].ischeck,
                          onChanged: (value) {
                            filterState.statuslist[Index].ischeck = value;
                            _store.dispatch(
                                UpdateFilterStatus(filterState.statuslist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.statuslist[Index] != null
                              ? filterState.statuslist[Index].displayValue
                              : "",
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  EmploymentStatusfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandEmploymentStatus) {
              _store.dispatch(UpdateFilterisExpandEmploymentStatus(false));
            } else {
              _store.dispatch(UpdateFilterisExpandEmploymentStatus(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Employment_Status,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandEmploymentStatus
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandEmploymentStatus
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.employmentstatuslist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value:
                              filterState.employmentstatuslist[Index].ischeck,
                          onChanged: (value) {
                            filterState.employmentstatuslist[Index].ischeck =
                                value;
                            _store.dispatch(UpdateFilterEmploymentStatus(
                                filterState.employmentstatuslist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.employmentstatuslist[Index] != null
                              ? filterState
                                  .employmentstatuslist[Index].displayValue
                              : "",
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  AnnualIncomefilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandAnnualincome) {
              _store.dispatch(UpdateFilterisExpandAnnualincome(false));
            } else {
              _store.dispatch(UpdateFilterisExpandAnnualincome(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Annual_Income,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandAnnualincome
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandAnnualincome
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.annualincomelist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.annualincomelist[Index].ischeck,
                          onChanged: (value) {
                            filterState.annualincomelist[Index].ischeck = value;
                            _store.dispatch(UpdateFilterAnnualIncome(
                                filterState.annualincomelist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.annualincomelist[Index] != null
                              ? filterState.annualincomelist[Index].displayValue
                              : "",
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  NumberofOccupantsfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandNumberOfOccupation) {
              _store.dispatch(UpdateFilterisExpandNumberOfOccupation(false));
            } else {
              _store.dispatch(UpdateFilterisExpandNumberOfOccupation(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Number_of_Occupants,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandNumberOfOccupation
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandNumberOfOccupation
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.numberoccupationlist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState
                              .numberoccupationlist[Index].isSelected,
                          onChanged: (value) {
                            filterState.numberoccupationlist[Index].isSelected =
                                value;
                            _store.dispatch(UpdateFilterNumberOfOccupants(
                                filterState.numberoccupationlist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.numberoccupationlist[Index].noName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Petsfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandPets) {
              _store.dispatch(UpdateFilterisExpandPets(false));
            } else {
              _store.dispatch(UpdateFilterisExpandPets(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Pets,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandPets
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandPets
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.petslist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.petslist[Index].isSelected,
                          onChanged: (value) {
                            filterState.petslist[Index].isSelected = value;
                            _store.dispatch(
                                UpdateFilterPets(filterState.petslist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.petslist[Index].petsName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Smokingfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandSmoking) {
              _store.dispatch(UpdateFilterisExpandSmoking(false));
            } else {
              _store.dispatch(UpdateFilterisExpandSmoking(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Smoking,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandSmoking
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandSmoking
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.smokinglist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.smokinglist[Index].isSelected,
                          onChanged: (value) {
                            filterState.smokinglist[Index].isSelected = value;
                            _store.dispatch(
                                UpdateFilterSmoking(filterState.smokinglist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.smokinglist[Index].smokingName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  Vehicalfilter(TenantFilterState filterState) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            if (filterState.isExpandVehical) {
              _store.dispatch(UpdateFilterisExpandVehical(false));
            } else {
              _store.dispatch(UpdateFilterisExpandVehical(true));
            }
          },
          child: Container(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        GlobleString.Fl_Vehicle,
                        style: MyStyles.Medium(14, myColor.TA_Border),
                      ),
                    ),
                    Icon(
                      filterState.isExpandVehical
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20,
                    )
                  ],
                ),
                Container(
                  height: 1,
                  margin: EdgeInsets.only(top: 3),
                  color: myColor.TA_Border,
                )
              ],
            ),
          ),
        ),
        filterState.isExpandVehical
            ? Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  key: UniqueKey(),
                  itemCount: filterState.vehicallist.length,
                  itemBuilder: (BuildContext ctxt, int Index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: myColor.Circle_main,
                          checkColor: myColor.white,
                          value: filterState.vehicallist[Index].isSelected,
                          onChanged: (value) {
                            filterState.vehicallist[Index].isSelected = value;
                            _store.dispatch(
                                UpdateFilterVehical(filterState.vehicallist));
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          filterState.vehicallist[Index].vehicalName!,
                          textAlign: TextAlign.start,
                          style: MyStyles.Medium(14, myColor.text_color),
                        )
                      ],
                    );
                  },
                ),
              )
            : Container()
      ],
    );
  }

  _setfilterData(bool check, TenantFilterState filterState) {
    List<FilterPropertyItem> propertyitemslist = [];
    List<FilterCityItem> cityitemslist = [];
    List<FilterRatingItem> ratingitemslist = [];
    List<FilterApplicationReceived> applicationReceivedtemslist = [];
    List<SystemEnumDetails> appStatuslist = [];
    List<SystemEnumDetails> employmentStatusitemslist = [];
    List<SystemEnumDetails> annualIncomeitemslist = [];
    List<FilterNumberOfOccupants> numberofoccupantitemslist = [];
    List<FilterPets> petsitemslist = [];
    List<FilterSmoking> smokingitemslist = [];
    List<FilterVehical> vehicalitemslist = [];

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var i = 0; i < filterState.properties.length; i++) {
      FilterPropertyItem propertyItem = filterState.properties[i];
      propertyItem.isSelected = check;
      propertyitemslist.add(propertyItem);
    }

    for (var i = 0; i < filterState.cities.length; i++) {
      FilterCityItem cityItem = filterState.cities[i];
      cityItem.isSelected = check;
      cityitemslist.add(cityItem);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var j = 0; j < 6; j++) {
      FilterRatingItem ratingItem = new FilterRatingItem();
      ratingItem.rating = (5 - j);
      ratingItem.ratingvalue = (5 - j);
      ratingItem.isSelected = check;
      ratingitemslist.add(ratingItem);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var k = 0; k < filterState.employmentstatuslist.length; k++) {
      SystemEnumDetails systemEnumDetails = filterState.employmentstatuslist[k];
      systemEnumDetails.ischeck = check;
      employmentStatusitemslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var m = 0; m < filterState.annualincomelist.length; m++) {
      SystemEnumDetails systemEnumDetails = filterState.annualincomelist[m];
      systemEnumDetails.ischeck = check;
      annualIncomeitemslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var a = 1; a < 6; a++) {
      FilterNumberOfOccupants numberOfOccupants1 =
          new FilterNumberOfOccupants();
      if (a == 5) {
        numberOfOccupants1.noName = a.toString() + "+";
      } else {
        numberOfOccupants1.noName = a.toString();
      }
      numberOfOccupants1.noValue = a.toString();
      numberOfOccupants1.isSelected = check;
      numberofoccupantitemslist.add(numberOfOccupants1);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    for (var k = 0; k < filterState.statuslist.length; k++) {
      SystemEnumDetails systemEnumDetails = filterState.statuslist[k];
      systemEnumDetails.ischeck = check;
      appStatuslist.add(systemEnumDetails);
    }

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterApplicationReceived applicationReceived =
        new FilterApplicationReceived();
    applicationReceived.apprecId = "1";
    applicationReceived.apprecName = "Received";
    applicationReceived.isSelected = check;
    applicationReceivedtemslist.add(applicationReceived);

    FilterApplicationReceived applicationReceived1 =
        new FilterApplicationReceived();
    applicationReceived1.apprecId = "0";
    applicationReceived1.apprecName = "Not received";
    applicationReceived1.isSelected = check;
    applicationReceivedtemslist.add(applicationReceived1);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterPets pets1 = new FilterPets();
    pets1.petsValue = true;
    pets1.petsName = "Yes";
    pets1.isSelected = check;
    petsitemslist.add(pets1);

    FilterPets pets2 = new FilterPets();
    pets2.petsValue = false;
    pets2.petsName = "No";
    pets2.isSelected = check;
    petsitemslist.add(pets2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterSmoking smoking1 = new FilterSmoking();
    smoking1.smokingValue = true;
    smoking1.smokingName = "Yes";
    smoking1.isSelected = check;
    smokingitemslist.add(smoking1);

    FilterSmoking smoking2 = new FilterSmoking();
    smoking2.smokingValue = false;
    smoking2.smokingName = "No";
    smoking2.isSelected = check;
    smokingitemslist.add(smoking2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    FilterVehical vehical1 = new FilterVehical();
    vehical1.vehicalValue = true;
    vehical1.vehicalName = "Yes";
    vehical1.isSelected = check;
    vehicalitemslist.add(vehical1);

    FilterVehical vehical2 = new FilterVehical();
    vehical2.vehicalValue = false;
    vehical2.vehicalName = "No";
    vehical2.isSelected = check;
    vehicalitemslist.add(vehical2);

    /*X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X=X*/

    _store.dispatch(UpdateFilterProperty(propertyitemslist));
    _store.dispatch(UpdateFilterCity(cityitemslist));
    _store.dispatch(UpdateFilterRating(ratingitemslist));
    _store
        .dispatch(UpdateFilterApplicationReceived(applicationReceivedtemslist));
    _store.dispatch(UpdateFilterStatus(appStatuslist));
    _store.dispatch(UpdateFilterEmploymentStatus(employmentStatusitemslist));
    _store.dispatch(UpdateFilterAnnualIncome(annualIncomeitemslist));
    _store.dispatch(UpdateFilterNumberOfOccupants(numberofoccupantitemslist));
    _store.dispatch(UpdateFilterPets(petsitemslist));
    _store.dispatch(UpdateFilterSmoking(smokingitemslist));
    _store.dispatch(UpdateFilterVehical(vehicalitemslist));
  }

  FilterApply(TenantFilterState filterState) async {
    String property = "";
    String cityname = "";
    String Rating = "";
    String AppReceive = "";
    String Status = "";
    String EmpStatus = "";
    String AnnIncome = "";
    String NumOfOccup = "";
    String pets = "";
    String Smoke = "";
    String vehical = "";
    bool isclear = false;

    for (var i = 0; i < filterState.properties.length; i++) {
      FilterPropertyItem propertyItem = filterState.properties[i];
      if (propertyItem.isSelected!) {
        if (property == "")
          property = propertyItem.propertyId.toString();
        else
          property = property + "," + propertyItem.propertyId.toString();
      }
    }

    for (var i = 0; i < filterState.cities.length; i++) {
      FilterCityItem cityItem = filterState.cities[i];
      if (cityItem.isSelected!) {
        if (cityname == "")
          cityname = cityItem.cityName.toString();
        else
          cityname = cityname + "," + cityItem.cityName.toString();
      }
    }

    for (var i = 0; i < filterState.ratinglist.length; i++) {
      FilterRatingItem ratingItem = filterState.ratinglist[i];
      if (ratingItem.isSelected!) {
        if (Rating == "")
          Rating = ratingItem.ratingvalue.toString();
        else
          Rating = Rating + "," + ratingItem.ratingvalue.toString();
      }
    }

    for (var i = 0; i < filterState.applicationreceivelist.length; i++) {
      FilterApplicationReceived applicationReceived =
          filterState.applicationreceivelist[i];
      if (applicationReceived.isSelected!) {
        if (AppReceive == "")
          AppReceive = applicationReceived.apprecId.toString();
        else
          AppReceive =
              AppReceive + "," + applicationReceived.apprecId.toString();
      }
    }

    for (var i = 0; i < filterState.statuslist.length; i++) {
      SystemEnumDetails enumdata = filterState.statuslist[i];
      if (enumdata.ischeck!) {
        if (Status == "")
          Status = enumdata.EnumDetailID.toString();
        else
          Status = Status + "," + enumdata.EnumDetailID.toString();
      }
    }

    for (var i = 0; i < filterState.employmentstatuslist.length; i++) {
      SystemEnumDetails enumdata = filterState.employmentstatuslist[i];
      if (enumdata.ischeck!) {
        if (EmpStatus == "")
          EmpStatus = enumdata.EnumDetailID.toString();
        else
          EmpStatus = EmpStatus + "," + enumdata.EnumDetailID.toString();
      }
    }

    for (var i = 0; i < filterState.annualincomelist.length; i++) {
      SystemEnumDetails enumdata = filterState.annualincomelist[i];
      if (enumdata.ischeck!) {
        if (AnnIncome == "")
          AnnIncome = enumdata.EnumDetailID.toString();
        else
          AnnIncome = AnnIncome + "," + enumdata.EnumDetailID.toString();
      }
    }

    for (var i = 0; i < filterState.numberoccupationlist.length; i++) {
      FilterNumberOfOccupants numofoccup = filterState.numberoccupationlist[i];
      if (numofoccup.isSelected!) {
        if (NumOfOccup == "")
          NumOfOccup = numofoccup.noValue.toString();
        else
          NumOfOccup = NumOfOccup + "," + numofoccup.noValue.toString();
      }
    }

    for (var i = 0; i < filterState.petslist.length; i++) {
      FilterPets petsItem = filterState.petslist[i];
      if (petsItem.isSelected!) {
        if (pets == "")
          pets = petsItem.petsValue.toString();
        else
          pets = pets + "," + petsItem.petsValue.toString();
      }
    }

    for (var i = 0; i < filterState.smokinglist.length; i++) {
      FilterSmoking filterSmoking = filterState.smokinglist[i];
      if (filterSmoking.isSelected!) {
        if (Smoke == "")
          Smoke = filterSmoking.smokingValue.toString();
        else
          Smoke = Smoke + "," + filterSmoking.smokingValue.toString();
      }
    }

    for (var i = 0; i < filterState.vehicallist.length; i++) {
      FilterVehical filterVehical = filterState.vehicallist[i];
      if (filterVehical.isSelected!) {
        if (vehical == "")
          vehical = filterVehical.vehicalValue.toString();
        else
          vehical = vehical + "," + filterVehical.vehicalValue.toString();
      }
    }

    FilterReqtokens reqtokens = new FilterReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Prop_ID =
        widget.isfunnel ? widget.selectpropertyValue!.ID : property;
    reqtokens.City = cityname;
    reqtokens.Rating = Rating;
    reqtokens.ApplicationStatus = Status;
    reqtokens.ApplicationReceived = AppReceive;
    reqtokens.EmploymentStatus = EmpStatus;
    reqtokens.AnnualIncome = AnnIncome;
    reqtokens.NumberofOccupants = NumOfOccup;
    reqtokens.Pets = pets;
    reqtokens.Smoking = Smoke;
    reqtokens.Vehicle = vehical;
    reqtokens.IsArchived = "0";

    if (property == "" &&
        cityname == "" &&
        Rating == "" &&
        Status == "" &&
        AppReceive == "" &&
        EmpStatus == "" &&
        AnnIncome == "" &&
        NumOfOccup == "" &&
        pets == "" &&
        Smoke == "" &&
        vehical == "") {
      isclear = true;
      await Prefs.setBool(PrefsName.IsApplyFilterList, false);
      await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
    } else {
      if (!widget.isfunnel) {
        await Prefs.setBool(PrefsName.IsApplyFilterList, true);
        await Prefs.setBool(PrefsName.IsApplyFilterFunnel, false);
      } else {
        await Prefs.setBool(PrefsName.IsApplyFilterFunnel, true);
        await Prefs.setBool(PrefsName.IsApplyFilterList, false);
      }
    }

    FilterData filterData = new FilterData();
    filterData.DSQID = Weburl.DSQ_CommonView;
    filterData.LoadLookupValues = true;
    filterData.LoadRecordInfo = true;
    filterData.Reqtokens = reqtokens;

    String filterjson = jsonEncode(filterData);
    await Prefs.setString(PrefsName.ApplyFilterJson, filterjson);

    Helper.Log("Filter Apply", filterjson);

    widget._callbackApply(filterjson, isclear);
  }
}
