import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Dimodo/common/styles.dart';

class BaumannTestIntro extends StatefulWidget {
  @override
  _BaumannTestIntroState createState() => _BaumannTestIntroState();
}

class _BaumannTestIntroState extends State<BaumannTestIntro> {
  Size screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: kLightYellow,
        appBar: AppBar(
          elevation: 0,
          // expandedHeight: screenSize.height * 0.3,
          brightness: Brightness.light,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 30,
              child: IconButton(
                icon: CommonIcons.arrowBackward,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          height: screenSize.height,
          width: screenSize.width,
          child: Column(
            children: <Widget>[
              Container(
                  width: screenSize.width,
                  height: screenSize.height / 2.5,
                  child: Column(children: <Widget>[
                    Text("Bom"),
                    Text("Bom"),
                    SvgPicture.asset("assets/icons/clean-face-girl.svg")
                  ])),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 70,
                        decoration: BoxDecoration(
                          color: kLightYellow,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Text("Read to get the best skin ever?"),
                          ],
                        ),
                      ),
                      Text("After this test, you will get: "),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/icons/yellow-smiley-face.svg"),
                          Text("After this test, you will get: "),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/icons/yellow-smiley-face.svg"),
                          Text("After this test, you will get: "),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/icons/yellow-smiley-face.svg"),
                          Text("After this test, you will get: "),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SvgPicture.asset(
                              "assets/icons/yellow-smiley-face.svg"),
                          Text("After this test, you will get: "),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
