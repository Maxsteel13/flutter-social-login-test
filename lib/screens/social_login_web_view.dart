import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:social_login_test/screens/twitter_verifier_otp.dart';

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
  final flutterWebViewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      print("CHANGED Url $url");
      if (widget.redirectionUrlHandler != null) {
        widget.redirectionUrlHandler(url, context);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.initialUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text(widget.title),
        ));
  }
}
