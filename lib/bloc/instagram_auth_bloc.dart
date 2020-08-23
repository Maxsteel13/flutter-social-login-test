import 'package:flutter/material.dart';
import 'package:social_login_test/screens/social_login_web_view.dart';
import 'package:social_login_test/services/instagram_auth_service.dart';

class InstagramAuthBloc {
  final instaAuthService = InstagramAuthService();
  String _authorizationCode;

  Future<String> signIn(BuildContext context) async {
    _authorizationCode = null;

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SocialLoginWebView(
                  initialUrl: instaAuthService.getInstaAuthUrl(),
                  redirectionUrlHandler: instaAuthRedirectionHandler,
                  title: "Instagram",
                ),
            maintainState: true));

    return _authorizationCode;
  }

  instaAuthRedirectionHandler(String url, BuildContext context) {
    print(
        "new URL $url ************************************************************************");
    if (url.startsWith(instaAuthService.redirectUrl)) {
      print('SUCCESS BITCH! $url');
      var params = url.split("code=");
      var authorizationCode = params[1];
      _authorizationCode =
          authorizationCode.substring(0, authorizationCode.length - 2);
      print("AUTHORIZATION CODE $authorizationCode");

      Navigator.pop(context);
    }

    //TODO: failure case
    if (url.contains(
        "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
      print("DENIED");
      Navigator.pop(context);
    }
  }
}
