import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackSendLease = void Function();
typedef CallbackArchive = void Function();
typedef CallbackEditapplicant = void Function();

class ReferenceCheckPopupMenu extends StatelessWidget {
  bool? isList;
  final CallbackSendLease _callbackSendLease;
  final CallbackEditapplicant _callbackEditapplicant;
  final CallbackArchive _callbackArchive;

  ReferenceCheckPopupMenu({
    required bool? isListView,
    required CallbackSendLease onPressedSendLease,
    required CallbackEditapplicant onPressedEditapplicant,
    required CallbackArchive onPressedArchive,
  })  : this.isList = isListView,
        this._callbackSendLease = onPressedSendLease,
        this._callbackEditapplicant = onPressedEditapplicant,
        this._callbackArchive = onPressedArchive;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackSendLease();
        } else if (value == 2) {
          _callbackEditapplicant();
        } else if (value == 3) {
          _callbackArchive();
        }
      },
      child: Container(
        height: isList! ? 40 : 30,
        width: 20,
        margin: EdgeInsets.only(right: 5),
        child: Icon(Icons.more_vert),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            GlobleString.FNL_AC_Send_lease,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            GlobleString.FNL_AC_Editapplicant,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            GlobleString.FNL_AC_Archive,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
