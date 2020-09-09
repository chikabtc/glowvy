import 'package:Dimodo/common/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart' as _widget;
import 'package:Dimodo/widgets/customWidgets.dart';

class WebView extends StatefulWidget {
  final String url;
  final String title;

  WebView({Key key, this.title, @required this.url}) : super(key: key);

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
        leading: CommonIcons.backIcon(context, Colors.white),
        backgroundColor: kPrimaryBlue,
        elevation: 0.0,
        title: Text(widget.title ?? ''),
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
            if (isLoading) SpinKitThreeBounce(color: kPrimaryBlue, size: 21.0)
          ],
        ),
      ),
    );
  }
}
