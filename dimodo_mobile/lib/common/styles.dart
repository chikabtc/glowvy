import 'package:flutter/material.dart';
import 'constants.dart';

/// basic colors
const kTeal50 = Color(0xFFE0F2F1);
const kTeal100 = Color(0xFF3FC1BE);

const kDefaultBackgroundAvatar = '3FC1BE';
const kDefaultTextColorAvatar = 'EEEEEE';
const kDefaultAdminBackgroundAvatar = 'EEEEEE';
const kDefaultAdminTextColorAvatar = '3FC1BE';

const kTeal400 = Color(0xFF26A69A);
const kGrey900 = Color(0xFF263238);
const kGrey600 = Color(0xFF546E7A);
const kGrey200 = Color(0xFFEEEEEE);
const kGrey400 = Color(0xFF90a4ae);
const kErrorRed = Color(0xFFe74c3c);
const kSurfaceWhite = Color(0xFFFFFBFA);
const kDefaultBackground = Color(0xfff9f9f9);
// const kDefaultBackground = Color(0xffE5E5E5);
const kAccentRed = Color(0xffDB3022);

/// color for theme
const kLightPrimary = Color(0xfffcfcff);
const kLightAccent = Color(0xFF546E7A);
const kDarkAccent = Color(0xFF393E46);
const kPinkAccent = Color(0xffe85a81);
const kGreenPrimary = Color(0xff2AA952);

const kLightPink = Color(0xfff2eaed);
const kDefaultFontColor = Color(0xff393e46);
const kLightBG = Color(0xfff9f9f9);
const kDarkBG = Color(0xff121212);
const kDarkBgLight = Color(0xfff9f9f9);
const kBadgeColor = Colors.red;
const kPureWhite = Color(0xffffffff);
const kDarkSecondary = Color(0xff808080);
// const kLightPurple = Color(0xff7A5AE8).withOpacity(0.1);
const kAccentPurple = Color(0xff7A5AE8);

const kProductTitleStyleLarge = const TextStyle(
    fontFamily: "BeVietnam", fontSize: 18, fontWeight: FontWeight.bold);

const kTextField = InputDecoration(
  hintText: 'Enter your value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(3.0)),
  ),
);

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: kGrey900);
}

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData(fontFamily: 'BeVietnam');
  return base.copyWith(
    colorScheme: kColorScheme,
    buttonColor: kPinkAccent,
    cardColor: Colors.white,
    textSelectionColor: kTeal100,
    errorColor: kErrorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: kColorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryColorLight: kLightBG,
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
    hintColor: Colors.black26,
    backgroundColor: kDefaultBackground,
    primaryColor: kLightPrimary,
    accentColor: kLightAccent,
    cursorColor: kPinkAccent,
    scaffoldBackgroundColor: kDefaultBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: "BeVietnam",
          color: kDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: kLightAccent,
      ),
    ),
  );
}

TextTheme _buildTextTheme(TextTheme base) {
  return kTextTheme(base)
      .copyWith(
        headline: base.headline
            .copyWith(fontWeight: FontWeight.w500, color: Colors.red),
        title: base.title.copyWith(
            fontSize: 18.0, fontFamily: "BeVietnam", color: kDefaultFontColor),
        caption: base.caption.copyWith(
            fontFamily: "BeVietnam",
            fontWeight: FontWeight.w400,
            fontSize: 14.0,
            color: kDefaultFontColor),
        // body1: :base.bod,
        body2: base.body2.copyWith(
          fontFamily: "BeVietnam",
          fontWeight: FontWeight.w400,
          fontSize: 16.0,
          color: kDefaultFontColor,
        ),
        button: base.button.copyWith(
          fontFamily: "BeVietnam",
          fontWeight: FontWeight.w400,
          fontSize: 14.0,
          color: kDefaultFontColor,
        ),
      )
      .apply(
        displayColor: kGrey900,
        bodyColor: kGrey900,
      )
      .copyWith(headline: kHeadlineTheme(base).headline.copyWith());
}

const ColorScheme kColorScheme = ColorScheme(
  primary: kTeal100,
  primaryVariant: kGrey900,
  secondary: kTeal50,
  secondaryVariant: kGrey900,
  surface: kSurfaceWhite,
  background: kDefaultBackground,
  error: kErrorRed,
  onPrimary: kGrey900,
  onSecondary: kGrey900,
  onSurface: kGrey900,
  onBackground: kGrey900,
  onError: kSurfaceWhite,
  brightness: Brightness.light,
);

ThemeData buildDarkTheme() {
  final ThemeData base = ThemeData.dark();
  return base.copyWith(
    cardColor: kDarkBgLight,
    brightness: Brightness.dark,
    backgroundColor: kDarkBG,
    primaryColor: kDarkBG,
    primaryColorLight: kDarkBgLight,
    accentColor: kDarkAccent,
    scaffoldBackgroundColor: kDefaultBackground,
    cursorColor: kPinkAccent,
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: "BeVietnam",
          color: kDarkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
      iconTheme: IconThemeData(
        color: kDarkAccent,
      ),
    ),
  );
}

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: kTeal400, width: 2.0),
  ),
);

const kSendButtonTextStyle = TextStyle(
  color: kTeal400,
  fontFamily: "BeVietnam",
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

var kBaseTextStyle = TextStyle(
  height: 1.25,
  fontFamily: "BeVietnam",
  color: kDarkBG,
  fontSize: 15.0,
  fontWeight: FontWeight.w400,
);
