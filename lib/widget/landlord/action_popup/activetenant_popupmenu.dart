import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackEditTenet = void Function();
typedef CallbackArchive = void Function();
typedef CallbackInviteTenant = void Function();

class ActiveTenantPopupMenu extends StatelessWidget {
  bool? isList;
  final CallbackEditTenet _callbackACEditTenet;
  final CallbackArchive _callbackACArchive;
  final CallbackInviteTenant _callbackInviteTenant;

  ActiveTenantPopupMenu({
    required bool? isListView,
    required CallbackEditTenet onPressedACEditTenet,
    required CallbackArchive onPressedACArchive,
    required CallbackInviteTenant onPressedInviteTenant,
  })  : this.isList = isListView,
        this._callbackACEditTenet = onPressedACEditTenet,
        this._callbackACArchive = onPressedACArchive,
        this._callbackInviteTenant = onPressedInviteTenant;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackACEditTenet();
        } else if (value == 2) {
          _callbackACArchive();
        } else if (value == 3) {
          _callbackInviteTenant();
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
          value: 3,
          child: Text(
            GlobleString.FNL_AC_Invite_Tenant,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            GlobleString.FNL_AC_Terminate_Tenancy,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Text(
            GlobleString.FNL_AC_Edit_tenant,
            style: MyStyles.Medium(14, myColor.text_color),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
