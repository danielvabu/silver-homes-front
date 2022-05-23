import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackInviteApply = void Function();
typedef CallbackArchive = void Function();
typedef CallbackEditLead = void Function();
typedef CallbackLeadInfo = void Function();

class LeadPopupMenu extends StatelessWidget {
  bool? isList;

  final CallbackInviteApply _callbackInviteApply;
  final CallbackEditLead _callbackEditLead;
  final CallbackLeadInfo _callbackLeadInfo;
  final CallbackArchive _callbackArchive;

  LeadPopupMenu({
    required bool? isListView,
    required CallbackInviteApply onPressedInviteApply,
    required CallbackEditLead onPressedEditLead,
    required CallbackLeadInfo onPressedLeadInfo,
    required CallbackArchive onPressedArchive,
  })  : this.isList = isListView,
        this._callbackInviteApply = onPressedInviteApply,
        this._callbackEditLead = onPressedEditLead,
        this._callbackLeadInfo = onPressedLeadInfo,
        this._callbackArchive = onPressedArchive;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackInviteApply();
        } else if (value == 2) {
          _callbackEditLead();
        } else if (value == 3) {
          _callbackArchive();
        } /*else if (value == 4) {
          _callbackLeadInfo();
        }*/
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
            GlobleString.FNL_AC_InviteApply,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
        /* PopupMenuItem(
          value: 4,
          child: Text(
            GlobleString.FNL_AC_LeadInfo,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),*/
        PopupMenuItem(
          value: 2,
          child: Text(
            GlobleString.FNL_AC_EditLead,
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
