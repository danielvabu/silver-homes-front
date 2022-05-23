import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:html' as html;
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/prefsname.dart';
import 'package:silverhome/common/sharedpref.dart';
import 'package:silverhome/common/toastutils.dart';
import 'package:silverhome/domain/entities/vendordata.dart';
import 'package:silverhome/tablayer/query_filter.dart';
import 'package:silverhome/tablayer/tabclass.dart';
import 'package:silverhome/tablayer/tablePOJO.dart';
import 'package:silverhome/tablayer/weburl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widget/circular_loading_widget.dart';

class Helper {
  late BuildContext context;

  static int noofrecored = 15;

  Helper.of(BuildContext _context) {
    this.context = _context;
  }

  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static Widget notdataimage(String image, double height_width) {
    return Container(
      height: height_width,
      width: height_width,
      decoration: BoxDecoration(
          image: DecorationImage(
        colorFilter: ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn),
        image: AssetImage(image),
        fit: BoxFit.cover,
      )),
    );
  }

  static Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };

  static String getComaseparated(List<String> data) {
    String finallocations = "";

    if (data.length > 0) {
      finallocations = data.join(', ');
    }

    return finallocations;
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.14),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static ShowToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 13.0);
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
          msg: "Could not launch $url",
          backgroundColor: Colors.black,
          textColor: Colors.white);

      throw 'Could not launch $url';
    }
  }

  static urlload(String HomePagelink) async {
    if (HomePagelink != null && HomePagelink.isNotEmpty) {
      if (HomePagelink.contains("http://")) {
        Helper.launchURL(HomePagelink);
      } else if (HomePagelink.contains("https://")) {
        Helper.launchURL(HomePagelink);
      } else {
        String url1 = "http://" + HomePagelink;

        if (await canLaunch(url1)) {
          await launch(url1);
        } else {
          String url2 = "https://" + HomePagelink;

          if (await canLaunch(url2)) {
            await launch(url2);
          } else {
            Fluttertoast.showToast(
                msg: "Could not launch $url2",
                backgroundColor: Colors.black,
                textColor: Colors.white);

            throw 'Could not launch $url2';
          }
        }
      }
    }
  }

  static String fileextension(String name, int? filetye, String url) {
    if (filetye == eMediaFileType().PDF) {
      return name + ".pdf";
    } else if (filetye == eMediaFileType().Image) {
      if (url.contains("png"))
        return name + ".png";
      else if (url.contains("jpg"))
        return name + ".jpg";
      else if (url.contains("jpeg"))
        return name + ".jpeg";
      else
        return name + ".png";
    } else if (filetye == eMediaFileType().Text) {
      return name + ".txt";
    } else if (filetye == eMediaFileType().CSV) {
      return name + ".csv";
    } else if (filetye == eMediaFileType().Excel) {
      return name + ".excel";
    } else if (filetye == eMediaFileType().Word) {
      return name + ".doc";
    } else {
      return "";
    }
  }

  static download(BuildContext context, String url, String Mediaid,
      String filenameold, int? flag) async {
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context)!.insert(loader);

    Helper.Log("filename", filenameold);
    Helper.Log("url", url);

    String filename;

    if (flag == 1) {
      filename = filenameold.replaceRange(0, 18, "");
    } else {
      filename = filenameold;
    }

    Map<String, String> headers = {
      'Accept': 'image/png',
      //"Accept": "application/json",
      'Access-Control-Allow-Origin': "*",
      'Authorization': 'bearer ' + Prefs.getString(PrefsName.userTokan),
      'ApplicationCode': Weburl.API_CODE,
    };

    String apiurl = Weburl.image_API + Mediaid.toString();

    var client = http.Client();
    var response = await client.get(Uri.parse(apiurl), headers: headers);

    if (response.statusCode == 200) {
      //Helper.Log("Responce", response.bodyBytes.toString());

      //final Uint8List ubytes = (response as ByteBuffer).asUint8List();
      final Uint8List ubytes = await response.bodyBytes;

      List<int> bytes = ubytes;
      final _base64 = base64Encode(bytes);

      final anchor = html.AnchorElement(
          href: 'data:application/octet-stream;base64,$_base64')
        ..target = 'blank';
      // add the name
      if (filename != null) {
        anchor.download = filename;
      }
      // trigger download
      document.body!.append(anchor);
      anchor.click();
      loader.remove();
    } else {
      loader.remove();
      ToastUtils.showCustomToast(context, GlobleString.Error_server, false);
    }
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader.remove();
      } catch (e) {}
    });
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  static String DateForMMM(DateTime date) {
    String finaldate = "";

    if (date != null) {
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      finaldate = formatter.format(date);
    }

    return finaldate;
  }

  static String getDateTime(String date) {
    String finaldate = "";

    if (date != null && date != "") {
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      finaldate = formatter.format(DateTime.parse(date));
    }

    return finaldate;
  }

  static String getDateTimeForTimeStem(String timestamp) {
    String finaldate = "";

    if (timestamp != null && timestamp != "") {
      var date =
          DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp) * 1000);

      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      finaldate = formatter.format(DateTime.parse(date.toString()));
    }

    return finaldate;
  }

  static bool ValidEmail(String email) {
    /*  bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;*/

    bool emailValid = EmailValidator.validate(email);
    return emailValid;
  }

  static bool ValidPhonenumber(String number) {
    /*  bool emailValid = RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(email);
    return emailValid;*/

    if (number.length < 14)
      return true;
    else
      return false;
  }

  static bool ValidPhone(String phone) {
    bool PhoneValid = RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(phone);
    return PhoneValid;
  }

  static bool ValidLinkLinedProfile(String url) {
    bool urlValid = RegExp(
            r'((https?:\/\/)?((www|\w\w)\.)?linkedin\.com\/)((([\w]{2,3})?)|([^\/]+\/(([\w|\d-&#?=])+\/?){1,}))$')
        .hasMatch(url);
    return urlValid;
  }

  static bool isAdult2(String birthDateString) {
    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateTime.parse(birthDateString);
    //DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    int yearDiff = today.year - birthDate.year;
    int monthDiff = today.month - birthDate.month;
    int dayDiff = today.day - birthDate.day;

    return yearDiff > 18 || yearDiff == 18 && monthDiff >= 0 && dayDiff >= 0;
  }

  static bool ValidOnlyNumber(String number) {
    //bool onlynumber = RegExp(r'^[0-9]*$').hasMatch(number);
    bool onlynumber = RegExp(r'^[0-9()#+ ]*$').hasMatch(number);
    return onlynumber;
  }

  static bool NoValidSpecialCharacters(String number) {
    bool onlytext = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(number);
    return onlytext;
  }

  static bool isPasswordCompliant(String password) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    // bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
        password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length >= 8;

    //return hasDigits & hasUppercase & hasLowercase & hasSpecialCharacters & hasMinLength;
    return hasDigits & hasUppercase & hasSpecialCharacters & hasMinLength;
  }

  static Size textSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: ui.TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  static List<int> Widgetchild(int count) {
    var result = <int>[];
    for (int i = 0; i < count; i++) {
      result.add(i);
    }

    Helper.Log("Count result", result.length.toString());
    Helper.Log("Count", count.toString());
    return result;
  }

  static Log(String message, String log) async {
    if (Weburl.ShowLog) {
      print(message + " >> " + log);
    }
  }

  static String FileName(String message) {
    if (message != null && message.isNotEmpty) {
      return message.split("/").last.replaceRange(0, 18, "");
    }
    return "";
  }

  static String FileNameWithTime(String message) {
    if (message != null && message.isNotEmpty) {
      return message.split("/").last;
    }
    return "";
  }

  static List<String> PagingRecord(int TotalRecords) {
    var result = <String>[];

    int count = 0;

    if (TotalRecords % noofrecored == 0) {
      count = int.parse((TotalRecords / noofrecored).toString());
    } else {
      double page = (TotalRecords / noofrecored);
      count = (page + 1).toInt();
    }

    for (int i = 0; i < count; i++) {
      result.add((i + 1).toString());
    }

    Helper.Log("Count result", result.length.toString());
    Helper.Log("TotalRecords", TotalRecords.toString());
    return result;
  }

  static copyToClipboardHack(BuildContext context, String text) {
    window.navigator.clipboard!.writeText(text).then((value) {
      Log("copyToClipboardHack", value.toString());
      print("copyToClipboardHack" + value.toString());
      ToastUtils.showCustomToastWithColor(
          context, "Linked Copied", myColor.link_copy);
    });
  }

  // Function to remove duplicates from an ArrayList
  static List<SystemEnumDetails> removeDuplicates(List<VendorData> list) {
    List<SystemEnumDetails> categoryList = [];
    List<int> category = [];

    for (int i = 0; i < list.length; i++) {
      VendorData vendorData = list[i];

      categoryList.add(vendorData.category!);
      category.add(vendorData.category!.EnumDetailID);
    }

    final uniqueNumbers = category.toSet().toList();

    List<SystemEnumDetails> MaintenanceCategorylist =
        QueryFilter().PlainValues(eSystemEnums().Maintenance_Category);

    List<SystemEnumDetails> newList = [];

    for (int i = 0; i < MaintenanceCategorylist.length; i++) {
      SystemEnumDetails systum = MaintenanceCategorylist[i];

      if (uniqueNumbers.contains(systum.EnumDetailID)) {
        newList.add(systum);
      }
    }

    var json = jsonEncode(newList.map((e) => e.toJson()).toList());
    Helper.Log("removeDuplicates categorylist", json);

    return newList;
  }

  static List<VendorData> filtervendor(
      List<VendorData> list, SystemEnumDetails enumdata) {
    List<VendorData> newList = [];

    for (int i = 0; i < list.length; i++) {
      VendorData vendorData = list[i];

      if (vendorData.category != null) {
        if (vendorData.category!.EnumDetailID == enumdata.EnumDetailID) {
          newList.add(vendorData);
        }
      }
    }

    var json = jsonEncode(newList.map((e) => e.toJson()).toList());
    Helper.Log("filtervendor", json);

    return newList;
  }

  static VendorData? filtervendorByID(List<VendorData> list, int id) {
    VendorData? newList = null;

    for (int i = 0; i < list.length; i++) {
      VendorData vendorData = list[i];

      if (vendorData.id == id) {
        newList = vendorData;
        break;
      }
    }

    return newList;
  }

  static String checkNull(String? val) {
    String data = "";
    if (val != null && val.isNotEmpty) {
      data = val;
    }

    return data;
  }

  static double gethightofFeature(int AV, int AVR, int NAV) {
    Helper.Log("AV Count", AV.toString());
    Helper.Log("AVR Count", AVR.toString());
    Helper.Log("NAV Count", NAV.toString());

    double Fheight = 0;
    if (AV >= AVR) {
      if (AV >= NAV) {
        Fheight = double.parse((AV * 19).toString());
      } else {
        Fheight = double.parse((NAV * 19).toString());
      }
    } else {
      if (AVR >= NAV) {
        Fheight = double.parse((AVR * 19).toString());
      } else {
        Fheight = double.parse((NAV * 19).toString());
      }
    }

    if (Fheight == 0) Fheight = 50;

    Helper.Log("Height", Fheight.toString());
    return Fheight + 125;
  }

  static String generate20RandomString() {
    int length = 20;

    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';

    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();

    return randomString;
  }

  static String CopyAddFilename(List<String> namestring, String filename) {
    if (namestring.contains(filename)) {
      String myfilename = "Copy-" + filename;

      return CopyAddFilename(namestring, myfilename);
    } else {
      return filename;
    }
  }
}
