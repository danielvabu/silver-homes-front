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

class PropertyBloc with Validators {
  PropertyBloc();
  int muestraElListado = 0;
  List<dynamic> propertyList = [];
  final _store = getIt<AppStore>();

  ///propertyScreen
  final _propertyController = BehaviorSubject<List<PropertyDataList>>();
  Stream<List<PropertyDataList>> get getpropertyTransformer =>
      _propertyController.stream;
  Function(List<PropertyDataList>) get changeproperty =>
      _propertyController.sink.add;
  getPropertyList() {
    return _propertyController.value;
  }

  getPropertyFilterList(String search, int pageNo, String SortField,
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
    await HttpClientCall().DSQAPICall(context, filterjson, (error, respoce) {
      if (error) {
        //loader.remove();
        var data = jsonDecode(respoce);
        var result = data['Result'];
        propertylist = List<PropertyDataList>.from(
            result.map((x) => PropertyDataList.fromJson(x)));
        changeproperty(propertylist);
      }
    });
  }

  dispose() {
    _propertyController.close();
  }
}
