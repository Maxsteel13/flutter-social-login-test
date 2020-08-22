import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart';
import 'package:social_login_test/screens/social_login_web_view.dart';
import 'package:social_login_test/screens/twitter_verifier_otp.dart';
import 'package:social_login_test/services/twitter_auth_service.dart';

class TwitterAuthBloc {
  final TwitterAuthService _twitterAuthService = TwitterAuthService();
  AuthorizationResponse _authorizationResponse;

  Future<AuthorizationResponse> signIn(BuildContext context) async {
    _authorizationResponse = null;
    var authPageUrl = await _twitterAuthService.getAuthorizationPage();

    if (authPageUrl != null && authPageUrl.length > 0) {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SocialLoginWebView(
                    initialUrl: authPageUrl,
                    redirectionUrlHandler: twitterAuthRedirectionHandler,
                    title: "Twitter",
                  ),
              maintainState: true));
    }

    return _authorizationResponse;
  }

  twitterAuthRedirectionHandler(String url, BuildContext context) async {
    if (url.startsWith(_twitterAuthService.callbackUrl)) {
      final queryParameters = Uri.parse(url).queryParameters;
      final oauthToken = queryParameters['oauth_token'];
      final oauthVerifier = queryParameters['oauth_verifier'];
      if (null != oauthToken && null != oauthVerifier) {
        _authorizationResponse =
            await _twitterAuthService.signIn(oauthToken, oauthVerifier);
      }
    } else if (url == "https://api.twitter.com/oauth/authorize") {
      String oauthVerifier;
      print("showModalBottomSheet");
      // created the ScaffoldState key
      final scaffoldState = GlobalKey<ScaffoldState>();

      scaffoldState.currentState.showBottomSheet(
        (context) => Container(
//            padding: EdgeInsets.only(
//                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TwitterOtpVerifier(
          onOtpSubmit: (otp) {
            oauthVerifier = otp;
            Navigator.pop(context);
            print("VERIFIER $oauthVerifier");
          },
        )),
      );
    }
  }
}
