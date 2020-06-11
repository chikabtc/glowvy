import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class GeneratingProductList extends StatefulWidget {
  @override
  _GeneratingProductListState createState() => _GeneratingProductListState();
}

class _GeneratingProductListState extends State<GeneratingProductList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final widthContent = (screenSize.width / 2);

    return Padding(
      padding: const EdgeInsets.only(left: 7.0, right: 7, bottom: 22),
      child: ListView(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: <Widget>[
          SizedBox(height: 12),
          GridView.builder(
              addAutomaticKeepAlives: true,
              padding: const EdgeInsets.all(0.0),
              shrinkWrap: true,
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.68,
                crossAxisCount: 2,
              ),
              physics: ClampingScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6)),
                        child: Container(
                          width: widthContent,
                          height: widthContent,
                          color: kLightPink,
                        ),
                      ),
                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 7.0, right: 7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 19,
                                    padding: EdgeInsets.only(
                                        left: 14, right: 14, bottom: 8),
                                    color: kLightPink,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 34,
                              color: kLightPink,
                              height: 15,
                            ),
                            SizedBox(height: 8),
                            Container(
                              width: 62,
                              color: kLightPink,
                              height: 20,
                            ),
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
