class ChatModel {
  String? senderName;
  String? sendeId;
  String? senderAvatar;
  String? receiverName;
  String? receiverId;
  String? receiverAvatar;
  String? time;
  String? lastMessage;
  String? messageType;
  String? userSenderType;
  String? userReceiverType;
  String? chatUUID;
  bool? isMine;
  String? propertyName;

  ChatModel({
    this.senderName,
    this.sendeId,
    this.senderAvatar,
    this.receiverName,
    this.receiverId,
    this.receiverAvatar,
    this.time,
    this.lastMessage,
    this.messageType,
    this.userSenderType,
    this.userReceiverType,
    this.chatUUID,
    this.isMine,
    this.propertyName,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    senderName = json['senderName'];
    sendeId = json['sendeId'];
    senderAvatar = json['senderAvatar'];
    receiverName = json['receiverName'];
    receiverId = json['receiverId'];
    receiverAvatar = json['receiverAvatar'];
    time = json['time'];
    lastMessage = json['lastMessage'];
    messageType = json['messageType'];
    userSenderType = json['userSenderType'];
    userReceiverType = json['userReceiverType'];
    chatUUID = json['chatUUID'];
    isMine = json['isMine'];
    propertyName = json['propertyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderName'] = this.senderName;
    data['sendeId'] = this.sendeId;
    data['senderAvatar'] = this.senderAvatar;
    data['receiverName'] = this.receiverName;
    data['receiverId'] = this.receiverId;
    data['receiverAvatar'] = this.receiverAvatar;
    data['time'] = this.time;
    data['lastMessage'] = this.lastMessage;
    data['messageType'] = this.messageType;
    data['userSenderType'] = this.userSenderType;
    data['userReceiverType'] = this.userReceiverType;
    data['chatUUID'] = this.chatUUID;
    data['isMine'] = this.isMine;
    data['propertyName'] = this.propertyName;
    return data;
  }
}
