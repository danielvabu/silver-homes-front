class MessageModel {
  String? senderName;
  String? sendeId;
  String? senderAvatar;
  String? time;
  String? message;
  String? messageType;
  String? userType;
  bool? isMine;

  MessageModel({
    this.senderName,
    this.sendeId,
    this.senderAvatar,
    this.time,
    this.message,
    this.messageType,
    this.userType,
    this.isMine,
  });

  MessageModel.fromJson(Map<String, dynamic> json) {
    senderName = json['senderName'];
    sendeId = json['sendeId'];
    senderAvatar = json['senderAvatar'];
    time = json['time'];
    message = json['message'];
    messageType = json['messageType'];
    userType = json['userType'];
    isMine = json['isMine'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderName'] = this.senderName;
    data['sendeId'] = this.sendeId;
    data['senderAvatar'] = this.senderAvatar;
    data['time'] = this.time;
    data['message'] = this.message;
    data['messageType'] = this.messageType;
    data['userType'] = this.userType;
    return data;
  }
}
