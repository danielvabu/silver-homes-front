import 'package:flutter/material.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

typedef CallbackActivateTenant = void Function();
typedef CallbackArchive = void Function();
typedef CallbackEditapplicant = void Function();
typedef CallbackPreviewLease = void Function();

class LeasesentPopupMenu extends StatelessWidget {
  final bool? isList;
  final String? agreementReceivedDate;
  final CallbackActivateTenant _callbackActivateTenant;
  final CallbackEditapplicant _callbackEditapplicant;
  final CallbackArchive _callbackArchive;
  final CallbackPreviewLease _callbackPreviewLease;

  LeasesentPopupMenu({
    required bool? isListView,
    required String? agreementReceivedDate,
    required CallbackActivateTenant onPressedActivateTenant,
    required CallbackEditapplicant onPressedEditapplicant,
    required CallbackArchive onPressedArchive,
    required CallbackPreviewLease onPressedPreviewLease,
  })  : this.isList = isListView,
        this.agreementReceivedDate = agreementReceivedDate,
        this._callbackActivateTenant = onPressedActivateTenant,
        this._callbackEditapplicant = onPressedEditapplicant,
        this._callbackArchive = onPressedArchive,
        this._callbackPreviewLease = onPressedPreviewLease;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) {
        if (value == 1) {
          _callbackActivateTenant();
        } else if (value == 2) {
          _callbackEditapplicant();
        } else if (value == 3) {
          _callbackArchive();
        } else if (value == 4) {
          _callbackPreviewLease();
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
            GlobleString.FNL_AC_Activate_tenant,
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
        if (isList! && agreementReceivedDate != "")
          PopupMenuItem(
            value: 4,
            child: Text(
              GlobleString.FNL_AC_Preview_Lease,
              style: MyStyles.Medium(14, myColor.text_color),
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }
}
