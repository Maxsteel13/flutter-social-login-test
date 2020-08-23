import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SocialLoginWebView extends StatefulWidget {
  final Function(String, BuildContext) redirectionUrlHandler;
  final String initialUrl;
  final String title;

  SocialLoginWebView(
      {@required this.initialUrl,
      @required this.redirectionUrlHandler,
      @required this.title});

  @override
  _SocialLoginWebViewState createState() => _SocialLoginWebViewState();
}

class _SocialLoginWebViewState extends State<SocialLoginWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("INITIAL URL ${widget.initialUrl} *************************");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Container(
            child: WebView(
              initialUrl: widget.initialUrl,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print("onPageStarted $url %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
              },
              onPageFinished: (String url) {
                print("onPageFinished $url %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
                widget.redirectionUrlHandler(url, context);
              },
            ),
          );
        },
      ),
    );
  }
}
