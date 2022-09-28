import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/propertylist.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/tablayer/api_manager.dart';
import 'package:silverhome/tablayer/dsq_query.dart';
import 'package:silverhome/tablayer/httpclient.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:silverhome/validators/validators.dart';

import '../bloc.dart';
/* SocketIO socketIO; */

class TestBloc with Validators {
  TestBloc();
  List<dynamic> dataTest = [];
  final _store = getIt<AppStore>();

  ///TestScreen
  final _testController = BehaviorSubject<List<PropertyDataList>>();
  Stream<List<PropertyDataList>> get getTestTransformer =>
      _testController.stream;
  Function(List<PropertyDataList>) get changeTest => _testController.sink.add;
  getDataTest() {
    return _testController.value;
  }

  getPropertyOnboadingList(String search, int pageNo, String SortField,
      int saquence, int ftime, BuildContext context) async {
    PropertyListReqtokens reqtokens = PropertyListReqtokens();
    reqtokens.Owner_ID = Prefs.getString(PrefsName.OwnerID);
    reqtokens.Name = search != null ? search : "";

    Pager pager = Pager(pageNo: pageNo, noOfRecords: Helper.noofrecored);

    List<Sort> sortinglist = [];
    Sort sort = Sort();
    sort.fieldId = SortField;
    sort.sortSequence = saquence;
    sortinglist.add(sort);

    DSQQuery dsqQuery = DSQQuery();
    dsqQuery.dsqid = Weburl.DSQ_PropertyOnBoardingList;
    dsqQuery.loadLookUpValues = true;
    dsqQuery.loadRecordInfo = true;
    dsqQuery.propertyListReqtokens = reqtokens;
    dsqQuery.pager = pager;
    dsqQuery.sort = sortinglist;

    String filterjson = jsonEncode(dsqQuery);

    Helper.Log("Property", filterjson);

    List<PropertyDataList> propertylist = [];
    HttpClientCall().DSQAPICall(context, filterjson, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);
        var result = data['Result'];
        propertylist = List<PropertyDataList>.from(
            result.map((x) => PropertyDataList.fromJson(x)));
        changeTest(propertylist);
/*         for (int i = 0; i < data['Result'].length; i++) {
          var myobject = data['Result'][i];

          String ID = myobject['ID'] != null ? myobject['ID'].toString() : "";

          String PropertyName = myobject['PropertyName'] != null
              ? myobject['PropertyName'].toString()
              : "";

          String Other_Property_Type = myobject['Other_Property_Type'] != null
              ? myobject['Other_Property_Type'].toString()
              : "";

          String Suite_Unit = myobject['Suite_Unit'] != null
              ? myobject['Suite_Unit'].toString()
              : "";

          bool IsActive =
              myobject['IsActive'] != null ? myobject['IsActive'] : false;

          bool IsAgreed_TandC = myobject['IsAgreed_TandC'] != null
              ? myobject['IsAgreed_TandC']
              : false;

          String City =
              myobject['City'] != null ? myobject['City'].toString() : "";

          String Country =
              myobject['Country'] != null ? myobject['Country'].toString() : "";

          int PropDrafting =
              myobject['PropDrafting'] != null ? myobject['PropDrafting'] : 0;

          bool Vacancy =
              myobject['Vacancy'] != null ? myobject['Vacancy'] : false;

          bool IsPublished =
              myobject['IsPublished'] != null ? myobject['IsPublished'] : false;

          SystemEnumDetails? Property_Type = myobject['Property_Type'] != null
              ? SystemEnumDetails.fromJson(myobject['Property_Type'])
              : null;

          /*RecordInfo*/

          var objRecordInfo = myobject["RecordInfo"];

          String CreatedOn = objRecordInfo['CreatedOn'] != null
              ? objRecordInfo['CreatedOn'].toString()
              : "0";

          String UpdatedOn = objRecordInfo['UpdatedOn'] != null
              ? objRecordInfo['UpdatedOn'].toString()
              : "0";

          PropertyDataList propertyData = new PropertyDataList();
          propertyData.id = ID;
          propertyData.propertyName = PropertyName;
          propertyData.otherPropertyType = Other_Property_Type;
          propertyData.isActive = IsActive;
          propertyData.isAgreedTandC = IsAgreed_TandC;
          propertyData.city = City;
          propertyData.country = Country;
          propertyData.suiteUnit = Suite_Unit;
          propertyData.propertyType = Property_Type;
          propertyData.propDrafting = PropDrafting;
          propertyData.vacancy = Vacancy;
          propertyData.isPublished = IsPublished;
          propertyData.createdOn = CreatedOn;
          propertyData.updatedOn = UpdatedOn;

          propertylist.add(propertyData);
        } */

      }
    });
  }

  dispose() {
    _testController.close();
  }
}
