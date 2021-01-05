import 'dart:convert';
import 'dart:math';

import 'package:Dimodo/models/product/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:quiver/strings.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:validate/validate.dart';

import 'config.dart';
import 'constants.dart';

enum kSize { small, medium, large }

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class Tools {
  static String getUserAgeGroup(int birthYear) {
    if (birthYear != null) {
      final userAge = DateTime.now().year - birthYear;
      if (userAge > 34) {
        return 'từ 35';
      } else if (userAge <= 34 && userAge > 29) {
        return 'từ 30 đến 34';
      } else if (userAge <= 29 && userAge > 24) {
        return 'Từ 25 đến 29';
      } else if (userAge <= 24 && userAge > 20) {
        return 'từ 20 đến 24';
      } else {
        return 'dưới 20';
      }
    }
  }

  static List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  // static int getMaxAgeFromAgeGroups(String ageGroup) {
  //   if (ageGroup == 'từ 35') {
  //     return 100;}

  //     else if (ageGroup == 'từ 30 đến 34') {
  //       return 34;
  //     } else if (userAge <= 29 && userAge > 24) {
  //       return 'Từ 25 đến 29';
  //     } else if (userAge <= 24 && userAge > 20) {
  //       return 'từ 20 đến 24';
  //     } else {
  //       return 'dưới 20';
  //     }
  //   }
  // }

  static String formatDateString(String date) {
    final timeFormat = DateTime.parse(date);
    final timeDif = DateTime.now().difference(timeFormat);
    return timeago.format(DateTime.now().subtract(timeDif), locale: 'en');
  }

  static String formatImage(String url, [kSize size = kSize.medium]) {
    if (serverConfig['type'] == 'woo') {
      final pathWithoutExt = p.withoutExtension(url);
      final ext = p.extension(url);
      var imageURL = url ?? kDefaultImage;

      if (ext == '.jpeg') {
        imageURL = url;
      } else {
        switch (size) {
          case kSize.large:
            imageURL = '$pathWithoutExt-large$ext';
            break;
          case kSize.small:
            imageURL = '$pathWithoutExt-small$ext';
            break;
          default: // kSize.medium:e
            imageURL = '$pathWithoutExt-medium$ext';
            break;
        }
      }

      return imageURL;
    } else {
      return url;
    }
  }

  static Future sendSlackMessage(String messageText) async {
    //Slack's Webhook URL
    var url =
        'https://hooks.slack.com/services/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';

    //Makes request headers
    final requestHeader = <String, String>{
      'Content-type': 'application/json',
    };

    final request = {
      'text': messageText,
    };

    await http.post(url, body: json.encode(request), headers: requestHeader);
  }

  static NetworkImage networkImage(String url, [kSize size = kSize.medium]) {
    return NetworkImage(formatImage(url, size) ?? kDefaultImage);
  }

  /// Smart image function to load image cache and check empty URL to return empty box
  /// Only apply for the product image resize with (small, medium, large)
  static Widget image({
    String url,
    kSize size,
    double width,
    double height,
    BoxFit fit,
    String tag,
    double offset = 0.0,
    bool isResize = false,
    isVideo = false,
  }) {
    if (url == null || url == '') {
      return Image.network(
        kDefaultImage,
        width: width,
        height: height,
        color: Color(kEmptyColor),
      );
    }

    if (isVideo) {
      return Stack(
        children: <Widget>[
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(color: Colors.black12.withOpacity(1)),
            child: ExtendedImage.network(
              isResize ? formatImage(url, size) : url,
              width: width,
              height: height,
              fit: fit,
              cache: true,
              enableLoadState: false,
              alignment: Alignment(
                  (offset >= -1 && offset <= 1)
                      ? offset
                      : (offset > 0)
                          ? 1.0
                          : -1.0,
                  0.0),
            ),
          ),
          Positioned.fill(
            child: Icon(
              Icons.play_circle_outline,
              color: Colors.white70.withOpacity(0.5),
              size: width == null ? 30 : height / 1.7,
            ),
          ),
        ],
      );
    }

    return ExtendedImage.network(
      isResize ? formatImage(url, size) : url,
      width: width,
      height: height,
      fit: fit,
      cache: true,
      enableLoadState: false,
      alignment: Alignment(
          (offset >= -1 && offset <= 1)
              ? offset
              : (offset > 0)
                  ? 1.0
                  : -1.0,
          0.0),
    );
  }

  static String getfinaliantPriceProductValue(product, String currency,
      {bool onSale = false}) {
    final price = onSale == true
        ? (isNotBlank(product.salePrice) ? product.salePrice : product.price)
        : product.price;
    if (product.multiCurrencies != null &&
        product.multiCurrencies[currency] != null) {
      return product.multiCurrencies[currency]['price'];
    } else {
      return price;
    }
  }

  static String getPriceProductValue(Product product, String currency,
      {bool onSale = false}) {
    final price = product.sprice.toString();
    try {
      final basePrice = double.parse(price ?? 0);
      final convertedP = basePrice * 21.5;
      return convertedP.toString();
    } catch (e) {
      return '0';
    }
  }

  static String getPriceProduct(Product product, String currency,
      {bool onSale = false}) {
    final price = getPriceProductValue(product, currency, onSale: onSale);
    return getCurrecyFormatted(price, currency: currency);
  }

  static String getCurrecyFormatted(price, {currency}) {
    Map<String, dynamic> defaultCurrency = kAdvanceConfig['DefaultCurrency'];
    List currencies = kAdvanceConfig['Currencies'] ?? [];
    if (currency != null && currencies.isNotEmpty) {
      currencies.forEach((item) {
        if ((item as Map)['currency'] == currency) {
          defaultCurrency = item;
        }
      });
    }

    final formatCurrency = NumberFormat.currency(
        symbol: '', decimalDigits: defaultCurrency['decimalDigits']);
    try {
      var number = '';
      if (price is String) {
        final basePrice = double.parse(price ?? 0);
        // final convertedP = basePrice * 19;

        number = formatCurrency.format(price.isNotEmpty ? basePrice : 0);
      } else {
        number = formatCurrency.format(price);
      }
      return defaultCurrency['symbolBeforeTheNumber']
          ? defaultCurrency['symbol'] + number
          : number + defaultCurrency['symbol'];
    } catch (err) {
      return defaultCurrency['symbolBeforeTheNumber']
          ? defaultCurrency['symbol'] + formatCurrency.format(0)
          : formatCurrency.format(0) + defaultCurrency['symbol'];
    }
  }

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    final size = query.size;
    final diagonal =
        sqrt((size.width * size.width) + (size.height * size.height));
    final isTablet = diagonal > 1100.0;
    return isTablet;
  }

  /// cache avatar for the chat
  static Widget getCachedAvatar(String avatarUrl) {
    return CachedNetworkImage(
      imageUrl: avatarUrl,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}

class Validator {
  static String validateEmail(String value) {
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }
}

class CustomerSupport {
  //open in the in-app-browser instead of goign to the different
  static void openFacebookMessenger(context) async {
    try {
      final launched = await launch(kFBMessenger, forceSafariVC: false);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => WebView(
      //             url: 'https://www.m.me/Dimodo.vn', title: 'Ask Anything!')));
      if (!launched) {
        await launch(kFBDimodoPage, forceSafariVC: false);
      }
    } catch (e) {
      await launch(kFBDimodoPage, forceSafariVC: false);
    }
  }
}

class Videos {
  static String getVideoLink(String content) {
    String videoUrl;
    if (_getYoutubeLink(content) != null) {
      videoUrl = _getYoutubeLink(content);
      return videoUrl;
    } else if (_getFacebookLink(content) != null) {
      videoUrl = _getFacebookLink(content);
      return videoUrl;
    } else {
      videoUrl = _getVimeoLink(content);
      return videoUrl;
    }
  }

  static String _getYoutubeLink(String content) {
    final regExp = RegExp(
        'https://www.youtube.com/((v|embed))\/?[a-zA-Z0-9_-]+',
        multiLine: true,
        caseSensitive: false);

    String youtubeUrl;

    try {
      final matches = regExp.allMatches(content);
      youtubeUrl = matches.first.group(0);
    } catch (error) {}
    return youtubeUrl;
  }

  static String _getFacebookLink(String content) {
    final regExp = RegExp(
        'https://www.facebook.com\/[a-zA-Z0-9\.]+\/videos\/(?:[a-zA-Z0-9\.]+\/)?([0-9]+)',
        multiLine: true,
        caseSensitive: false);

    String facebookVideoId;
    String facebookUrl;
    try {
      final matches = regExp.allMatches(content);
      facebookVideoId = matches.first.group(1);
//      print(
//          'facebook regex ${matches.map((m) => facebookVideoId = m.group(1))}');
      if (facebookVideoId != null) {
        facebookUrl =
            'https://www.facebook.com/video/embed?video_id=$facebookVideoId';
      }
    } catch (error) {}
    return facebookUrl;
  }

  static String _getVimeoLink(String content) {
    final regExp = RegExp('https://player.vimeo.com/((v|video))\/?[0-9]+',
        multiLine: true, caseSensitive: false);

    String vimeoUrl;

    try {
      final matches = regExp.allMatches(content);
      vimeoUrl = matches.first.group(0);
//      print('vimeo regex${matches.map((m) => vimeoUrl = m.group(0))}');
    } catch (error) {}
    return vimeoUrl;
  }
}
