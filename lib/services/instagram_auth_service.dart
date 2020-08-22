import 'dart:convert';

import 'package:http/http.dart' as http;

class InstagramAuthService {
  final String redirectUrl =
      'https://test-social-login-52e25.firebaseapp.com/__/insta/auth/handler';
  final String _instaOAuthUrl = 'https://api.instagram.com/oauth';
  final String _instaApiId = '76077642232727297';
  final String _instaApiSecret = '7127525c637e8a95907d0f9069166c0ba7';
  String _instaAuthUrl;
  String _instaAccessTokenUrl;

  InstagramAuthService() {
    _instaAuthUrl = '$_instaOAuthUrl/authorize';
    _instaAccessTokenUrl = '$_instaOAuthUrl/access_token';
  }

  Future<InstagramAuthResult> signIn(String code) async {
    var map = new Map<String, dynamic>();
    map['client_id'] = _instaApiId;
    map['client_secret'] = _instaApiSecret;
    map['grant_type'] = 'authorization_code';
    map['redirect_uri'] = redirectUrl;
    map['code'] = code;

    print("URL $_instaAccessTokenUrl");
    print('BODY $map');
    var accessResponse = await http.post(_instaAccessTokenUrl, body: map);
    var response = InstagramAuthResult(statusCode: accessResponse.statusCode);
    print("RESPONSE RECEIVED ${accessResponse.statusCode}");
    if (accessResponse.statusCode == 200) {
      var jsonBody = jsonDecode(accessResponse.body);
      response.accessToken = jsonBody["access_token"];
      response.userId = jsonBody["user_id"];

      print(
          'ACCESS TOKEN: ${response.accessToken}, USER ID: ${response.userId}');
    } else if (accessResponse.statusCode == 400) {
      var jsonBody = jsonDecode(accessResponse.body);
      response.accessToken = jsonBody["error_type"];
      response.userId = jsonBody["error_message"];

      print(
          'error_type: ${response.accessToken}, error_message: ${response.userId}');
    }

    return response;
  }

  String getInstaAuthUrl() {
    var url =
        '$_instaAuthUrl?client_id=$_instaApiId&redirect_uri=$redirectUrl&scope=user_profile&response_type=code';
    return url;
  }
}

class InstagramAuthResult {
  InstagramAuthResult({this.statusCode});

  int statusCode;
  String accessToken;
  int userId;
}
