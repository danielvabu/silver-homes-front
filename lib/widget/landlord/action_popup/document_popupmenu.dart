import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackCheckReferences = void Function();
typedef CallbackArchive = void Function();
typedef CallbackEditapplicant = void Function();

class DocumentvarifyPopupMenu extends StatelessWidget {
  bool? isList;
  final CallbackCheckReferences _callbackCheckReferences;
  final CallbackEditapplicant _callbackEditapplicant;
  final CallbackArchive _callbackArchive;

  DocumentvarifyPopupMenu({
    required bool? isListView,
    required CallbackCheckReferences onPressedCheckReferences,
    required CallbackEditapplicant onPressedEditapplicant,
    required CallbackArchive onPressedArchive,
  })  : this.isList = isListView,
        this._callbackCheckReferences = onPressedCheckReferences,
        this._callbackEditapplicant = onPressedEditapplicant,
        this._callbackArchive = onPressedArchive;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackCheckReferences();
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
            GlobleString.FNL_AC_Check_references,
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
