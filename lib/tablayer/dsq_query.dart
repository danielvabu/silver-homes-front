class DSQQuery {
  DSQQuery({
    this.dsqid,
    this.vendorListReqtokens,
    this.maintenanceListReqtokens,
    this.tenantMaintenanceListReqtokens,
    this.landlordlistrequest,
    this.propertyListReqtokens,
    this.leadsListReqtokens,
    this.leadsTenantListReqtokens,
    this.loadLookUpValues,
    this.loadRecordInfo,
    this.pager,
    this.sort,
  });

  String? dsqid;
  VendorListReqtokens? vendorListReqtokens;
  TenantMaintenanceListReqtokens? tenantMaintenanceListReqtokens;
  MaintenanceListReqtokens? maintenanceListReqtokens;
  LanloadListReqtokens? landlordlistrequest;
  PropertyListReqtokens? propertyListReqtokens;
  LeadsListReqtokens? leadsListReqtokens;
  LeadsTenantListReqtokens? leadsTenantListReqtokens;
  bool? loadLookUpValues;
  bool? loadRecordInfo;
  Pager? pager;
  List<Sort>? sort;

  factory DSQQuery.fromJson(Map<String, dynamic> json) => DSQQuery(
        dsqid: json["DSQID"],
        vendorListReqtokens: VendorListReqtokens.fromJson(json["Reqtokens"]),
        tenantMaintenanceListReqtokens:
            TenantMaintenanceListReqtokens.fromJson(json["Reqtokens"]),
        maintenanceListReqtokens:
            MaintenanceListReqtokens.fromJson(json["Reqtokens"]),
        landlordlistrequest: LanloadListReqtokens.fromJson(json["Reqtokens"]),
        propertyListReqtokens:
            PropertyListReqtokens.fromJson(json["Reqtokens"]),
        leadsListReqtokens: LeadsListReqtokens.fromJson(json["Reqtokens"]),
        leadsTenantListReqtokens:
            LeadsTenantListReqtokens.fromJson(json["Reqtokens"]),
        loadLookUpValues: json["LoadLookUpValues"],
        loadRecordInfo: json["LoadRecordInfo"],
        pager: Pager.fromJson(json["Pager"]),
        sort: List<Sort>.from(json["Sort"].map((x) => Sort.fromJson(x))),
      );

  /* Map<String, dynamic> toJson() => {
    "DSQID": dsqid,
    "Reqtokens": landlordlistrequest!.toJson(),
    "LoadLookUpValues": loadLookUpValues,
    "Pager": pager!.toJson(),
    "Sort": List<dynamic>.from(sort!.map((x) => x.toJson())),
  };*/

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (dsqid != null && dsqid != "") {
      map["DSQID"] = dsqid;
    }
    if (vendorListReqtokens != null && vendorListReqtokens != "") {
      map["Reqtokens"] = vendorListReqtokens;
    }
    if (tenantMaintenanceListReqtokens != null &&
        tenantMaintenanceListReqtokens != "") {
      map["Reqtokens"] = tenantMaintenanceListReqtokens;
    }
    if (maintenanceListReqtokens != null && maintenanceListReqtokens != "") {
      map["Reqtokens"] = maintenanceListReqtokens;
    }
    if (landlordlistrequest != null && landlordlistrequest != "") {
      map["Reqtokens"] = landlordlistrequest;
    }
    if (propertyListReqtokens != null && propertyListReqtokens != "") {
      map["Reqtokens"] = propertyListReqtokens;
    }
    if (leadsListReqtokens != null && leadsListReqtokens != "") {
      map["Reqtokens"] = leadsListReqtokens;
    }
    if (leadsTenantListReqtokens != null && leadsTenantListReqtokens != "") {
      map["Reqtokens"] = leadsTenantListReqtokens;
    }
    if (loadLookUpValues != null && loadLookUpValues != "") {
      map["LoadLookUpValues"] = loadLookUpValues;
    }
    if (loadRecordInfo != null && loadRecordInfo != "") {
      map["LoadRecordInfo"] = loadRecordInfo;
    }
    if (pager != null && pager != "") {
      map["Pager"] = pager!.toJson();
    }
    if (sort != null && sort != "") {
      map["Sort"] = List<dynamic>.from(sort!.map((x) => x.toJson()));
    }
    return map;
  }
}

class Pager {
  Pager({
    required this.pageNo,
    required this.noOfRecords,
  });

  int pageNo;
  int noOfRecords;

  factory Pager.fromJson(Map<String, dynamic> json) => Pager(
        pageNo: json["PageNo"],
        noOfRecords: json["NoOfRecords"],
      );

  Map<String, dynamic> toJson() => {
        "PageNo": pageNo,
        "NoOfRecords": noOfRecords,
      };
}

class Sort {
  Sort({
    this.fieldId,
    this.sortSequence,
  });

  String? fieldId;
  int? sortSequence;

  factory Sort.fromJson(Map<String, dynamic> json) => Sort(
        fieldId: json["FieldID"],
        sortSequence: json["SortSequence"],
      );

  Map<String, dynamic> toJson() => {
        "FieldID": fieldId,
        "SortSequence": sortSequence,
      };
}

class VendorListReqtokens {
  VendorListReqtokens({
    this.Owner_ID,
    this.Name,
  });

  String? Owner_ID;
  String? Name;

  factory VendorListReqtokens.fromJson(Map<String, dynamic> json) =>
      VendorListReqtokens(
        Owner_ID: json["Owner_ID"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
        "Name": Name,
      };
}

class MaintenanceListReqtokens {
  MaintenanceListReqtokens({
    this.Owner_ID,
    this.Name,
  });

  String? Owner_ID;
  String? Name;

  factory MaintenanceListReqtokens.fromJson(Map<String, dynamic> json) =>
      MaintenanceListReqtokens(
        Owner_ID: json["Owner_ID"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
        "Name": Name,
      };
}

class LanloadListReqtokens {
  LanloadListReqtokens({
    this.roles,
    this.Name,
  });

  String? roles;
  String? Name;

  factory LanloadListReqtokens.fromJson(Map<String, dynamic> json) =>
      LanloadListReqtokens(
        roles: json["Roles"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Roles": roles,
        "Name": Name,
      };
}

class PropertyListReqtokens {
  PropertyListReqtokens({
    this.Owner_ID,
    this.Name,
  });

  String? Owner_ID;
  String? Name;

  factory PropertyListReqtokens.fromJson(Map<String, dynamic> json) =>
      PropertyListReqtokens(
        Owner_ID: json["Owner_ID"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
        "Name": Name,
      };
}

class LeadsListReqtokens {
  LeadsListReqtokens({
    this.Owner_ID,
    this.Name,
  });

  String? Owner_ID;
  String? Name;

  factory LeadsListReqtokens.fromJson(Map<String, dynamic> json) =>
      LeadsListReqtokens(
        Owner_ID: json["Owner_ID"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Owner_ID": Owner_ID,
        "Name": Name,
      };
}

class LeadsTenantListReqtokens {
  LeadsTenantListReqtokens({
    this.ApplicationReceived,
    this.Name,
  });

  String? ApplicationReceived;
  String? Name;

  factory LeadsTenantListReqtokens.fromJson(Map<String, dynamic> json) =>
      LeadsTenantListReqtokens(
        ApplicationReceived: json["Application Received"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Application Received": ApplicationReceived,
        "Name": Name,
      };
}

class TenantMaintenanceListReqtokens {
  TenantMaintenanceListReqtokens({
    this.Applicant_ID,
    this.Name,
  });

  String? Applicant_ID;
  String? Name;

  factory TenantMaintenanceListReqtokens.fromJson(Map<String, dynamic> json) =>
      TenantMaintenanceListReqtokens(
        Applicant_ID: json["Applicant_ID"],
        Name: json["Name"],
      );

  Map<String, dynamic> toJson() => {
        "Applicant_ID": Applicant_ID,
        "Name": Name,
      };
}
