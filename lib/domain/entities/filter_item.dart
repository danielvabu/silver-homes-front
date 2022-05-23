class FilterPropertyItem {
  String? propertyId;
  String? propertyName;
  bool? isSelected = false;

  FilterPropertyItem({
    this.propertyId,
    this.propertyName,
    this.isSelected,
  });

  factory FilterPropertyItem.fromJson(Map<String?, dynamic> json) =>
      FilterPropertyItem(
        propertyId: json["propertyId"],
        propertyName: json["propertyName"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "propertyId": propertyId,
        "propertyName": propertyName,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["propertyId"] = propertyId;
    map["propertyName"] = propertyName;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterCityItem {
  String? cityName;
  bool? isSelected = false;

  FilterCityItem({
    this.cityName,
    this.isSelected,
  });

  factory FilterCityItem.fromJson(Map<String?, dynamic> json) => FilterCityItem(
        cityName: json["cityName"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "cityName": cityName,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["cityName"] = cityName;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterRatingItem {
  int? rating;
  int? ratingvalue;
  bool? isSelected = false;

  FilterRatingItem({
    this.rating,
    this.ratingvalue,
    this.isSelected,
  });

  factory FilterRatingItem.fromJson(Map<String?, dynamic> json) =>
      FilterRatingItem(
        rating: json["rating"],
        ratingvalue: json["ratingvalue"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "rating": rating,
        "ratingvalue": ratingvalue,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["rating"] = rating;
    map["ratingvalue"] = ratingvalue;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterApplicationReceived {
  String? apprecId;
  String? apprecName;
  bool? isSelected = false;

  FilterApplicationReceived({
    this.apprecId,
    this.apprecName,
    this.isSelected,
  });

  factory FilterApplicationReceived.fromJson(Map<String?, dynamic> json) =>
      FilterApplicationReceived(
        apprecId: json["apprecId"],
        apprecName: json["apprecName"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "apprecId": apprecId,
        "apprecName": apprecName,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["apprecId"] = apprecId;
    map["apprecName"] = apprecName;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterNumberOfOccupants {
  String? noName;
  String? noValue;
  bool? isSelected = false;

  FilterNumberOfOccupants({
    this.noName,
    this.noValue,
    this.isSelected,
  });

  factory FilterNumberOfOccupants.fromJson(Map<String?, dynamic> json) =>
      FilterNumberOfOccupants(
        noName: json["noName"],
        noValue: json["noValue"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "noName": noName,
        "noValue": noValue,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["noName"] = noName;
    map["noValue"] = noValue;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterPets {
  bool? petsValue;
  String? petsName;
  bool? isSelected = false;

  FilterPets({
    this.petsValue,
    this.petsName,
    this.isSelected,
  });

  factory FilterPets.fromJson(Map<String?, dynamic> json) => FilterPets(
        petsValue: json["petsValue"],
        petsName: json["petsName"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "petsValue": petsValue,
        "petsName": petsName,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["petsValue"] = petsValue;
    map["petsName"] = petsName;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterSmoking {
  bool? smokingValue;
  String? smokingName;
  bool? isSelected = false;

  FilterSmoking({
    this.smokingValue,
    this.smokingName,
    this.isSelected,
  });

  factory FilterSmoking.fromJson(Map<String?, dynamic> json) => FilterSmoking(
        smokingValue: json["smokingValue"],
        smokingName: json["smokingName"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "smokingValue": smokingValue,
        "smokingName": smokingName,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["smokingValue"] = smokingValue;
    map["smokingName"] = smokingName;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterVehical {
  String? vehicalName;
  bool? vehicalValue;
  bool? isSelected = false;

  FilterVehical({
    this.vehicalName,
    this.vehicalValue,
    this.isSelected,
  });

  factory FilterVehical.fromJson(Map<String?, dynamic> json) => FilterVehical(
        vehicalName: json["vehicalName"],
        vehicalValue: json["vehicalValue"],
        isSelected: json["isSelected"],
      );

  Map toJson() => {
        "vehicalName": vehicalName,
        "vehicalValue": vehicalValue,
        "isSelected": isSelected,
      };

  Map toMap() {
    var map = new Map<String?, dynamic>();
    map["vehicalName"] = vehicalName;
    map["vehicalValue"] = vehicalValue;
    map["isSelected"] = isSelected;
    return map;
  }
}

class FilterData {
  String? DSQID;
  bool? LoadLookupValues;
  bool? LoadRecordInfo;
  FilterReqtokens? Reqtokens;

  FilterData({
    this.DSQID,
    this.LoadLookupValues,
    this.LoadRecordInfo,
    this.Reqtokens,
  });

  factory FilterData.fromJson(Map<String?, dynamic> json) => FilterData(
        DSQID: json["DSQID"],
        LoadLookupValues: json["LoadLookupValues"],
        LoadRecordInfo: json["LoadRecordInfo"],
        Reqtokens: FilterReqtokens.fromJson(json["Reqtokens"]),
      );

  Map toJson() => {
        "DSQID": DSQID,
        "LoadLookupValues": LoadLookupValues,
        "LoadRecordInfo": LoadRecordInfo,
        "Reqtokens": Reqtokens!.toJson(),
      };
}

class FilterReqtokens {
  String? Owner_ID;
  String? Prop_ID;
  String? City;
  String? Rating;
  String? ApplicationReceived;
  String? ApplicationStatus;
  String? EmploymentStatus;
  String? AnnualIncome;
  String? NumberofOccupants;
  String? Pets;
  String? Smoking;
  String? Vehicle;
  String? IsArchived;

  FilterReqtokens({
    this.Owner_ID,
    this.Prop_ID,
    this.City,
    this.Rating,
    this.ApplicationReceived,
    this.ApplicationStatus,
    this.EmploymentStatus,
    this.AnnualIncome,
    this.NumberofOccupants,
    this.Pets,
    this.Smoking,
    this.Vehicle,
    this.IsArchived,
  });

  factory FilterReqtokens.fromJson(Map<String?, dynamic> json) =>
      FilterReqtokens(
        Owner_ID: json["Owner_ID"],
        Prop_ID: json["Prop_ID"],
        City: json["City"],
        Rating: json["Rating"],
        ApplicationReceived: json["Application Received"],
        ApplicationStatus: json["ApplicationStatus"],
        EmploymentStatus: json["Employment Status"],
        AnnualIncome: json["Annual Income"],
        NumberofOccupants: json["Number of Occupants"],
        Pets: json["Pets"],
        Smoking: json["Smoking"],
        Vehicle: json["Vehicle"],
        IsArchived: json["IsArchived"],
      );

  Map toJson() {
    var map = new Map<String?, dynamic>();
    if (Owner_ID != null && Owner_ID != "") {
      map["Owner_ID"] = Owner_ID;
    }
    if (Prop_ID != null && Prop_ID != "") {
      map["Prop_ID"] = Prop_ID;
    }
    if (City != null && City != "") {
      map["City"] = City;
    }
    if (Rating != null && Rating != "") {
      map["Rating"] = Rating;
    }
    if (ApplicationReceived != null && ApplicationReceived != "") {
      map["Application Received"] = ApplicationReceived;
    }
    if (ApplicationStatus != null && ApplicationStatus != "") {
      map["ApplicationStatus"] = ApplicationStatus;
    }
    if (EmploymentStatus != null && EmploymentStatus != "") {
      map["Employment Status"] = EmploymentStatus;
    }
    if (AnnualIncome != null && AnnualIncome != "") {
      map["Annual Income"] = AnnualIncome;
    }
    if (NumberofOccupants != null && NumberofOccupants != "") {
      map["Number of Occupants"] = NumberofOccupants;
    }
    if (Pets != null && Pets != "") {
      map["Pets"] = Pets;
    }
    if (Smoking != null && Smoking != "") {
      map["Smoking"] = Smoking;
    }
    if (Vehicle != null && Vehicle != "") {
      map["Vehicle"] = Vehicle;
    }
    if (IsArchived != null && IsArchived != "") {
      map["IsArchived"] = IsArchived;
    }
    return map;
  }
}
