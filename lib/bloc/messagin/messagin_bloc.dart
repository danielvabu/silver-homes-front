import 'package:rxdart/rxdart.dart';
import 'package:silverhome/presentation/screens/landlord/chat/models/chat_model.dart';
import 'package:silverhome/presentation/screens/landlord/chat/models/message_model.dart';

import 'package:silverhome/validators/validators.dart';

class MessaginBloc with Validators {
  MessaginBloc();
  String currentChatSelected = "";

  ///MessaginBloc

  ///Tab Chats
  final _messageTabController = BehaviorSubject<int>();
  Stream<int> get getMessaginTabTransformer => _messageTabController.stream;
  Function(int) get changeMessaginTab => _messageTabController.sink.add;
  MessaginSubMenuValue() {
    return _messageTabController.value;
  }

  ///loading Messagins
  final _messaginLoading = BehaviorSubject<bool>();
  Stream<bool> get getMessaginLoadingTransformer => _messaginLoading.stream;
  Function(bool) get changeMessaginLoading => _messaginLoading.sink.add;
  openMessaginLoadingValue() {
    return _messaginLoading.value;
  }

  ///currentChat
  final _currentChatController = BehaviorSubject<ChatModel>();
  Stream<ChatModel> get getCurrentChatTransformer =>
      _currentChatController.stream;
  Function(ChatModel) get changeCurrentChat => _currentChatController.sink.add;
  _currentChatValue() {
    return _currentChatController.value;
  }

  ///loading Messagins
  final _newMessageActive = BehaviorSubject<bool>();
  Stream<bool> get getNewMessageActiveTransformer => _newMessageActive.stream;
  Function(bool) get changNewMessageActive => _newMessageActive.sink.add;
  openNewMessageValue() {
    return _newMessageActive.value;
  }

  List<MessageModel> temporaMesagelList = [
    MessageModel(
        message: "Hi, how are you 2",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
    MessageModel(
        message: "Hi, how are you 3",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
    MessageModel(
        message: "Hi, how are you 4",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
    MessageModel(
        message: "",
        messageType: "Divider",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
    MessageModel(
        message: "Hi, how are you 4",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
    MessageModel(
        message: "new messages",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 15",
        userType: "Tenant"),
  ];

  List<ChatModel> temporalChatsList = [
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userSenderType: "Tenant",
        userReceiverType: "Tenant",
        isMine: true,
        receiverAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        receiverAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
    ChatModel(
        lastMessage: "Hey, you",
        messageType: "Text",
        sendeId: "1231312-12313-123-11-213",
        senderAvatar: "https://pbs.twimg.com/media/D8dDZukXUAAXLdY.jpg",
        senderName: "Mauricio M.",
        time: "May 16",
        userReceiverType: "Tenant",
        userSenderType: "Tenant",
        isMine: true,
        propertyName: "BrentWood - unit 100"),
  ];

  dispose() {
    _messageTabController.close();
    _messaginLoading.close();
  }
}
