import 'package:flutter/material.dart';
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
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        brightness: Brightness.light,
        leading: IconButton(
          icon: CommonIcons.arrowBackward,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
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
            if (isLoading) kLoadingWidget(context),
          ],
        ),
      ),
    );
  }
}
