import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:sentry/sentry.dart';
import 'app.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:amplitude_flutter/amplitude.dart';
// import 'package:amplitude_flutter/identify.dart';

final SentryClient _sentry = new SentryClient(
    dsn:
        "https://866bdef953574dbdb81a7da5d08411da@o376105.ingest.sentry.io/5197560");

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) async {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Sentry.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await runZoned<Future<Null>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Provider.debugCheckInvalidValueType = null;

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    // final Amplitude analytics = Amplitude.getInstance(instanceName: "Dimodo");

    var apiKey = "78f34e041572ba05a597df3c0a9d3f23";

    // // Initialize SDK
    // analytics.init(apiKey);

    // // Enable COPPA privacy guard. This is useful when you choose not to report sensitive user information.
    // analytics.enableCoppaControl();

    // // Set user Id
    // analytics.setUserId("test_user");

    // // Turn on automatic session events
    // analytics.trackingSessionEvents(true);

    // // Log an event
    // analytics.logEvent('Dimodo startup',
    //     eventProperties: {'friend_num': 10, 'is_heavy_user': true});

    // // Identify
    // final Identify identify1 = Identify()
    //   ..set('identify_test',
    //       'identify sent at ${DateTime.now().millisecondsSinceEpoch}')
    //   ..add('identify_count', 1);
    // analytics.identify(identify1);

    // // Set group
    // analytics.setGroup('orgId', 15);

    // Group identify
    // final Identify identify2 = Identify()..set('identify_count', 1);
    // analytics.groupIdentify('orgId', '15', identify2);
    await precachePicture(
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

    await Firebase.initializeApp();

    runApp(Glowvy());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `_reportError` function. This sends
    // Dart errors to the dev console or Sentry depending on the environment.
    await _reportError(error, stackTrace);
  });
}

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<Null> _reportError(dynamic error, dynamic stackTrace) async {
  print('Sentry Caught error: $error');
  // Errors thrown in development mode are unlikely to be interesting. You can
  // check if you are running in dev mode using an assertion and omit sending
  // the report.
  if (isInDebugMode) {
    print(stackTrace);
    print('In dev mode. Not sending report to Sentry.io.');
    return;
  }
  print('Reporting to Sentry.io...');

  final SentryResponse response = await _sentry.captureException(
    exception: error,
    stackTrace: stackTrace,
  );

  if (response.isSuccessful) {
    print('Success! Event ID: ${response.eventId}');
  } else {
    print('Failed to report to Sentry.io: ${response.error}');
  }
}
