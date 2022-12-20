import 'dart:collection';
import 'dart:convert';

import 'package:silverhome/common/helper.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/domain/entities/propertydata.dart';
import 'package:silverhome/tablayer/e_table_names.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';

class QueryFilter {
  /*--------Get ResultField_AppfieldIds list return--------*/
  List<String> GenerateAppFields() {
    List<String> app_field_array = new List.empty();
    return app_field_array;
  }

  /*--------Get WhereClause object return--------*/
  WhereClause GenerateFilter(
      Object model_Obj, int Clause, int relational, int valuetype) {
    List<Filter> Filterarray = [];

    WhereClause whereclause;

    try {
      final response = jsonEncode(model_Obj);

      List<String> listkey = [];
      List<String> listvalue = [];

      final Map<String, dynamic> data = jsonDecode(response);

      data.forEach((key, value) {
        //print("Key : ${key}");
        //print("value : ${value}");
        listkey.add(key);
        listvalue.add(value.toString());
      });

      for (int i = 0; i < listkey.length; i++) {
        Filter filter = new Filter();
        filter.conjuctionClause = Clause;
        filter.relationalOperator = relational.toInt();
        filter.value = listvalue[i].toString();
        filter.valueType = valuetype;
        filter.fieldId = listkey[i].toString();
        filter.groupID = 0;
        filter.sequence = 0;

        Filterarray.add(filter);
      }

      whereclause = new WhereClause(FilterLogic: "1", Filters: Filterarray);
    } catch (e) {
      whereclause = new WhereClause(FilterLogic: "1", Filters: Filterarray);
    }

    return whereclause;
  }

  /*--------Get WhereClause object return--------*/
  WhereClause GenerateFilterArray(
      Object model_Obj, int Clause, List<int> relational, int valuetype) {
    List<Filter> Filterarray = [];

    WhereClause whereclause;

    try {
      final response = jsonEncode(model_Obj);

      //print("In WhereClause >>>> " + response);

      List<String> listkey = [];
      List<String?> listvalue = [];

      final Map<String, dynamic> data = jsonDecode(response);

      data.forEach((key, value) {
        //print("Key : ${key}");
        //print("value : ${value}");
        listkey.add(key);
        listvalue.add(value);
      });

      for (int i = 0; i < listkey.length; i++) {
        Filter filter = new Filter();
        filter.conjuctionClause = Clause;
        filter.relationalOperator = relational[i];
        filter.value = listvalue[i];
        filter.valueType = valuetype;
        filter.fieldId = listkey[i].toString();
        filter.groupID = 0;
        filter.sequence = 0;

        Filterarray.add(filter);
      }

      whereclause = new WhereClause(FilterLogic: "1", Filters: Filterarray);
    } catch (e) {
      whereclause = new WhereClause(FilterLogic: "1", Filters: Filterarray);
    }

    return whereclause;
  }

  /*--------Get Insert query ConvertToValueSet return--------*/
  List<Value> ConvertToValueSet(Object pojo) {
    String json = jsonEncode(pojo);

    // print("Convert to JsonArray: " + json);

    List<Value> valueSetObjectList = LookupConvertToValueSet(json);

    return valueSetObjectList;
  }

  /*--------Get Insert query LookupConvertToValueSet return--------*/
  List<Value> LookupConvertToValueSet(String json) {
    List<Value> valueSetObjectList = [];

    Value valueSetObject;

    final Map<String, dynamic> data = jsonDecode(json);

    data.forEach((key, value) {
      // print("Key : ${key}");
      // print("value : ${value}");

      valueSetObject = new Value();

      valueSetObject.appFieldId = key;

      if (value == null) {
        valueSetObject.value = null;
      } else if (value is String) {
        valueSetObject.value = value.toString();
      } else if (value is int) {
        valueSetObject.value = value.toString();
      } else if (value is double) {
        valueSetObject.value = value.toString();
      } else if (value is bool) {
        valueSetObject.value = value.toString();
      } else {
        valueSetObject.value = LookupConvertToValueSet(jsonEncode(value));
      }

      valueSetObjectList.add(valueSetObject);
    });

    return valueSetObjectList;
  }

  /*--------Insert query return--------*/
  String InsertQuery(Object POJO, var tableName, int Clause, int relational) {
    QueryObject querySelect =
        InsertQueryObject(POJO, tableName, Clause, relational);

    String json = jsonEncode(querySelect);
    Helper.Log("InsertQuery", json);
    return json;
  }

  QueryObject InsertQueryObject(
      Object POJO, var tableName, int Clause, int relational) {
    Object blankObject = new Object();

    QueryObject querySelect = new QueryObject(
      queryObjectId: TableNames().getTabelname(tableName).toString(),
      queryType: eQueryType().Insert.toInt(),
      joins: [],
      whereClause: GenerateFilter(blankObject, Clause, relational, 0),
      resultFieldAppfieldIds: GenerateAppFields(),
      values: ConvertToValueSet(POJO),
      loadLookUpValues: false,
      loadRecordInfo: false,
    );

    return querySelect;
  }

  String InsertQueryArray(
      List<Object> list_POJO, var tableName, int Clause, int relational) {
    List<QueryObject> queryList = <QueryObject>[];

    queryList = InsertQueryArrayList(list_POJO, tableName, Clause, relational);

    String json = jsonEncode(queryList);

    Helper.Log("InsertQueryArray", json);
    return json;
  }

  List<QueryObject> InsertQueryArrayList(
      List<Object> list_POJO, var tableName, int Clause, int relational) {
    List<QueryObject> queryList = <QueryObject>[];
    QueryObject queryInsert;

    Object blankObject = new Object();

    for (int i = 0; i < list_POJO.length; i++) {
      queryInsert = new QueryObject(
        queryObjectId: TableNames().getTabelname(tableName).toString(),
        queryType: eQueryType().Insert.toInt(),
        joins: [],
        whereClause: GenerateFilter(blankObject, Clause, relational, 0),
        resultFieldAppfieldIds: GenerateAppFields(),
        values: ConvertToValueSet(list_POJO[i]),
        loadLookUpValues: false,
        loadRecordInfo: false,
      );

      queryList.add(queryInsert);
    }

    return queryList;
  }

  /*--------Select Query return--------*/

  String SelectQuery(Object POJO, var tableName, int Clause, int relational,
      bool loadLookUpValues) {
    QueryObject querySelect = SelectQueryObject(
        POJO, tableName, Clause, relational, loadLookUpValues);

    String json = jsonEncode(querySelect);

    Helper.Log("SelectQuery", json);

    return json;
    //selectAPICall(json);
  }

  QueryObject SelectQueryObject(Object POJO, var tableName, int Clause,
      int relational, bool loadLookUpValues) {
    QueryObject querySelect = new QueryObject(
      queryObjectId: TableNames().getTabelname(tableName).toString(),
      queryType: eQueryType().Select.toInt(),
      joins: [],
      whereClause: GenerateFilter(POJO, Clause, relational, 0),
      resultFieldAppfieldIds: GenerateAppFields(),
      values: [],
      loadLookUpValues: loadLookUpValues,
      loadRecordInfo: true,
    );

    return querySelect;
    //selectAPICall(json);
  }

  /*--------Delete Query return--------*/

  String DeleteQuery(Object POJO, var tableName, int Clause, int relational) {
    QueryObject querySelect =
        DeleteQueryObject(POJO, tableName, Clause, relational);

    String json = jsonEncode(querySelect);

    Helper.Log("DeleteQuery", json);

    return json;
    //deleteAPICall(json);
  }

  String DeleteQueryFilterArray(
      Object POJO, var tableName, int Clause, List<int> relational) {
    QueryObject querySelect =
        DeleteQueryObjectFilterArray(POJO, tableName, Clause, relational);

    String json = jsonEncode(querySelect);

    Helper.Log("DeleteQuery", json);
    return json;
    //deleteAPICall(json);
  }

  QueryObject DeleteQueryObject(
      Object POJO, var tableName, int Clause, int relational) {
    QueryObject querySelect = new QueryObject(
      queryObjectId: TableNames().getTabelname(tableName).toString(),
      queryType: eQueryType().Delete.toInt(),
      joins: [],
      whereClause: GenerateFilter(POJO, Clause, relational, 1),
      resultFieldAppfieldIds: GenerateAppFields(),
      values: [],
      loadLookUpValues: false,
      loadRecordInfo: false,
    );

    return querySelect;
    //deleteAPICall(json);
  }

  QueryObject DeleteQueryObjectFilterArray(
      Object POJO, var tableName, int Clause, List<int> relational) {
    QueryObject querySelect = new QueryObject(
        queryObjectId: TableNames().getTabelname(tableName).toString(),
        queryType: eQueryType().Delete.toInt(),
        joins: [],
        whereClause: GenerateFilterArray(POJO, Clause, relational, 1),
        resultFieldAppfieldIds: GenerateAppFields(),
        values: [],
        loadLookUpValues: false,
        loadRecordInfo: false);

    return querySelect;
    //deleteAPICall(json);
  }

  /*--------Update Query return--------*/

  String UpdateQuery(Object ClausePOJO, Object UpdatePOJO, var tableName,
      int Clause, int relational) {
    QueryObject querySelect = UpdateQueryObject(
        ClausePOJO, UpdatePOJO, tableName, Clause, relational);

    String json = jsonEncode(querySelect);

    Helper.Log("UpdateQuery", json);
    return json;
  }

  QueryObject UpdateQueryObject(Object ClausePOJO, Object UpdatePOJO,
      var tableName, int Clause, int relational) {
    QueryObject querySelect = new QueryObject(
      queryObjectId: TableNames().getTabelname(tableName).toString(),
      queryType: eQueryType().Update.toInt(),
      joins: [],
      whereClause: GenerateFilter(ClausePOJO, Clause, relational, 0),
      resultFieldAppfieldIds: GenerateAppFields(),
      values: ConvertToValueSet(UpdatePOJO),
      loadLookUpValues: false,
      loadRecordInfo: false,
    );

    return querySelect;
  }

  String UpdateQueryArray(Object ClausePOJO, List<Object> list_POJO,
      var tableName, int Clause, int relational) {
    List<QueryObject> queryList = <QueryObject>[];

    queryList = UpdateQueryArrayList(
        ClausePOJO, list_POJO, tableName, Clause, relational);

    String json = jsonEncode(queryList);
    Helper.Log("UpdateQueryArray", json);
    return json;
  }

  List<QueryObject> UpdateQueryArrayList(Object ClausePOJO,
      List<Object> list_POJO, var tableName, int Clause, int relational) {
    List<QueryObject> queryList = <QueryObject>[];

    for (int i = 0; i < list_POJO.length; i++) {
      QueryObject queryInsert = new QueryObject(
        queryObjectId: TableNames().getTabelname(tableName).toString(),
        queryType: eQueryType().Update.toInt(),
        joins: [],
        whereClause: GenerateFilter(ClausePOJO, Clause, relational, 0),
        resultFieldAppfieldIds: GenerateAppFields(),
        values: ConvertToValueSet(list_POJO[i]),
        loadLookUpValues: false,
        loadRecordInfo: false,
      );

      queryList.add(queryInsert);
    }

    return queryList;
  }

  /*-----------------------------------------------------------------------*/

  List<SystemEnumDetails> PlainValues(int id) {
    String json = Prefs.getString(PrefsName.systemEnumDetails);

    var data = jsonDecode(json);

    List<SystemEnumDetails> list;
    var rest = data as List;
    list = rest
        .map<SystemEnumDetails>((json) => SystemEnumDetails.fromJson(json))
        .toList();

    /* HashMap hashMap = new HashMap<int, List<SystemEnumDetails>>();
    hashMap = jsonDecode(json);*/

    HashMap hashMap = new HashMap<int, List<SystemEnumDetails>>();

    for (int i = 0; i < list.length; i++) {
      SystemEnumDetails model = list[i];
      int enumid = model.enumID;

      if (hashMap.containsKey(enumid)) {
        List<SystemEnumDetails> enums = hashMap[enumid];
        enums.add(model);
        hashMap[enumid] = enums;
      } else {
        List<SystemEnumDetails> enumssec = <SystemEnumDetails>[];
        enumssec.add(model);
        hashMap[enumid] = enumssec;
      }
    }

    /*
    var data = jsonDecode(json);
    var rest = data[id] as List;
    list = rest.map<SystemEnumDetails>((json) => SystemEnumDetails.fromJson(json)).toList();*/

    List<SystemEnumDetails> enumDetailslist = [];

    if (hashMap[id] != null) {
      enumDetailslist = hashMap[id];
    }
    enumDetailslist.removeWhere(
        (element) => element.displayValue == "Verifying Documents");
    return enumDetailslist;
  }

  List<SystemEnumDetails> PlainValuesWithSorting(int id) {
    String json = Prefs.getString(PrefsName.systemEnumDetails);

    var data = jsonDecode(json);

    List<SystemEnumDetails> list;
    var rest = data as List;
    list = rest
        .map<SystemEnumDetails>((json) => SystemEnumDetails.fromJson(json))
        .toList();

    HashMap hashMap = new HashMap<int, List<SystemEnumDetails>>();

    for (int i = 0; i < list.length; i++) {
      SystemEnumDetails model = list[i];
      int enumid = model.enumID;

      if (hashMap.containsKey(enumid)) {
        List<SystemEnumDetails> enums = hashMap[enumid];
        enums.add(model);
        hashMap[enumid] = enums;
      } else {
        List<SystemEnumDetails> enumssec = <SystemEnumDetails>[];
        enumssec.add(model);
        hashMap[enumid] = enumssec;
      }
    }

    List<SystemEnumDetails> enumDetailslist = [];

    if (hashMap[id] != null) {
      enumDetailslist = hashMap[id];
      enumDetailslist.sort(
          (a, b) => a.Sequence.toString().compareTo(b.Sequence.toString()));
    }

    /*List<SystemEnumDetails> listdata = hashMap[id];
    listdata.sort((a, b) => a.Sequence.toString().compareTo(b.Sequence.toString()));*/

    return enumDetailslist;
  }
}

typedef PropertyListCallback = void Function(
    List<PropertyData> propertylist, bool errorBool);

typedef OwnerCallback = void Function(Person person, bool errorBool);
