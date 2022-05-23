//--------x: Class Enums :x---------//

class eUserType {
  int landlord = 1;
  int Tenant = 2;
}

class eApplicationStatus {
  int Lead = 1;
  int Applicant = 2;
  int DocVarify = 3;
  int ReferenceCheck = 4;
  int LeaseSent = 5;
  int ActiveTenent = 6;
}

class eLeaseStatus {
  int Signed = 1;
  int Unsigned = 2;
  int ChangeRequired = 3;
  int Void = 4;
}

class eQueryType {
  int Select = 0;
  int Insert = 1;
  int Update = 2;
  int Delete = 3;
}

class eSystemEnums {
  int TenancyLength = 1176;
  int ApplicationStatus = 1177;
  int DocReviewStatus = 1178;
  int ReferenceStatus = 1179;
  int LeaseStatus = 1180;
  int EmploymentStatus = 1181;
  int ApplicationDetailStatus = 1182;
  int AnnualIncomeStatus = 1183;
  int FeatureType = 1184;
  int PropertyType = 1185;
  int RentalSpace = 1186;
  int RentPaymentFrequency = 1187;
  int LeaseType = 1188;
  int MinLeaseDuration = 1189;
  int Furnishing = 1190;
  int Restrictions = 1191;
  int Storage = 2184;
  int MediaType = 1;
  int MediaFileType = 2;
  int ReferenceLenthofTenancy = 3184;
  int Maintenance_Category = 3186;
  int Maintenance_Status = 3187;
  int Priority = 3188;
}

enum eJoinType { LeftJoin, RightJoin }

class eRelationalOperator {
  int GreaterThan = 1;
  int LessThan = 2;
  int EqualTo = 3;
  int IN = 4;
  int NOTIN = 5;
  int ISNULL = 6;
  int ISNOTNULL = 7;
  int NOT_EQUAL_TO = 8;
}

class eConjuctionClause {
  int AND = 1;
  int OR = 2;
  int AND_NOT = 3;
  int OR_NOT = 4;
  int IN = 5;
}

class eMediaRestriction {
  int None = 0;
  int Video = 1;
  int Audio = 2;
}

class eMediaType {
  int CopyofID = 1;
  int Proofoffunds = 2;
  int Employmentverification = 3;
  int Creditrecord = 4;
}

class eMediaFileType {
  int Image = 1;
  int PDF = 2;
  int CSV = 3;
  int Excel = 4;
  int Word = 5;
  int Text = 6;
}

//--------x: Classes :x---------//

class QueryObject {
  String queryObjectId;
  int queryType;
  List<dynamic> joins;
  WhereClause whereClause;
  List<dynamic> resultFieldAppfieldIds;
  List<Value> values; // ket
  bool loadLookUpValues;
  bool loadRecordInfo;

  QueryObject({
    required this.queryObjectId,
    required this.queryType,
    required this.joins,
    required this.whereClause,
    required this.resultFieldAppfieldIds,
    required this.values,
    required this.loadLookUpValues,
    required this.loadRecordInfo,
  });

  factory QueryObject.fromJson(Map<String, dynamic> json) => QueryObject(
        queryObjectId: json["QueryObjectID"],
        queryType: json["QueryType"],
        joins: json['Joins'] != null
            ? List<dynamic>.from(json["Joins"].map((x) => x))
            : [],
        whereClause: WhereClause.fromJson(json["WhereClause"]),
        resultFieldAppfieldIds:
            List<dynamic>.from(json["ResultField_AppfieldIds"].map((x) => x)),
        values: json['Values'] != null
            ? List<Value>.from(json["Values"].map((x) => Value.fromJson(x)))
            : [],
        loadLookUpValues:
            json["LoadLookUpValues"] != null ? json["LoadLookUpValues"] : false,
        loadRecordInfo:
            json["LoadRecordInfo"] != null ? json["LoadRecordInfo"] : false,
      );

  Map<String, dynamic> toJson() => {
        "QueryObjectID": queryObjectId,
        "QueryType": queryType,
        "Joins": List<dynamic>.from(joins.map((x) => x)),
        "WhereClause": whereClause.toJson(),
        "ResultField_AppfieldIds":
            List<dynamic>.from(resultFieldAppfieldIds.map((x) => x)),
        "Values": List<dynamic>.from(values.map((x) => x.toJson())),
        "LoadLookUpValues": loadLookUpValues,
        "LoadRecordInfo": loadRecordInfo,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["QueryObjectID"] = queryObjectId;
    map["QueryType"] = queryType;
    map["Joins"] = joins;
    map["WhereClause"] = whereClause;
    map["ResultField_AppfieldIds"] = resultFieldAppfieldIds;
    map["Values"] = values;
    map["LoadLookUpValues"] = loadLookUpValues;
    map["LoadRecordInfo"] = loadRecordInfo;
    return map;
  }
}

class Value {
  Value({
    this.appFieldId,
    this.value,
  });

  String? appFieldId;
  dynamic value;

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        appFieldId: json["AppFieldID"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "AppFieldID": appFieldId,
        "Value": value,
      };
}

class JoinDetails {
  eJoinType? JoinType;
  ChildRelationShip? Relationship;

  JoinDetails({
    this.JoinType,
    this.Relationship,
  });

  factory JoinDetails.fromJson(Map<String, dynamic> json) => JoinDetails(
        JoinType: json["JoinType"],
        Relationship: ChildRelationShip.fromJson(json["ChildRelationShip"]),
      );

  Map toJson() => {
        "JoinType": JoinType,
        "ChildRelationShip": Relationship!.toJson(),
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["JoinType"] = JoinType;
    map["ChildRelationShip"] = Relationship;
    return map;
  }
}

class ChildRelationShip {
  String? RelSourceObjectID;
  String? RelSourceFieldID;
  String? RelTargetObjectID;
  String? RelTargetFieldID;

  ChildRelationShip({
    this.RelSourceObjectID,
    this.RelSourceFieldID,
    this.RelTargetObjectID,
    this.RelTargetFieldID,
  });

  factory ChildRelationShip.fromJson(Map<String, dynamic> json) =>
      ChildRelationShip(
        RelSourceObjectID: json["RelSourceObjectID"],
        RelSourceFieldID: json["RelSourceFieldID"],
        RelTargetObjectID: json["RelTargetObjectID"],
        RelTargetFieldID: json["RelTargetFieldID"],
      );

  Map toJson() => {
        "RelSourceObjectID": RelSourceObjectID,
        "RelSourceFieldID": RelSourceFieldID,
        "RelTargetObjectID": RelTargetObjectID,
        "RelTargetFieldID": RelTargetFieldID,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["RelSourceObjectID"] = RelSourceObjectID;
    map["RelSourceFieldID"] = RelSourceFieldID;
    map["RelTargetObjectID"] = RelTargetObjectID;
    map["RelTargetFieldID"] = RelTargetFieldID;

    return map;
  }
}

class Filter {
  int? conjuctionClause;
  String? fieldId;
  int? relationalOperator;
  int? valueType;
  String? value;
  int? sequence;
  int? groupID;

  Filter({
    this.conjuctionClause,
    this.fieldId,
    this.relationalOperator,
    this.valueType,
    this.value,
    this.sequence,
    this.groupID,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        conjuctionClause: json["ConjuctionClause"],
        fieldId: json["FieldID"],
        relationalOperator: json["RelationalOperator"],
        valueType: json["ValueType"],
        value: json["Value"],
        sequence: json["Sequence"],
        groupID: json["GroupID"],
      );

  Map toJson() => {
        "ConjuctionClause": conjuctionClause,
        "FieldID": fieldId,
        "RelationalOperator": relationalOperator,
        "ValueType": valueType,
        "Value": value,
        "Sequence": sequence,
        "GroupID": groupID
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ConjuctionClause"] = conjuctionClause;
    map["FieldID"] = fieldId;
    map["RelationalOperator"] = relationalOperator;
    map["ValueType"] = valueType;
    map["Value"] = value;
    map["Sequence"] = sequence;
    map["GroupID"] = groupID;

    return map;
  }
}

class WhereClause {
  List<Filter> Filters;
  String? FilterLogic;

  WhereClause({
    this.FilterLogic,
    required this.Filters,
  });

  factory WhereClause.fromJson(Map<String, dynamic> json) => WhereClause(
        FilterLogic: json["FilterLogic"],
        Filters:
            List<Filter>.from(json["Filters"].map((x) => Filter.fromJson(x))),
      );

  Map toJson() => {
        "FilterLogic": FilterLogic,
        "Filters": List<dynamic>.from(Filters.map((x) => x.toJson())),
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["FilterLogic"] = FilterLogic;
    map["Filters"] = Filters;
    return map;
  }
}

//--------x: CallBack :x---------//

typedef CallBackResponce = void Function(
    bool status, String responce, String erromsg);
