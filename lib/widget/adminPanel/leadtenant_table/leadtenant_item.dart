import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';
import 'package:silverhome/domain/entities/leadtenantdata.dart';
import 'package:silverhome/widget/adminPanel/landlord_leadtenant/landlordleadtenant_item.dart';

typedef VoidCallViewAccount = void Function(LeadTenantData data);

class LeadTenantItem extends StatefulWidget {
  List<LeadTenantData> listdata;
  final VoidCallDetails _callbackDetails;
  final VoidCallDetails _callbackPropertyDetails;
  final VoidCallViewAccount _callbackViewLandlordAccount;

  LeadTenantItem({
    required List<LeadTenantData> listdata1,
    required VoidCallDetails onPressDetails,
    required VoidCallDetails onPressPropertyDetails,
    required VoidCallViewAccount onPresseViewLandlordAccount,
  })  : listdata = listdata1,
        _callbackDetails = onPressDetails,
        _callbackPropertyDetails = onPressPropertyDetails,
        _callbackViewLandlordAccount = onPresseViewLandlordAccount;

  @override
  _LeadTenantItemState createState() => _LeadTenantItemState();
}

class _LeadTenantItemState extends State<LeadTenantItem> {
  double height = 0, width = 0;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height - 70;
    width = MediaQuery.of(context).size.width - 230;

    return Container(
      width: width,
      height: height - 174,
      child: ListviewBuid(widget.listdata),
    );
  }

  Widget ListviewBuid(List<LeadTenantData> listdata) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: myColor.TA_table_header,
        thickness: 0,
        height: 0,
      ),
      scrollDirection: Axis.vertical,
      key: UniqueKey(),
      itemCount: listdata.length,
      itemBuilder: (BuildContext ctxt, int Index) {
        return Column(
          children: [
            Container(
              height: 40,
              color: Index % 2 == 0 ? myColor.TA_dark : myColor.TA_light,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: _tableData(listdata[Index], Index),
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _tableData(LeadTenantData model, int Index) {
    var result = <Widget>[];
    result.add(_datavalueID(model.id.toString()));
    result.add(_datavalueTitle(model));
    result.add(_datavalueEmail(model.email!));
    result.add(_datavaluephoneno(model.mobileNumber!));
    result.add(_datavalueRating(model.rating!));
    result.add(_datavalueApplicationStatus(model));
    result.add(_datavalueLandlord(model));
    result.add(_datavalueProperty(model));
    result.add(_actionPopup(model));
    return result;
  }

  Widget _datavalueID(String text) {
    return Container(
      height: 40,
      width: width / 14,
      padding: EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueTitle(LeadTenantData model) {
    return InkWell(
      onTap: () {
        widget._callbackDetails(model);
      },
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.applicantName!,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueEmail(String text) {
    return Container(
      height: 40,
      width: width / 6,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavaluephoneno(String text) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 40,
        width: width / 9,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: MyStyles.Medium(12, myColor.Circle_main),
        ),
      ),
    );
  }

  Widget _datavalueRating(double rating) {
    return Container(
      height: 40,
      width: width / 12,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: RatingBarIndicator(
        rating: rating,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: myColor.blue,
        ),
        itemCount: 5,
        itemSize: 15.0,
        direction: Axis.horizontal,
      ),
    );
  }

  Widget _datavalueApplicationStatus(LeadTenantData model) {
    return Container(
      height: 40,
      width: width / 8,
      padding: EdgeInsets.only(left: 10),
      alignment: Alignment.centerLeft,
      child: Text(
        model.applicationStatus != null ? model.applicationStatus!.displayValue : "",
        textAlign: TextAlign.center,
        style: MyStyles.Medium(12, myColor.Circle_main),
      ),
    );
  }

  Widget _datavalueLandlord(LeadTenantData model) {
    return InkWell(
      onTap: () {
        widget._callbackViewLandlordAccount(model);
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Text(
          model.landlordName!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: MyStyles.Medium(12, myColor.blue),
        ),
      ),
    );
  }

  Widget _datavalueProperty(LeadTenantData model) {
    return InkWell(
      onTap: () {
        widget._callbackPropertyDetails(model);
      },
      child: Container(
        height: 40,
        width: width / 8,
        padding: EdgeInsets.only(left: 10),
        alignment: Alignment.centerLeft,
        child: Tooltip(
          message: model.propertyName!,
          child: Text(
            model.propertyName!,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: MyStyles.Medium(12, myColor.blue),
          ),
        ),
      ),
    );
  }

  Widget _actionPopup(LeadTenantData model) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 28,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: PopupMenuButton(
          onSelected: (value) {
            widget._callbackDetails(model);
          },
          child: Container(
            height: 40,
            width: 20,
            margin: EdgeInsets.only(right: 5),
            child: Icon(Icons.more_vert),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text(
                GlobleString.ALL_action_ViewDetails,
                style: MyStyles.Medium(14, myColor.text_color),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
