import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackRestoreApplicant = void Function();
typedef CallbackEditApplicant = void Function();

class ArchivePopupMenu extends StatelessWidget {
  bool? isList;
  final CallbackRestoreApplicant _callbackRestoreApplicant;
  final CallbackEditApplicant _callbackEditApplicant;

  ArchivePopupMenu({
    required bool? isListView,
    required CallbackRestoreApplicant onPressedRestoreApplicant,
    required CallbackEditApplicant onPressedEditApplicant,
  })  : this.isList = isListView,
        this._callbackRestoreApplicant = onPressedRestoreApplicant,
        this._callbackEditApplicant = onPressedEditApplicant;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackRestoreApplicant();
        } else if (value == 2) {
          _callbackEditApplicant();
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
            GlobleString.FNL_AC_Restore_applicant,
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
      ],
    );
  }
}
