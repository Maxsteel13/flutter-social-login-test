import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oauth1/oauth1.dart';

class TwitterAuthService {
  // define platform (server)
  var platform = new oauth1.Platform(
      'https://api.twitter.com/oauth/request_token', // temporary credentials request
      'https://api.twitter.com/oauth/authorize', // resource owner authorization
      'https://api.twitter.com/oauth/access_token', // token credentials request
      oauth1.SignatureMethods.hmacSha1 // signature method
      );
  String callbackUrl = 'oob';

  // define client credentials (consumer keys)
  final String apiKey = 'qU4nrSH57qajKttNnXJaWRybg';
  final String apiSecret = 'IE1IYT6q29OC05v5RaF2xBdtRF3IjhfFN9SBaEptACDS6oXBmk';
  oauth1.ClientCredentials _clientCredentials;
  oauth1.Authorization _authorization;

  TwitterAuthService() {
    _clientCredentials = new oauth1.ClientCredentials(apiKey, apiSecret);
    // create Authorization object with client credentials and platform definition
    _authorization = new oauth1.Authorization(_clientCredentials, platform);
  }

  Future<String> getAuthorizationPage() async {
    String pageUrl = '';
    // request temporary credentials (request tokens)
    var res = await _authorization.requestTemporaryCredentials(callbackUrl);
    if (res != null) {
      pageUrl = _authorization
          .getResourceOwnerAuthorizationURI(res.credentials.token);
    }

    return pageUrl;
  }

  Future<AuthorizationResponse> signIn(
      String oauthToken, String oauthVerifier) async {
    // Request Access Token
    final tokenCredentialsResponse =
        await _authorization.requestTokenCredentials(
            oauth1.Credentials(oauthToken, ''), oauthVerifier);

    return tokenCredentialsResponse;
  }
}
