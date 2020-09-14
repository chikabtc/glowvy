import 'package:Dimodo/models/survey.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import '../generated/i18n.dart';

import 'package:Dimodo/common/styles.dart';

class SurveyCard extends StatefulWidget {
  // SurveyWidget
  SurveyCard({this.survey, this.index, this.onTap});
  final Survey survey;
  final int index;
  final Future<dynamic> Function() onTap;

  @override
  _SurveyCardState createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.only(top: 12, left: 16, right: 16),
      child: Wrap(alignment: WrapAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).question + ' ${widget.index + 1}',
                style: kBaseTextStyle.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: kSecondaryYellow)),
            Container(
              height: 11,
            ),
            Text(
              '${widget.survey.question}',
              style: kBaseTextStyle.copyWith(
                  fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Container(
              height: 5,
            ),
            // SizedBox(height: 8),
            for (var i = 0; i < widget.survey.options.length; i++)
              GestureDetector(
                onTap: () => setState(() {
                  widget.onTap();

                  widget.survey.answer = widget.survey.options[i];
                }),
                child: Container(
                  width: screenSize.width,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: Row(
                      children: <Widget>[
                        ClipRRect(
                          clipBehavior: Clip.hardEdge,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          child: Checkbox(
                            activeColor: kPrimaryOrange,
                            value: widget.survey.answer ==
                                widget.survey.options[i],
                            onChanged: (bool value) {
                              setState(() {
                                widget.onTap();

                                widget.survey.answer = widget.survey.options[i];
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${widget.survey.options[i]}',
                            style: kBaseTextStyle.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ]),
    );
  }
}
