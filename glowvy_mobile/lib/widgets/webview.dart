import 'package:Dimodo/common/colors.dart';
import 'package:Dimodo/common/styles.dart';
import 'package:Dimodo/common/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart' as _widget;

class WebView extends StatefulWidget {
  final String url;
  final String title;
  final Color appBarColor;
  final Color backArrowColor;

  WebView(
      {Key key,
      this.title,
      @required this.url,
      this.appBarColor = kPrimaryBlue,
      this.backArrowColor = Colors.white})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: backIcon(context, color: Colors.white),
        backgroundColor: kPrimaryBlue,
        elevation: 0.0,
        title: Text(
          widget.title ?? '',
          style: kBaseTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: <Widget>[
            _widget.WebView(
              initialUrl: widget.url,
              onPageFinished: (_) {
                setState(() {
                  isLoading = false;
                });
              },
              javascriptMode: _widget.JavascriptMode.unrestricted,
            ),
            if (isLoading)
              const SpinKitThreeBounce(color: kPrimaryBlue, size: 21.0)
          ],
        ),
      ),
    );
  }
}
