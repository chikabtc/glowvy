import 'package:Dimodo/common/styles.dart';

import 'package:Dimodo/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/app.dart';
import 'package:Dimodo/widgets/customWidgets.dart';

class Language extends StatefulWidget {
  @override
  _LanguageState createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).language,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: kPinkAccent,
        leading: Center(
          child: GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: ListTile(
              leading: Image.asset(
                'assets/images/country/gb.png',
                width: 30,
                height: 20,
                fit: BoxFit.cover,
              ),
              title: Text(
                S.of(context).english,
                style: kBaseTextStyle.copyWith(fontSize: 15),
              ),
              onTap: () {
                Provider.of<AppModel>(context, listen: false)
                    .changeLanguage('en', context);
              },
            ),
          ),
          Divider(
            color: Colors.black12,
            height: 1.0,
            indent: 75,
            //endIndent: 20,
          ),
          Card(
            elevation: 0,
            margin: EdgeInsets.all(0),
            child: ListTile(
              leading: Image.asset('assets/images/country/vn.png',
                  width: 30, height: 20, fit: BoxFit.cover),
              title: Text(
                S.of(context).vietnamese,
                style: kBaseTextStyle.copyWith(fontSize: 15),
              ),
              onTap: () {
                Provider.of<AppModel>(context, listen: false)
                    .changeLanguage('vi', context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
