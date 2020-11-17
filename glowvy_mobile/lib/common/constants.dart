// The config app layout variable
// or this value can load online https://json-inspire-ui.inspire.now.sh/config.json - see document
import 'package:Dimodo/common/sizeConfig.dart';
import 'package:Dimodo/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'colors.dart';
import 'styles.dart';

const kAppConfig = 'lib/common/config_en.json';
var kLocalStorage = LocalStorage('Dimodo');

const kDefaultImage =
    'https://trello-attachments.s3.amazonaws.com/5d64f19a7cd71013a9a418cf/640x480/1dfc14f78ab0dbb3de0e62ae7ebded0c/placeholder.jpg';
const kLogoImage = 'assets/images/logo.png';

const kProfileBackground =
    'https://images.unsplash.com/photo-1494253109108-2e30c049369b?ixlib=rb-1.2.1&auto=format&fit=crop&w=3150&q=80';

const welcomeGift =
    'https://media.giphy.com/media/3oz8xSjBmD1ZyELqW4/giphy.gif';

// const kSplashScreen = 'assets/images/splashscreen.flr';
// const kSplashScreen = 'assets/images/splashscreen.png';
const kSplashScreen = 'assets/images/onboarding/splash_page.png';

///Google fonts: https://fonts.google.com/

const debugNetworkProxy = false;

enum kCategoriesLayout { card, column, subCategories, animation, grid }

const kEmptyColor = 0XFFF2F2F2;

const kColorNameToHex = {
  'red': '#ec3636',
  'black': '#000000',
  'white': '#ffffff',
  'green': '#36ec58',
  'grey': '#919191',
  'yellow': '#f6e46a',
  'blue': '#3b35f3'
};

/// Filter value
const kSliderActiveColor = 0xFF2c3e50;
const kSliderInactiveColor = 0x992c3e50;
const kMaxPriceFilter = 1000.0;
const kFilterDivision = 10;

///Screen Size
double kScreenSizeWidth = 414.0;
double kScreenSizeHeight = 814.0;
double kBottomNavigationBarHeight;

const kOrderStatusColor = {
  'processing': '#B7791D',
  'cancelled': '#C82424',
  'refunded': '#C82424',
  'completed': '#15B873'
};

const kLocalKey = {
  'userInfo': 'userInfo',
  'skinScores': 'skinScores',
  'skinType': 'skinType',
  'shippingAddress': 'shippingAddress',
  'recentSearches': 'recentSearches',
  'wishlist': 'wishlist',
  'home': 'home',
  'cart': 'cart'
};

const kGridIconsCategories = [
  {'name': 'home'},
  {'name': 'about'},
  {'name': 'add2'},
  {'name': 'addressBook'},
  {'name': 'advertising'},
  {'name': 'airplay'},
  {'name': 'alarmClock'},
  {'name': 'alarmoff'},
  {'name': 'album'},
  {'name': 'archive2'},
  {'name': 'automotive'},
  {'name': 'biohazard'},
  {'name': 'bookmark2'}
];

Widget kLoadingWidget(context) => Center(
      child: SpinKitFadingCube(
        color: Theme.of(context).primaryColor,
        size: 30.0,
      ),
    );

enum kBlogLayout {
  simpleType,
  fullSizeImageType,
  halfSizeImageType,
  oneQuarterImageType
}

enum kProductLayout { simpleType, fullSizeImageType, halfSizeImageType }

const kProductListLayout = [
  {'layout': 'list', 'image': 'assets/icons/tabs/icon-list.png'},
  {'layout': 'columns', 'image': 'assets/icons/tabs/icon-columns.png'},
  {'layout': 'card', 'image': 'assets/icons/tabs/icon-card.png'},
  {'layout': 'horizontal', 'image': 'assets/icons/tabs/icon-horizon.png'}
];

// var kFullDivider = Divider(
//   color: kSecondaryGrey.withOpacity(0.1),
//   height: 1.0,
//   //endIndent: 20,
// );
const kDivider = Divider(
  color: kQuaternaryGrey,
  height: 0.7,
  thickness: 0.7,
  indent: 15,
);
const kFullDivider = Divider(
  color: kQuaternaryGrey,
  height: 0.7,
  thickness: 0.7,
);

SizeConfig kSizeConfig;
RateMyApp kRateMyApp = RateMyApp(
  preferencesPrefix: 'rateMyApp_',
  minDays: 7,
  minLaunches: 10,
  remindDays: 7,
  remindLaunches: 10,
  googlePlayIdentifier: 'app.dimodo.android',
  appStoreIdentifier: '1506979635',
);
//fb://messaging?id=%@
String kFacebookFBID = '105086787660550';
String kFBDimodoPage = 'fb://profile/$kFacebookFBID';
String kFBMessenger = 'https://www.m.me/glowvy.vn';

String kAccessToken;

List<Product> kProducts;

TextTheme kTextTheme(theme) {
  return GoogleFonts.nunitoTextTheme(theme);
}

TextTheme kHeadlineTheme(theme) {
  return GoogleFonts.latoTextTheme(theme);
}

var theme = buildLightTheme();
var textTheme = buildLightTheme().textTheme;
var colorTheme = buildLightTheme().colorScheme;
