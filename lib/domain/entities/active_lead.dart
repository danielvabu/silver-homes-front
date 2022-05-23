class ActiveLead {
  String? id;
  String? application_name;
  String? property_name;
  double? rating = 0;
  String? date_sent;
  String? date_receive;
  String? status;
  String? type;
  bool? ischeck;
  bool? isexpand;

  ActiveLead({
    this.id,
    this.application_name,
    this.property_name,
    this.rating,
    this.date_sent,
    this.date_receive,
    this.status,
    this.type,
    this.ischeck,
    this.isexpand,
  });

  factory ActiveLead.fromJson(Map<String, dynamic> json) => ActiveLead(
        id: json["id"],
        application_name: json["application_name"],
        property_name: json["property_name"],
        rating: json["rating"],
        date_sent: json["date_sent"],
        date_receive: json["date_receive"],
        status: json["status"],
        type: json["type"],
        ischeck: json["ischeck"],
        isexpand: json["isexpand"],
      );

  Map toJson() => {
        "id": id,
        "application_name": application_name,
        "property_name": property_name,
        "rating": rating,
        "date_sent": date_sent,
        "date_receive": date_receive,
        "status": status,
        "type": type,
        "ischeck": ischeck,
        "isexpand": isexpand,
      };

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["application_name"] = application_name;
    map["property_name"] = property_name;
    map["rating"] = rating;
    map["date_sent"] = date_sent;
    map["date_receive"] = date_receive;
    map["status"] = status;
    map["type"] = type;
    map["ischeck"] = ischeck;
    map["isexpand"] = isexpand;
    return map;
  }
}
