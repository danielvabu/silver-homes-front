import 'dart:typed_data';

class SystemEnumDetails {
  int id;
  int enumID;
  int EnumDetailID;
  String systemValue;
  String displayValue;
  String Sequence;
  bool? ischeck;

  SystemEnumDetails.clone(SystemEnumDetails source)
      : this.id = source.id,
        this.enumID = source.enumID,
        this.EnumDetailID = source.EnumDetailID,
        this.systemValue = source.systemValue,
        this.displayValue = source.displayValue,
        this.Sequence = source.Sequence,
        this.ischeck = source.ischeck;

  SystemEnumDetails({
    required this.id,
    required this.enumID,
    required this.EnumDetailID,
    required this.systemValue,
    required this.displayValue,
    required this.Sequence,
    this.ischeck,
  });

  factory SystemEnumDetails.fromJson(Map<String, dynamic> json) =>
      SystemEnumDetails(
        id: json["ID"] != null ? json["ID"] : 0,
        enumID: json["EnumID"] != null ? json["EnumID"] : 0,
        EnumDetailID: json["EnumDetailID"] != null ? json["EnumDetailID"] : 0,
        systemValue: json["SystemValue"] != null ? json["SystemValue"] : "",
        displayValue: json["DisplayValue"] != null ? json["DisplayValue"] : "",
        Sequence: json["Sequence"] != null ? json["Sequence"] : "",
        ischeck: json["ischeck"] != null ? json["ischeck"] : false,
      );

  Map toJson() => {
        "ID": id,
        "EnumID": enumID,
        "EnumDetailID": EnumDetailID,
        "SystemValue": systemValue,
        "DisplayValue": displayValue,
        'Sequence': Sequence,
        'ischeck': ischeck,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["EnumID"] = enumID;
    map["EnumDetailID"] = EnumDetailID;
    map["SystemValue"] = systemValue;
    map["DisplayValue"] = displayValue;
    map["Sequence"] = Sequence;
    map["ischeck"] = ischeck;
    return map;
  }
}

class EventTypesTemplate {
  int? id;
  String? name;

  EventTypesTemplate({
    this.id,
    this.name,
  });

  factory EventTypesTemplate.fromJson(Map<String, dynamic> json) =>
      EventTypesTemplate(id: json["id"], name: json["name"]);

  Map toJson() => {
        "id": id,
        "name": name,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}

class EventTypesOverride {
  int? id;
  String? name;

  EventTypesOverride({
    this.id,
    this.name,
  });

  factory EventTypesOverride.fromJson(Map<String, dynamic> json) =>
      EventTypesOverride(id: json["id"], name: json["name"]);

  Map toJson() => {
        "id": id,
        "name": name,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    return map;
  }
}

class MyModal {
  int myField1;
  String myField2;
  List<MyModal> adjacentNodes;

  //MyModal(this.myField1,this.myField2);

  MyModal.clone(MyModal source)
      : this.myField1 = source.myField1,
        this.myField2 = source.myField2,
        this.adjacentNodes = source.adjacentNodes
            .map((item) => new MyModal.clone(item))
            .toList();
}

class MediaInfo {
  MediaInfo({
    this.id,
    this.refId,
    this.url,
    this.sequence,
    this.fileType,
    this.isActive,
    this.type,
  });

  int? id;
  int? refId;
  String? url;
  int? sequence;
  int? fileType;
  int? isActive;
  int? type;

  factory MediaInfo.fromJson(Map<String, dynamic> json) => MediaInfo(
        id: json["ID"] != null ? json["ID"] : 0,
        refId: json["RefID"] != null ? json["RefID"] : 0,
        url: json["URL"] != null ? json["URL"] : "",
        sequence: json["Sequence"] != null ? json["Sequence"] : 0,
        fileType: json["FileType"] != null ? json["FileType"] : 0,
        isActive: json["IsActive"] != null ? json["IsActive"] : 0,
        type: json["Type"] != null ? json["Type"] : 0,
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "RefID": refId,
        "URL": url,
        "Sequence": sequence,
        "FileType": fileType,
        "IsActive": isActive,
        "Type": type,
      };
}

class Applicant {
  int id;
  int? personid;
  String? note;
  int? rating;
  bool? ispet;
  bool? isvehical;
  bool? issmoking;
  String? SmokingDesc;
  int? intendedLenth;
  String? intendedTenancyStartDate;
  String? additionalNote;
  String? ratingReview;

  Applicant({
    required this.id,
    this.personid,
    this.note,
    this.rating,
    this.ispet,
    this.isvehical,
    this.issmoking,
    this.SmokingDesc,
    this.intendedLenth,
    this.intendedTenancyStartDate,
    this.additionalNote,
    this.ratingReview,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
        id: json["ID"],
        personid: json["Person_ID"],
        note: json["Note"],
        rating: json["Rating"],
        ispet: json["IsPet"],
        isvehical: json["IsVehicle"],
        issmoking: json["IsSmoking"],
        SmokingDesc: json["SmokingDesc"],
        intendedLenth: json["IntendedLenth"],
        intendedTenancyStartDate: json["IntendedTenancyStartDate"],
        additionalNote: json["AdditionalNote"],
        ratingReview: json["RatingReview"],
      );

  Map toJson() => {
        "ID": id,
        "Person_ID": personid,
        "Note": note,
        "Rating": rating,
        "IsPet": ispet,
        'IsVehicle': isvehical,
        'IsSmoking': issmoking,
        'SmokingDesc': SmokingDesc,
        'IntendedLenth': intendedLenth,
        'IntendedTenancyStartDate': intendedTenancyStartDate,
        'AdditionalNote': additionalNote,
        'RatingReview': ratingReview,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["Person_ID"] = personid;
    map["Note"] = note;
    map["Rating"] = rating;
    map["IsPet"] = ispet;
    map["IsVehicle"] = isvehical;
    map["IsSmoking"] = issmoking;
    map["SmokingDesc"] = SmokingDesc;
    map["IntendedLenth"] = intendedLenth;
    map["IntendedTenancyStartDate"] = intendedTenancyStartDate;
    map["AdditionalNote"] = additionalNote;
    map["RatingReview"] = ratingReview;
    return map;
  }
}

class Application {
  int id;
  int? applicantID;
  bool? isApplicableEmploymentVerification;
  bool? isApplicableCreditRecords;
  int? ApplicationStatus;
  int? DocReviewStatus;
  int? LeaseStatus;
  String? ApplicationSentDate;
  String? ApplicationReceivedDate;
  String? DocRequestSentDate;
  String? DocReceivedDate;
  String? AgreementSentDate;
  String? AgreementReceivedDate;
  bool? IsAuthorized;
  bool? IsAgreedTerms;
  int? ReferenceStatus;
  String? ReferenceRequestSentDate;
  String? ReferenceRequestReceivedDate;
  String? PropID;

  Application({
    required this.id,
    this.applicantID,
    this.isApplicableEmploymentVerification,
    this.isApplicableCreditRecords,
    this.ApplicationStatus,
    this.DocReviewStatus,
    this.LeaseStatus,
    this.ApplicationSentDate,
    this.ApplicationReceivedDate,
    this.DocRequestSentDate,
    this.DocReceivedDate,
    this.AgreementSentDate,
    this.AgreementReceivedDate,
    this.IsAuthorized,
    this.IsAgreedTerms,
    this.ReferenceStatus,
    this.ReferenceRequestSentDate,
    this.ReferenceRequestReceivedDate,
    this.PropID,
  });

  factory Application.fromJson(Map<String, dynamic> json) => Application(
        id: json["ID"],
        applicantID: json["Applicant_ID"],
        isApplicableEmploymentVerification:
            json["isApplicableEmploymentVerification"],
        isApplicableCreditRecords: json["isApplicableCreditRecords"],
        ApplicationStatus: json["ApplicationStatus"],
        DocReviewStatus: json["DocReviewStatus"],
        LeaseStatus: json["LeaseStatus"],
        ApplicationSentDate: json["ApplicationSentDate"],
        ApplicationReceivedDate: json["ApplicationReceivedDate"],
        DocRequestSentDate: json["DocRequestSentDate"],
        DocReceivedDate: json["DocReceivedDate"],
        AgreementSentDate: json["AgreementSentDate"],
        AgreementReceivedDate: json["AgreementReceivedDate"],
        IsAuthorized: json["IsAuthorized"],
        IsAgreedTerms: json["IsAgreedTerms"],
        ReferenceStatus: json["ReferenceStatus"],
        ReferenceRequestSentDate: json["ReferenceRequestSentDate"],
        ReferenceRequestReceivedDate: json["ReferenceRequestReceivedDate"],
        PropID: json["Prop_ID"],
      );

  Map toJson() => {
        "ID": id,
        "Applicant_ID": applicantID,
        "isApplicableEmploymentVerification":
            isApplicableEmploymentVerification,
        "isApplicableCreditRecords": isApplicableCreditRecords,
        "ApplicationStatus": ApplicationStatus,
        "DocReviewStatus": DocReviewStatus,
        "LeaseStatus": LeaseStatus,
        "ApplicationSentDate": ApplicationSentDate,
        "ApplicationReceivedDate": ApplicationReceivedDate,
        "DocRequestSentDate": DocRequestSentDate,
        "DocReceivedDate": DocReceivedDate,
        "AgreementSentDate": AgreementSentDate,
        "AgreementReceivedDate": AgreementReceivedDate,
        "IsAuthorized": IsAuthorized,
        "IsAgreedTerms": IsAgreedTerms,
        "ReferenceStatus": ReferenceStatus,
        "ReferenceRequestSentDate": ReferenceRequestSentDate,
        "ReferenceRequestReceivedDate": ReferenceRequestSentDate,
        "Prop_ID": PropID,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["Applicant_ID"] = applicantID;
    map["isApplicableEmploymentVerification"] =
        isApplicableEmploymentVerification;
    map["isApplicableCreditRecords"] = isApplicableCreditRecords;
    map["DocReviewStatus"] = DocReviewStatus;
    map["LeaseStatus"] = LeaseStatus;
    map["ApplicationSentDate"] = ApplicationSentDate;
    map["ApplicationReceivedDate"] = ApplicationReceivedDate;
    map["DocRequestSentDate"] = DocRequestSentDate;
    map["DocReceivedDate"] = DocReceivedDate;
    map["AgreementSentDate"] = AgreementSentDate;
    map["AgreementReceivedDate"] = AgreementReceivedDate;
    map["IsAuthorized"] = IsAuthorized;
    map["IsAgreedTerms"] = IsAgreedTerms;
    map["ReferenceStatus"] = ReferenceStatus;
    map["ReferenceRequestSentDate"] = ReferenceRequestSentDate;
    map["ReferenceRequestReceivedDate"] = ReferenceRequestSentDate;
    map["Prop_ID"] = PropID;
    return map;
  }
}

class ApplicationDocument {
  int id;
  int? applicantionid;
  int? mediaID;

  ApplicationDocument({
    required this.id,
    this.applicantionid,
    this.mediaID,
  });

  factory ApplicationDocument.fromJson(Map<String, dynamic> json) =>
      ApplicationDocument(
        id: json["ID"],
        applicantionid: json["Applicantion_ID"],
        mediaID: json["Media_ID"],
      );

  Map toJson() => {
        "ID": id,
        "Applicantion_ID": applicantionid,
        "Media_ID": mediaID,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["Applicantion_ID"] = applicantionid;
    map["Media_ID"] = mediaID;
    return map;
  }
}

class Attachments {
  int id;
  int? filePath;
  int? fileName;
  int? fileExtension;
  int? attchmentType;

  Attachments({
    required this.id,
    this.filePath,
    this.fileName,
    this.fileExtension,
    this.attchmentType,
  });

  factory Attachments.fromJson(Map<String, dynamic> json) => Attachments(
        id: json["ID"],
        filePath: json["FilePath"],
        fileName: json["FileName"],
        fileExtension: json["FileExtension"],
        attchmentType: json["AttchmentType"],
      );

  Map toJson() => {
        "ID": id,
        "FilePath": filePath,
        "FileName": fileName,
        "FileExtension": fileExtension,
        "AttchmentType": attchmentType,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["FilePath"] = filePath;
    map["FileName"] = fileName;
    map["FileExtension"] = fileExtension;
    map["AttchmentType"] = attchmentType;
    return map;
  }
}

class Person {
  int id;
  String? FirstName;
  String? MiddleName;
  String? LastName;
  String? DOB;
  int? Gender;
  int? EmploymentStatus;
  int? Status;
  String? Email;
  String? MobileNumber;
  String? Country;
  String? City;

  Person({
    required this.id,
    this.FirstName,
    this.MiddleName,
    this.LastName,
    this.DOB,
    this.Gender,
    this.EmploymentStatus,
    this.Status,
    this.Email,
    this.MobileNumber,
    this.Country,
    this.City,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["ID"],
        FirstName: json["FirstName"],
        MiddleName: json["MiddleName"],
        LastName: json["LastName"],
        DOB: json["DOB"],
        Gender: json["Gender"],
        EmploymentStatus: json["EmploymentStatus"],
        Status: json["Status"],
        Email: json["Email"],
        MobileNumber: json["MobileNumber"],
        Country: json["Country"],
        City: json["City"],
      );

  Map toJson() => {
        "ID": id,
        "FirstName": FirstName,
        "MiddleName": MiddleName,
        "LastName": LastName,
        "DOB": DOB,
        "Gender": Gender,
        "EmploymentStatus": EmploymentStatus,
        "Status": Status,
        "Email": Email,
        "MobileNumber": MobileNumber,
        "Country": Country,
        "City": City,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["FirstName"] = FirstName;
    map["MiddleName"] = MiddleName;
    map["LastName"] = LastName;
    map["DOB"] = DOB;
    map["Gender"] = Gender;
    map["EmploymentStatus"] = EmploymentStatus;
    map["Status"] = Status;
    map["Email"] = Email;
    map["MobileNumber"] = MobileNumber;
    map["Country"] = Country;
    map["City"] = City;
    return map;
  }
}

class PropertyDocument {
  int? propid;
  int? id;
  int? mediaid;

  PropertyDocument({
    this.propid,
    this.id,
    this.mediaid,
  });

  factory PropertyDocument.fromJson(Map<String, dynamic> json) =>
      PropertyDocument(
        propid: json["Prop_ID"],
        id: json["ID"],
        mediaid: json["Media_ID"],
      );

  Map toJson() => {
        "Prop_ID": propid,
        "ID": id,
        "Media_ID": mediaid,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["Prop_ID"] = propid;
    map["ID"] = id;
    map["Media_ID"] = mediaid;
    return map;
  }
}

class ReferenceAnswers {
  int? id;
  int? additionalReferencesID;
  int? lengthOfTenancy;
  int? reasonForDeparture;
  int? cleanliness;
  int? communication;
  int? respectfulness;
  int? paymentPunctuality;
  bool? isRecommendedTenant;
  String? otherComments;

  ReferenceAnswers({
    this.id,
    this.additionalReferencesID,
    this.lengthOfTenancy,
    this.reasonForDeparture,
    this.cleanliness,
    this.communication,
    this.respectfulness,
    this.paymentPunctuality,
    this.isRecommendedTenant,
    this.otherComments,
  });

  factory ReferenceAnswers.fromJson(Map<String, dynamic> json) =>
      ReferenceAnswers(
        id: json["ID"],
        additionalReferencesID: json["AdditionalReferencesID"],
        lengthOfTenancy: json["Length_Of_Tenancy"],
        reasonForDeparture: json["Reason_For_Departure"],
        cleanliness: json["Cleanliness"],
        communication: json["Communication"],
        respectfulness: json["Respectfulness"],
        paymentPunctuality: json["PaymentPunctuality"],
        isRecommendedTenant: json["IsRecommendedTenant"],
        otherComments: json["OtherComments"],
      );

  Map toJson() => {
        "ID": id,
        "AdditionalReferencesID": additionalReferencesID,
        "Length_Of_Tenancy": lengthOfTenancy,
        "Reason_For_Departure": reasonForDeparture,
        "Cleanliness": cleanliness,
        "Communication": communication,
        "Respectfulness": respectfulness,
        "PaymentPunctuality": paymentPunctuality,
        "IsRecommendedTenant": isRecommendedTenant,
        "OtherComments": otherComments,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["ID"] = id;
    map["AdditionalReferencesID"] = additionalReferencesID;
    map["Length_Of_Tenancy"] = lengthOfTenancy;
    map["Reason_For_Departure"] = reasonForDeparture;
    map["Cleanliness"] = cleanliness;
    map["Communication"] = communication;
    map["Respectfulness"] = respectfulness;
    map["PaymentPunctuality"] = paymentPunctuality;
    map["IsRecommendedTenant"] = isRecommendedTenant;
    map["OtherComments"] = otherComments;
    return map;
  }
}

class PropertyImageMediaInfo {
  PropertyImageMediaInfo({
    this.id,
    this.refId,
    this.url,
    this.sequence,
    this.fileType,
    this.isActive,
    this.type,
    this.appImage,
    this.islive,
    this.ishover,
    this.ImageID,
    this.IsFavorite,
  });

  int? id;
  int? refId;
  String? url;
  int? sequence;
  int? fileType;
  int? isActive;
  int? type;
  Uint8List? appImage;
  bool? islive;
  bool? ishover;
  String? ImageID;
  bool? IsFavorite;
  String? fileName;

  factory PropertyImageMediaInfo.fromJson(Map<String, dynamic> json) =>
      PropertyImageMediaInfo(
        id: json["ID"] != null ? json["ID"] : 0,
        refId: json["RefID"] != null ? json["RefID"] : 0,
        url: json["URL"] != null ? json["URL"] : "",
        sequence: json["Sequence"] != null ? json["Sequence"] : 0,
        fileType: json["FileType"] != null ? json["FileType"] : 0,
        isActive: json["IsActive"] != null ? json["IsActive"] : 0,
        type: json["Type"] != null ? json["Type"] : 0,
        appImage: json["appImage"] != null ? json["appImage"] : null,
        islive: json["islive"] != null ? json["islive"] : false,
        ishover: json["ishover"] != null ? json["ishover"] : false,
        ImageID: json["ImageID"] != null ? json["ImageID"] : "",
        IsFavorite: json["IsFavorite"] != null ? json["IsFavorite"] : false,
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "RefID": refId,
        "URL": url,
        "Sequence": sequence,
        "FileType": fileType,
        "IsActive": isActive,
        "Type": type,
        "appImage": appImage,
        "islive": islive,
        "ishover": ishover,
        "ImageID": ImageID,
        "IsFavorite": IsFavorite,
      };
}
