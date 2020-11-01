import 'package:flutter/material.dart';
import 'constants.dart';
import 'constants.dart';
import 'colors.dart';

class AppThemeData {
  final BorderRadius borderRadius = BorderRadius.circular(8);

  final Color colorYellow = Color(0xffffff00);
  final Color colorPrimary = Color(0xffabcdef);

  ThemeData get materialTheme {
    return ThemeData(primaryColor: colorPrimary);
  }
}

var kTextField = InputDecoration(
  border: InputBorder.none,
  hintStyle: textTheme.headline5.copyWith(
    color: theme.hintColor,
  ),
  contentPadding: EdgeInsets.only(left: 12),
);
var kButton = BoxDecoration(
  color: kPrimaryOrange,
  borderRadius: BorderRadius.all(const Radius.circular(16.0)),
);

// var kButton =

ThemeData buildLightTheme() {
  final ThemeData base = ThemeData(fontFamily: 'Nunito');

  return base.copyWith(
    // dividerColor: ,
    // colorScheme: kColorScheme,
    buttonColor: kPrimaryOrange,
    // cardColor: Colors.white,
    // textSelectionColor: kTeal100,
    // errorColor: kErrorRed,
    // buttonTheme: const ButtonThemeData(
    //   // colorScheme: kColorScheme,

    //   textTheme: ButtonTextTheme.normal,
    // ),
    primaryColorLight: kSecondaryWhite,
    // primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    accentTextTheme: _buildTextTheme(base.accentTextTheme),
    // iconTheme: _customIconTheme(base.iconTheme),
    hintColor: kSecondaryGrey.withOpacity(0.5),
    backgroundColor: kDefaultBackground,
    primaryColor: kPrimaryOrange,
    accentColor: kLightAccent,
    cursorColor: kPinkAccent,
    scaffoldBackgroundColor: kDefaultBackground,
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: "Nunito",
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
  return kTextTheme(base).copyWith(
      headline1: base.headline1.copyWith(
          height: 1.25,
          fontStyle: FontStyle.italic,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
          color: kDefaultFontColor),
      headline2: base.headline2.copyWith(
          height: 1.25,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
          color: kDefaultFontColor),
      headline3: base.headline3.copyWith(
          height: 1.25,
          fontSize: 17.0,
          fontWeight: FontWeight.bold,
          color: kDefaultFontColor),
      headline4: base.headline4.copyWith(
          height: 1.25,
          fontSize: 16.0,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: kDefaultFontColor),
      headline5: base.headline5.copyWith(
          height: 1.25,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          color: kDefaultFontColor),
      bodyText1: base.bodyText1.copyWith(
          height: 1.25,
          fontStyle: FontStyle.italic,
          fontSize: 15.0,
          fontWeight: FontWeight.w600,
          color: kDefaultFontColor),
      bodyText2: base.bodyText2.copyWith(
          height: 1.25,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
          color: kDefaultFontColor));
}

extension CustomTextTheme on TextTheme {
  TextStyle get button1 => const TextStyle(
        fontFamily: "Nunito",
        height: 1.25,
        color: kDefaultFontColor,
        fontSize: 15.0,
        fontWeight: FontWeight.bold,
      );
  TextStyle get button2 => const TextStyle(
        fontFamily: "Nunito",
        height: 1.25,
        color: kDefaultFontColor,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      );
  TextStyle get caption1 => const TextStyle(
        fontFamily: "Nunito",
        height: 1.25,
        color: kDefaultFontColor,
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
      );
  TextStyle get caption2 => const TextStyle(
        fontFamily: "Nunito",
        color: kDefaultFontColor,
        height: 1.25,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      );
  Color get info => const Color(0xFF17a2b8);
  Color get warning => const Color(0xFFffc107);
  Color get danger => const Color(0xFFdc3545);
}

extension CustomColorScheme on ColorScheme {
  Color get success => const Color(0xFF28a745);
  Color get info => const Color(0xFF17a2b8);
  Color get warning => const Color(0xFFffc107);
  Color get danger => const Color(0xFFdc3545);
}

// const ColorScheme kColorScheme = ColorScheme(
//   primary: kTeal100,
//   primaryVariant: kGrey900,
//   secondary: kTeal50,
//   secondaryVariant: kGrey900,
//   surface: kSurfaceWhite,
//   background: kDefaultBackground,
//   error: kErrorRed,
//   onPrimary: kGrey900,
//   onSecondary: kGrey900,
//   onSurface: kGrey900,
//   onBackground: kGrey900,
//   onError: kSurfaceWhite,
//   brightness: Brightness.light,
// );

var kBaseTextStyle = TextStyle(
  height: 1.25,
  fontFamily: "Nunito",
  color: kDarkBG,
  fontSize: 15.0,
  fontWeight: FontWeight.w500,
);
