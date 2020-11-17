import 'package:Dimodo/common/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneratingOneRowList extends StatefulWidget {
  @override
  _GeneratingOneRowListState createState() => _GeneratingOneRowListState();
}

class _GeneratingOneRowListState extends State<GeneratingOneRowList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = screenSize.width / 3;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 9.0, right: 9, bottom: 22),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          const SizedBox(height: 12),
          ListView.separated(
              separatorBuilder: (context, index) => Container(height: 10),
              addAutomaticKeepAlives: true,
              padding: EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: 4,
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: screenSize.width,
                  height: widthContent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                        child: Container(
                          width: widthContent,
                          height: widthContent,
                          color: kLightPink,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: EdgeInsets.only(left: 7.0, right: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                height: 44,
                                width: 144,
                                padding: EdgeInsets.only(
                                    left: 14, right: 14, bottom: 8),
                                color: kLightPink,
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: 68,
                                color: kLightPink,
                                height: 23,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                              child: Container(
                                width: 37,
                                color: kLightPink,
                                height: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }
}
