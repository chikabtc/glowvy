import 'package:flutter/material.dart';
import '../../common/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'dart:math' show max;

class ProductDescription extends StatefulWidget {
  final String description;

  ProductDescription(this.description);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription>
    with AutomaticKeepAliveClientMixin<ProductDescription> {
  WebViewController _controller;

  double webViewHeight = kScreenSizeHeight;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: max(MediaQuery.of(context).size.height, webViewHeight),
        width: kScreenSizeWidth,
        child: Stack(alignment: Alignment.topCenter, children: <Widget>[
          WebView(
            initialUrl: "",
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: Set.from([
              JavascriptChannel(
                  name: 'Print',
                  onMessageReceived: (JavascriptMessage message) {
                    print("js height: ${message.message}");
                    setState(() {
                      webViewHeight = double.parse(message.message);
                    });
                  })
            ]),
            onWebViewCreated: (WebViewController webViewController) async {
              _controller = webViewController;
              await _controller.loadUrl(Uri.dataFromString(widget.description,
                      mimeType: 'text/html',
                      encoding: Encoding.getByName('utf-8'))
                  .toString());
            },
            onPageStarted: (String url) {},
            onPageFinished: (String url) async {
              _controller.evaluateJavascript(
                  '''window.Print.postMessage(document.body.offsetHeight);''');
              // print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          ),
        ]));
  }
}
