import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:silverhome/common/globlestring.dart';
import 'package:silverhome/common/mycolor.dart';
import 'package:silverhome/common/mystyles.dart';

import '../alert_dialogbox.dart';

typedef SaveCallback = void Function(double rating, String ratingraview);

class RatingUpdateDialogBox extends StatefulWidget {
  final String title;
  final String ratingcomment;
  double Ratingset;
  final String positiveText;
  final SaveCallback _callbackYes;
  final VoidCallback _callbackNo;

  RatingUpdateDialogBox({
    required String title,
    required String ratingcomment,
    required double ratingset,
    required String positiveText,
    required SaveCallback onPressedYes,
    required VoidCallback onPressedNo,
  })  : title = title,
        ratingcomment = ratingcomment,
        Ratingset = ratingset,
        positiveText = positiveText,
        _callbackYes = onPressedYes,
        _callbackNo = onPressedNo;

  @override
  _RatingUpdateDialogBoxState createState() => _RatingUpdateDialogBoxState();
}

class _RatingUpdateDialogBoxState extends State<RatingUpdateDialogBox> {
  final _textReatingReview = TextEditingController();

  @override
  void initState() {
    _textReatingReview.text = widget.ratingcomment;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
                minWidth: 600, maxWidth: 600, minHeight: 380, maxHeight: 380),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.0),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  color: Colors.white),
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          GlobleString.DLR_Update_Rating,
                          style: MyStyles.Medium(20, myColor.text_color),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                barrierColor: Colors.black45,
                                useSafeArea: true,
                                barrierDismissible: false,
                                builder: (BuildContext context1) {
                                  return AlertDialogBox(
                                    title: GlobleString.DLR_Update_Rating_msg,
                                    positiveText:
                                        GlobleString.DLR_Update_Rating_yes,
                                    negativeText:
                                        GlobleString.DLR_Update_Rating_NO,
                                    onPressedYes: () {
                                      Navigator.of(context1).pop();
                                    },
                                    onPressedNo: () {
                                      Navigator.of(context1).pop();
                                      widget._callbackNo();
                                    },
                                  );
                                },
                              );
                            },
                            child: const Icon(Icons.clear, size: 25),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              GlobleString.DLR_General_Rating,
                              style: MyStyles.Medium(14, myColor.text_color),
                            ),
                            const SizedBox(height: 10.0),
                            RatingBar.builder(
                              initialRating: widget.Ratingset,
                              allowHalfRating: false,
                              glow: false,
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: myColor.blue,
                              ),
                              onRatingUpdate: (rating) {
                                widget.Ratingset = rating;
                                setState(() {});
                              },
                              itemCount: 5,
                              itemSize: 25.0,
                              unratedColor: myColor.TA_Border,
                              direction: Axis.horizontal,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  GlobleString.Notes,
                                  style:
                                      MyStyles.Medium(14, myColor.text_color),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(width: 10.0),
                                Text(
                                  GlobleString.Optional,
                                  style: MyStyles.Medium(10, myColor.optional),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            TextField(
                              controller: _textReatingReview,
                              textAlign: TextAlign.start,
                              style: MyStyles.Medium(14, myColor.text_color),
                              maxLines: 6,
                              decoration: InputDecoration(
                                  //border: InputBorder.none,
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: myColor.gray, width: 1.0),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: myColor.gray, width: 1.0),
                                  ),
                                  isDense: true,
                                  hintText: GlobleString.DLR_hint_notes_here,
                                  hintStyle:
                                      MyStyles.Regular(12, myColor.hintcolor),
                                  contentPadding: const EdgeInsets.all(10),
                                  fillColor: myColor.white,
                                  filled: true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          /* if (widget.Ratingset == 0) {
                            ToastUtils.showCustomToast(context, GlobleString.NL_error_Rating, false);
                          } else {
                            widget._callbackYes(widget.Ratingset, _textReatingReview.text.toString().trim());
                          }*/

                          widget._callbackYes(widget.Ratingset,
                              _textReatingReview.text.toString().trim());
                        },
                        child: Container(
                          height: 35,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            color: myColor.Circle_main,
                            border: Border.all(
                                color: myColor.Circle_main, width: 1),
                          ),
                          child: Text(
                            widget.positiveText,
                            style: MyStyles.Medium(14, myColor.white),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
