import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';

class TipsCard extends StatefulWidget {
  const TipsCard({
    Key key,
    @required this.screenSize,
    @required this.tips,
    @required this.isPositiveTip,
  }) : super(key: key);

  final bool isPositiveTip;
  final Size screenSize;
  final tips;

  @override
  _TipsCardState createState() => _TipsCardState();
}

class _TipsCardState extends State<TipsCard> {
  bool showAll = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showAll = !showAll;
        });
      },
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          // BoxShadow(
          //   color: Colors.grey,
          //   offset: Offset(1.0, 1.0), //(x,y)
          //   blurRadius: 15.0,
          // ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(15)),
        padding: EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 10),
        width: widget.screenSize.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // SizedBox(width: 10),
            for (var i = 0; i < widget.tips.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            !widget.isPositiveTip
                                ? WidgetSpan(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                  )
                                : WidgetSpan(child: Container()),
                            TextSpan(
                              text: widget.isPositiveTip
                                  ? "${i + 1}." + widget.tips[i]["title"]
                                  : widget.tips[i]["title"],
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  showAll
                      ? Text(
                          widget.tips[i]["explanation"] + "\n",
                          style: kBaseTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              color: kDarkAccent.withOpacity(0.7),
                              fontSize: 13),
                        )
                      : Text(
                          "\n",
                          style: kBaseTextStyle.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                ],
              ),

            !showAll
                ? Container(
                    width: widget.screenSize.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Learn More",
                          textAlign: TextAlign.end,
                          style: kBaseTextStyle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: kDarkAccent.withOpacity(0.4),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: kAccentGreen,
                          size: 14,
                        )
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
