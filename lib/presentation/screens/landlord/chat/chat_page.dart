import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;
import 'package:provider/provider.dart';
import 'package:silverhome/bloc/bloc.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/presentation/screens/landlord/chat/models/chat_model.dart';
import 'package:silverhome/presentation/screens/landlord/chat/models/message_model.dart';
import 'package:silverhome/widget/searchdropdown/dropdown_search.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  double height = 0, width = 0, ancho = 0;
  bool isFirstCharge = true;
  TextEditingController _searchMessagesController = new TextEditingController();
  TextEditingController _messageController = new TextEditingController();
  ScrollController? scrollChatsController = new ScrollController();
  ScrollController? scrollMessageContainerController = new ScrollController();

  void initState() {
// TODO: implement initState
    super.initState();

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (mounted) {
        _scrollDown();
        timer.cancel();
      } else {
        timer.cancel();
      }
    });
  }

  Widget chatsSection(Bloc bloc) {
    return Container(
      /*  height: height - 70, */
      width: width * .26,
      decoration:
          BoxDecoration(border: Border.all(color: myColor.gray, width: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [headerChats(bloc), scrollChatsSection(bloc)],
      ),
    );
  }

  Widget scrollChatsSection(Bloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [searchBar(), tabAction(bloc), chatsContainer(bloc)],
    );
  }

  Widget headerChats(Bloc bloc) {
    return Container(
        child: ListTile(
      title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text("Messaging")]),
      subtitle: Text(""),
      trailing: Wrap(
        spacing: 12, // space between two icons
        children: <Widget>[
          PopupMenuButton(
            constraints: BoxConstraints(
              maxWidth: width * .25,
              maxHeight: height * .35,
            ),
            shape: Border.all(color: myColor.black),
            onSelected: (value) async {
              switch (value) {
                case 0:
                  break;
                case 1:
                  break;
                default:
              }
            },
            position: PopupMenuPosition.under,
            child: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "Set away message",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          PopupMenuButton(
            constraints: BoxConstraints(
              maxWidth: width * .50,
              maxHeight: height * .35,
            ),
            shape: Border.all(color: myColor.black),
            onSelected: (value) async {
              switch (value) {
                case 0:
                  bloc.messaginBloc.changNewMessageActive(true);
                  bloc.messaginBloc.changeCurrentChat(ChatModel());
                  break;
                case 1:
                  break;
                default:
              }
            },
            position: PopupMenuPosition.under,
            child: Icon(FontAwesomeIcons.envelope), // i,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "New private or group message",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "New bulk message",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Widget searchBar() {
    return Container(
      /*    width: width * .30, */
/*       padding: EdgeInsets.all(5), */
      decoration:
          BoxDecoration(border: Border.all(color: myColor.gray, width: 0.2)),
      child: ListTile(
        title: TextFormField(
          controller: _searchMessagesController,
          onChanged: (value) {},
          onFieldSubmitted: (value) {},
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide:
                  BorderSide(color: myColor.gray.withOpacity(0.2), width: 0.05),
              borderRadius: BorderRadius.circular(2),
            ),
            hintStyle: MyStyles.Medium(14, myColor.hintcolor),
            contentPadding: const EdgeInsets.all(10),
            isDense: true,
            hintText: GlobleString.Messaging_search,
          ),
          style: MyStyles.Medium(14, myColor.text_color),
        ),
        trailing: Container(
          child: PopupMenuButton(
            constraints: BoxConstraints(
              maxWidth: width * .107,
              maxHeight: height * .35,
            ),
            shape: Border.all(color: myColor.black),
            onSelected: (value) async {
              switch (value) {
                case 0:
                  break;
                case 1:
                  break;
                default:
              }
            },
            position: PopupMenuPosition.under,
            child: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text(
                  "All messages",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  GlobleString.Tab_Document_tenants,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  GlobleString.Tab_Document_onwers,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  GlobleString.Tab_Document_vendors,
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Team Members",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
              PopupMenuItem(
                value: 1,
                child: Text(
                  "Unerad",
                  style: MyStyles.Medium(14, myColor.text_color),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    /*     Row(
          children: [
           
            Container(
              margin: EdgeInsets.all(5),
              child: PopupMenuButton(
                constraints: BoxConstraints(
                  maxWidth: width * .107,
                  maxHeight: height * .35,
                ),
                shape: Border.all(color: myColor.black),
                onSelected: (value) async {
                  switch (value) {
                    case 0:
                      break;
                    case 1:
                      break;
                    default:
                  }
                },
                position: PopupMenuPosition.under,
                child: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      "All messages",
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.Tab_Document_tenants,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.Tab_Document_onwers,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      GlobleString.Tab_Document_vendors,
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Team Members",
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      "Unerad",
                      style: MyStyles.Medium(14, myColor.text_color),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )); */
  }

  Widget tabAction(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.messaginBloc.getMessaginTabTransformer,
      initialData: 0,
      builder: (BuildContext context, AsyncSnapshot snapshotTab) {
        return Container(
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      bloc.messaginBloc.changeMessaginTab(0);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: snapshotTab.hasData && snapshotTab.data == 0
                          ? myColor.gray
                          : myColor.white,
                      alignment: Alignment.center,
                      child: Text(
                        "Private/Group",
                        style: TextStyle(
                          color: snapshotTab.hasData && snapshotTab.data == 0
                              ? myColor.white
                              : myColor.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      bloc.messaginBloc.changeMessaginTab(1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      color: snapshotTab.hasData && snapshotTab.data == 0
                          ? myColor.white
                          : myColor.gray,
                      alignment: Alignment.center,
                      child: Text(
                        "Bulk",
                        style: TextStyle(
                            color: snapshotTab.hasData && snapshotTab.data == 0
                                ? myColor.black
                                : myColor.white),
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }

  Widget chatCard(ChatModel model, Bloc bloc, bool isCurrent) {
    return InkWell(
        onTap: () {
          bloc.messaginBloc.changeCurrentChat(model);
          bloc.messaginBloc.changNewMessageActive(false);
        },
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(0),
              elevation: 0,
              shape: Border(
                left: isCurrent
                    ? BorderSide(color: myColor.blue, width: 4)
                    : BorderSide(width: 0, color: Colors.transparent),
                bottom:
                    BorderSide(color: myColor.gray.withOpacity(0.2), width: 1),
              ),
              child: ListTile(
                tileColor:
                    isCurrent ? myColor.blue.withOpacity(.2) : myColor.white,
                leading: Container(
                    /*    margin: EdgeInsets.all(10), */
                    child: CircleAvatar(
                  backgroundImage: NetworkImage(model.senderAvatar!),
                )),
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.senderName!,
                      style: TextStyle(
                          color: myColor.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      model.time!,
                      style: TextStyle(color: myColor.gray, fontSize: 11),
                    ),
                  ],
                ),
                subtitle: Column(children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        model.userSenderType! + " | ",
                        style: TextStyle(
                            color: myColor.blue,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        model.propertyName!,
                        style: TextStyle(color: myColor.gray, fontSize: 12),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        model.lastMessage!,
                        style: TextStyle(color: myColor.gray, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  )
                ]),
              ),
            ),
            SizedBox(
              height: 1,
            )
            /*   Divider() */
          ],
        ));

    /*   
    Container(
      constraints: BoxConstraints(
        maxWidth: width * .25,
      ),
      height: 60,
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.2))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 5,
            color: myColor.blue,
            height: 60,
          ),
          Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(model.senderAvatar!),
                    ),
                  ),
                  Container(
                      constraints: BoxConstraints(
                        maxWidth: width * .20,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.senderName!,
                                style: TextStyle(
                                    color: myColor.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                model.time!,
                                style: TextStyle(
                                    color: myColor.gray, fontSize: 11),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                model.userSenderType! + " | ",
                                style: TextStyle(
                                    color: myColor.blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                model.propertyName!,
                                style: TextStyle(
                                    color: myColor.gray, fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                model.lastMessage!,
                                style: TextStyle(
                                    color: myColor.gray, fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ))
                ],
              ))
        ],
      ),
    ); */
  }

  Widget chatsContainer(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.messaginBloc.getCurrentChatTransformer,
      initialData: bloc.messaginBloc.temporalChatsList.length > 0
          ? bloc.messaginBloc.temporalChatsList[0]
          : null,
      builder: (BuildContext context, AsyncSnapshot snapshotCurrentChat) {
        return Container(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: scrollChatsController,
            child: Container(
              height: height - 187,
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: bloc.messaginBloc.temporalChatsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return chatCard(
                      bloc.messaginBloc.temporalChatsList[index],
                      bloc,
                      snapshotCurrentChat.hasData &&
                              snapshotCurrentChat.data as ChatModel ==
                                  bloc.messaginBloc.temporalChatsList[index]
                          ? true
                          : false);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _scrollDown() {
    scrollMessageContainerController?.animateTo(
      scrollMessageContainerController?.position.maxScrollExtent ?? 0 + 200000,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  Widget messageSection(Bloc bloc) {
    return Expanded(
        child: Container(
      height: height - 35,
      width: width * .69,
      decoration:
          BoxDecoration(border: Border.all(color: myColor.gray, width: 0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          headerMessageSection(bloc),
          StreamBuilder(
            stream: bloc.messaginBloc.getNewMessageActiveTransformer,
            initialData: false,
            builder:
                (BuildContext context, AsyncSnapshot snapshotOpenNewMessage) {
              return snapshotOpenNewMessage.hasData &&
                      snapshotOpenNewMessage.data == true
                  ? Expanded(child: containerNewMessage(bloc))
                  : Expanded(child: containerBubbleMessages(bloc));
            },
          ),
          inputMessage()
        ],
      ),
    ));
  }

  Widget headerMessageSection(Bloc bloc) {
    return StreamBuilder(
      stream: bloc.messaginBloc.getNewMessageActiveTransformer,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot snapshotNewMessage) {
        if (snapshotNewMessage.hasData && snapshotNewMessage.data) {
          return Container(
            child: ListTile(
              title: Text("New message"),
              trailing: Container(
                margin: EdgeInsets.all(5),
                child: PopupMenuButton(
                    constraints: BoxConstraints(
                      /*   maxWidth: width * .107, */
                      maxHeight: height * .35,
                    ),
                    shape: Border.all(color: myColor.black),
                    onSelected: (value) async {
                      switch (value) {
                        case 0:
                          break;
                        case 1:
                          break;
                        default:
                      }
                    },
                    position: PopupMenuPosition.under,
                    child: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 0,
                            child: Text(
                              "Mark as unread",
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Manage settings",
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          PopupMenuItem(
                            value: 1,
                            child: Text(
                              "Mute",
                              style: MyStyles.Medium(14, myColor.text_color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ]),
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "All parties will be able to view the messages.",
                    style: TextStyle(
                        color: myColor.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: myColor.gray, width: 0.2)),
          );
        } else {
          return StreamBuilder(
            stream: bloc.messaginBloc.getCurrentChatTransformer,
            initialData: bloc.messaginBloc.temporalChatsList[0],
            builder: (BuildContext context, AsyncSnapshot snapshotCurrentChat) {
              if (snapshotCurrentChat.hasData) {
                var modelCurrentChat = snapshotCurrentChat.data as ChatModel;
                return Container(
                  child: Container(
                    child: ListTile(
                      title: Text(modelCurrentChat.senderName!),
                      trailing: Container(
                        margin: EdgeInsets.all(5),
                        child: PopupMenuButton(
                            constraints: BoxConstraints(
                              /*   maxWidth: width * .107, */
                              maxHeight: height * .35,
                            ),
                            shape: Border.all(color: myColor.black),
                            onSelected: (value) async {
                              switch (value) {
                                case 0:
                                  break;
                                case 1:
                                  break;
                                default:
                              }
                            },
                            position: PopupMenuPosition.under,
                            child: Icon(Icons.more_vert),
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 0,
                                    child: Text(
                                      "Mark as unread",
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "Manage settings",
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: 1,
                                    child: Text(
                                      "Mute",
                                      style: MyStyles.Medium(
                                          14, myColor.text_color),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ]),
                      ),
                      subtitle: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            modelCurrentChat.userReceiverType! + " | ",
                            style: TextStyle(
                                color: myColor.blue,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            modelCurrentChat.propertyName!,
                            style: TextStyle(color: myColor.gray, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: myColor.gray, width: 0.2)),
                  ),
                );
              } else {
                return SizedBox();
              }
            },
          );
        }
      },
    );
  }

  Widget inputMessage() {
    return Column(
      children: [Divider(), textAreaMessage(), actionBarMessage()],
    );
  }

  Widget containerBubbleMessages(Bloc bloc) {
    return Container(
        /*      height: height - 100, */
        margin: EdgeInsets.all(10),
        width: width * .69,
        child: messageList(bloc));
  }

  Widget filterMessagesCard(String text) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: myColor.white,
          border: Border.all(color: myColor.black),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  Widget containerNewMessage(Bloc bloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            color: myColor.gray.withOpacity(0.1),
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: ListTile(
              title: Text(
                "Filter by the following user groups",
                style: TextStyle(fontSize: 13),
              ),
              subtitle: Row(
                children: [
                  filterMessagesCard("Tenants"),
                  filterMessagesCard("Owners"),
                  filterMessagesCard("Vendors"),
                  filterMessagesCard("Team Members"),
                ],
              ),
            ))
      ],
    );
  }

  Widget messageList(Bloc bloc) {
    return ListView.builder(
      shrinkWrap: true,
      physics: ScrollPhysics(),
      controller: scrollMessageContainerController,
      itemCount: bloc.messaginBloc.temporaMesagelList.length,
      itemBuilder: (BuildContext context, int index) {
        var messageModelTemp = bloc.messaginBloc.temporaMesagelList[index];
        switch (messageModelTemp.messageType) {
          case "Divider":
            return dividerMessages(bloc.messaginBloc.temporaMesagelList[index]);

          case "Text":
            return bubbleMessage(bloc.messaginBloc.temporaMesagelList[index]);
          default:
            return SizedBox();
        }
      },
    );
  }

  Widget bubbleMessage(MessageModel model) {
    return ListTile(
      contentPadding: EdgeInsets.all(8),
      title: Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.senderName!,
                style: TextStyle(
                    color: myColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "  |  ",
                style: TextStyle(color: myColor.gray, fontSize: 11),
              ),
              Text(
                model.time!,
                style: TextStyle(color: myColor.gray, fontSize: 14),
              ),
              doubleCheck()
            ],
          )),
      subtitle: Text(
        model.message!,
        style: TextStyle(
            color: myColor.black, fontSize: 13, fontWeight: FontWeight.w700),
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(model.senderAvatar!),
      ),
    );
  }

  Widget doubleCheck() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.checkDouble,
            color: myColor.gray,
            size: 11,
          ),
        ],
      ),
    );
  }

  Widget dividerMessages(MessageModel model) {
    return Row(children: <Widget>[
      Expanded(child: Divider()),
      Text(
        " MAY 14 ",
        style: TextStyle(fontSize: 12),
      ),
      Expanded(child: Divider()),
    ]);
  }

  Widget textAreaMessage() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(color: myColor.gray.withOpacity(0.2), width: 0.05),
      )),
      height: height * .15,
      padding: EdgeInsets.only(left: 5, top: 5),
      child: TextFormField(
        keyboardType: TextInputType.multiline,
        minLines: 1, //Normal textInputField will be displayed
        maxLines: 5, // when user presses enter it will adapt to it
        controller: _messageController,
        onChanged: (value) {},
        onFieldSubmitted: (value) {},
        decoration: InputDecoration(
          border: InputBorder
              .none /*  OutlineInputBorder(
            borderSide:
                BorderSide(color: myColor.gray.withOpacity(0.2), width: 0.05),
            borderRadius: BorderRadius.circular(2),
          ) */
          ,
          hintStyle: MyStyles.Medium(14, myColor.hintcolor),
          contentPadding: const EdgeInsets.all(10),
          isDense: true,
          hintText: "Write a message..",
        ),
        style: MyStyles.Medium(14, myColor.text_color),
      ),
    );
  }

  Widget actionBarMessage() {
    return ListTile(
        shape: Border(left: BorderSide(color: myColor.blue, width: 2)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(
                FontAwesomeIcons.fileImage,
                size: 18,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(FontAwesomeIcons.paperclip, size: 18),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(FontAwesomeIcons.smile, size: 18),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Icon(FontAwesomeIcons.fileArrowUp, size: 18),
            ),
            Container(
              width: width * .15,
              height: 30,
              child: DropdownSearch<String>(
                mode: Mode.MENU,
                key: UniqueKey(),
                errorcolor: myColor.errorcolor,
                focuscolor: myColor.blue,
                focusWidth: 2,
                popupBackgroundColor: myColor.white,
                items: [],
                textstyle: MyStyles.Medium(14, myColor.text_color),
                hint: "Smart Fields",
                selectedItem: null,
                onChanged: (value) async {},
              ),
            )
          ],
        ),
        /*   title: SizedBox(), */
        trailing: TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(myColor.first_color)),
            onPressed: () {},
            child: Text(
              "Send",
              style: TextStyle(color: Colors.white),
            )));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 240;
    final bloc = Provider.of<Bloc>(context);
    ancho = (width / 100) - 0.1;

    if (isFirstCharge) {
      isFirstCharge = false;
    }
    return Container(
      height: height,
      width: width,
      color: myColor.bg_color1,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                /*  width: width, */
                /*  padding: EdgeInsets.all(10), */
                decoration: BoxDecoration(
                  color: myColor.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      /*   mainAxisSize: MainAxisSize.max, */
                      children: [chatsSection(bloc), messageSection(bloc)],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
