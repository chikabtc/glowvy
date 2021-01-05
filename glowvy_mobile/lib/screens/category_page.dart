import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/constants.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:Dimodo/generated/i18n.dart';
import 'package:Dimodo/models/category.dart';
import 'package:Dimodo/models/categoryModel.dart';
import 'package:Dimodo/widgets/categories/CategoryButton.dart';
import 'package:Dimodo/widgets/second_category_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage();

  @override
  State<StatefulWidget> createState() {
    return CategoryPageState();
  }
}

class CategoryPageState extends State<CategoryPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  List<Category> categories = [];
  Category currentFirstCategory;

  //category variable
  //second cate variable
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('holy shit');

    return Scaffold(
      appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0,
          leading: backIcon(context),
          backgroundColor: Colors.white,
          title: Text(S.of(context).categories, style: textTheme.headline3)),
      backgroundColor: kDefaultBackground,
      body: Row(
        children: [
          Container(
              width: 80,
              decoration: const BoxDecoration(
                  color: kQuaternaryGrey,
                  border: Border(
                      right: BorderSide(
                    color: kQuaternaryGrey,
                    width: 0.7,
                  ))),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: categories.length,
                  itemBuilder: (context, index) => CategoryButton(
                        categories[index],
                        isSelected: currentFirstCategory == categories[index],
                        onTap: () {
                          setState(() {
                            currentFirstCategory = categories[index];
                          });
                        },
                      ))),
          Container(
            width: kScreenSizeWidth - 80,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: currentFirstCategory.secondCategories.length,
                itemBuilder: (context, index) => SecondCategoryButton(
                    currentFirstCategory.secondCategories[index])),
          )
        ],
      ),
    );
  }
}
