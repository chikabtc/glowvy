import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:provider/provider.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/user/user.dart';
import 'package:Dimodo/widgets/customWidgets.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/models/category.dart';
import 'package:flutter/cupertino.dart';

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
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool enabledNotification = true;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      checkNotificationPermission();
    });
  }

  void checkNotificationPermission() async {
    try {
      NotificationPermissions.getNotificationPermissionStatus().then((status) {
        if (mounted)
          setState(() {
            enabledNotification = status == PermissionStatus.granted;
          });
      });
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    print("rebuilding category!");
    Provider.of<CategoryModel>(context, listen: false).getLocalCategories;

    final categories =
        Provider.of<CategoryModel>(context, listen: false).categories;

    List<Widget> categoryButtons = [];

    createCategoryButton(List<Category> categories) {
      categories.forEach((cate) => categoryButtons.add(CategoryButton(cate)));
    }

    createCategoryButton(categories);

    TextStyle textStyle = Theme.of(context)
        .textTheme
        .body2
        .copyWith(fontSize: 15, color: kDefaultFontColor);

    return Scaffold(
      body: Container(
        color: Colors.white,
        // margin: EdgeInsets.only(left: 7, right: 7),
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
                  title: DynamicText(S.of(context).categories,
                      style: textStyle.copyWith(
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
                          padding: const EdgeInsets.only(
                              left: 23.0, right: 23.0, bottom: 35),
                          child: DynamicText(
                              S.of(context).categoryScreenDescription,
                              style: kBaseTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: kDarkSecondary)),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                    left: 23.0, right: 23.0, bottom: 35.0),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1,
                    crossAxisCount: 3,
                  ),
                  delegate: new SliverChildBuilderDelegate(
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
