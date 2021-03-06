import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';

import 'package:Dimodo/models/search_model.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;

  CategoryScreen({this.user, this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return CategoryScreenState();
  }
}

class CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin<CategoryScreen> {
  bool enabledNotification = true;
  List<Widget> categoryButtons = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenSize = MediaQuery.of(context).size;
    print('rebuilding category!');

    final categories =
        Provider.of<SearchModel>(context, listen: false).categories;
    // print('categories length: ${categories.length}');

    // print('categories?: ${categories[0].image}');

    categories.forEach((cate) => categoryButtons.add(CategoryButton(cate)));

    return Scaffold(
      body: Container(
        color: Colors.white,
        width: screenSize.width,
        height: screenSize.height,
        child: CustomScrollView(
            physics: NeverScrollableScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                brightness: Brightness.light,
                leading: Container(),
                elevation: 0,
                backgroundColor: Colors.white,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(S.of(context).categories,
                      style: textTheme.headline3.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              left: 23.0, right: 23.0, bottom: 35),
                          child: Text(S.of(context).categoryScreenDescription,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: kSecondaryGrey)),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 23.0, right: 23.0, bottom: 35.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 4,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => CategoryButton(categories[index]),
                    childCount: categories.length,
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
