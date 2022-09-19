import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/eventtypeslist.dart';
import 'package:silverhome/store/app_store.dart';
import 'package:silverhome/store/service_locator.dart';
import 'package:silverhome/widget/landlord/scheduling/list_of_attendeesEvent.dart';

typedef VoidCallName = void Function(EventTypesDataList eventtypesData);
typedef VoidCallDetails = void Function(EventTypesDataList eventtypesData);
typedef VoidCallEdit = void Function(EventTypesDataList eventtypesData);
typedef VoidCallDuplicat = void Function(EventTypesDataList eventtypesData);
typedef VoidCallActive = void Function(
    EventTypesDataList eventtypesData, int pos);
typedef VoidCallInActive = void Function(
    EventTypesDataList eventtypesData, int pos);
typedef VoidCallIsPublish = void Function(
    EventTypesDataList eventtypesData, int pos, bool flag);

class EventTypesTemplateItem extends StatefulWidget {
  final VoidCallName _callbackEventTypesName;
  final VoidCallDetails _callbackDetails;
  final VoidCallEdit _callbackEdit;
  final VoidCallDuplicat _callbackDuplicat;
  final VoidCallActive _callbackActive;
  final VoidCallInActive _callbackInActive;
  final VoidCallIsPublish _callbackIsPublish;
  List<EventTypesDataList> listdata;

  EventTypesTemplateItem({
    required List<EventTypesDataList> listdata1,
    required VoidCallName onPressName,
    required VoidCallDetails onPressDetails,
    required VoidCallEdit onPresseEdit,
    required VoidCallDuplicat onPresseDuplicat,
    required VoidCallActive onPresseActive,
    required VoidCallInActive onPresseInActive,
    required VoidCallIsPublish onPresseIsPublish,
  })  : listdata = listdata1,
        _callbackEventTypesName = onPressName,
        _callbackDetails = onPressDetails,
        _callbackEdit = onPresseEdit,
        _callbackDuplicat = onPresseDuplicat,
        _callbackActive = onPresseActive,
        _callbackInActive = onPresseInActive,
        _callbackIsPublish = onPresseIsPublish;

  @override
  _EventTypesTemplateItemState createState() => _EventTypesTemplateItemState();
}

class _EventTypesTemplateItemState extends State<EventTypesTemplateItem> {
  double height = 0, width = 0, parte = 0;

  final _store = getIt<AppStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;
    parte = width / 100;

    return Container(
      width: width,
      height: height - 249,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<EventTypesDataList> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => const Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Container(
          height: 44,
          color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: _tableData(listdata[Index], Index),
          ),
        );
      },
    );
  }

  List<Widget> _tableData(EventTypesDataList model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueColor(model, 2));
    result.add(_datavalueTemplateName(model, 25));
    result.add(_datavalueRelation(model, 10));
    result.add(_datavalueDuration(model, 9));
    result.add(_textTextEmpty(" ", 9)); //Question
    result.add(_textTextEmpty(" ", 9)); //Routing
    result.add(_textTextEmpty(" ", 9)); //Noti
    result.add(_textTextEmpty(" ", 9)); //Reconf
    result.add(_useBoton(model, 4));
    result.add(_actionPopup(model));
    return result;
  }

  Widget _textTextEmpty(String text, int porcent) {
    return Container(
      height: 40,
      width: parte * porcent,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.start,
              style: MyStyles.SemiBold(12, myColor.text_color),
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }

  Widget _datavalueColor(model, int porcent) {
    Map _color1 = {
      "grey": Colors.grey,
      "red": Colors.red,
      "orange": Colors.orange,
      "yellow": Colors.yellow,
      "green": Colors.green,
      "cyan": Colors.cyan,
      "blue": Colors.blue,
      "deepPurple": Colors.deepPurple,
      "purple": Colors.purple,
      "pink": Colors.pink
    };
    return Container(
      height: 40,
      width: parte * porcent,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Icon(
              Icons.circle,
              color: _color1[model.color],
              size: 17.0,
            ),
          ),
          const SizedBox(width: 5.0),
        ],
      ),
    );
  }

  Widget _datavalueTemplateName(EventTypesDataList model, int porcent) {
    return InkWell(
      onTap: () {
        widget._callbackEventTypesName(model);
      },
      child: Container(
        height: 40,
        width: parte * porcent,
        margin: const EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.name!,
          child: Text(
            model.name!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _datavalueRelation(EventTypesDataList model, int porcent) {
    return Container(
      height: 40,
      width: parte * porcent,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.relationship!,
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueDuration(EventTypesDataList model, int porcent) {
    return Container(
      height: 40,
      width: parte * porcent,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        "${model.duration!} Minutes",
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _useBoton(EventTypesDataList model, int porcent) {
    return Container(
      height: 30,
      width: parte * porcent,
      margin: const EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: () {},
        child: _useButton(),
      ),
    );
  }

  Widget _actionPopup(EventTypesDataList model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        margin: const EdgeInsets.only(left: 5, right: 10),
        alignment: Alignment.centerRight,
        child: PopupMenuButton(
          onSelected: (value) {
            if (value == 1) {
              widget._callbackDetails(model);
            } else if (value == 2) {
              widget._callbackEdit(model);
            } else if (value == 3) {
              widget._callbackDuplicat(model);
            }
          },
          child: Container(
            height: 40,
            width: 20,
            margin: const EdgeInsets.only(right: 5),
            child: const Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                GlobleString.PH_ACT_ViewDetails,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 2,
              child: Text(
                GlobleString.PH_ACT_Duplicate,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
            PopupMenuItem(
              value: 3,
              child: Text(
                GlobleString.Mant_action_Delete,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openDialogListAttendees(String id) {
    showDialog(
      context: context,
      barrierColor: Colors.black45,
      useSafeArea: true,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return ListOfAttendeesEvent(id);
      },
    );
  }

  Widget _useButton() {
    return Container(
      height: 32,
      padding: const EdgeInsets.only(left: 5, right: 5),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: myColor.blue,
      ),
      child: Text(
        GlobleString.ET_Use,
        style: MyStyles.Regular(14, myColor.white),
      ),
    );
  }
}
