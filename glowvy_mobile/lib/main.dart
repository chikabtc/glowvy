import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'app.dart';

void main() async {
  // if (kDebugMode) {
  //   await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  // } else {}

  // FlutterError.onError = (FlutterErrorDetails details) async {
  //   if (kDebugMode) {
  //     // In development mode simply print to console.
  //     FlutterError.dumpErrorToConsole(details);
  //   } else {
  //     // In production mode report to the application zone to report to
  //     // Sentry.
  //     Zone.current.handleUncaughtError(details.exception, details.stack);
  //   }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await runZonedGuarded<Future<Null>>(() async {
    Provider.debugCheckInvalidValueType = null;

    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // final Amplitude analytics = Amplitude.getInstance(instanceName: 'Dimodo');

    var apiKey = '78f34e041572ba05a597df3c0a9d3f23';

    precachePicture(
        ExactAssetPicture(SvgPicture.svgStringDecoder,
            'assets/icons/onborading-illustration-1.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/red-flower.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/yellow-flower.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/nolt-illustration.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/email-illustration.svg'),
        null);

    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/blue-big-logo.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/yellow-flower.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/yellow-flower.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/closed-eye-girl.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/yellow-smiley-face.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/blue-smiley-face.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/arrow-more.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/blue-big-logo.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/ranking-list.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/image-icon.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/red_shield.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/green-shield.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/orange_shield.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/grey_shield.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/review-avartar.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/arrow_forward.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/profile-inactive.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/profile-active.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/home-active.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/home-inactive.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/message-banner.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/pink_logo.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/white_star.svg'),
        null);
    await precachePicture(
        ExactAssetPicture(
            SvgPicture.svgStringDecoder, 'assets/icons/before_login_bg.svg'),
        null);

    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {}
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runApp(Glowvy());
  }, FirebaseCrashlytics.instance.recordError);
}
