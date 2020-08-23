import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_login_test/bloc/instagram_auth_bloc.dart';
import 'package:social_login_test/bloc/twitter_auth_bloc.dart';
import 'package:social_login_test/services/auth_service.dart';
import 'package:social_login_test/services/instagram_auth_service.dart';

class SocialAuthBloc {
  final _authService = FirebaseAuthService();
  final fbLogin = FacebookLogin();
  final googleLogin = GoogleSignIn();
  final instagramLogin = InstagramAuthService();
  final twitterAuthBloc = TwitterAuthBloc();
  final instagramAuthBloc = InstagramAuthBloc();

  Stream<FirebaseUser> get currentUser => _authService.currentUser;

  signInWithFb() async {
    final authResult = await fbLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (authResult.status) {
      case FacebookLoginStatus.Success:
        //get fb login token
        final fbAccessToken = authResult.accessToken;
        //verify fb login with firebase
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: fbAccessToken.token);
        await signInToFirebase(credential);
        print("FB Login Success!");
        break;
      case FacebookLoginStatus.Error:
        print("FB Login Error!");
        break;
      case FacebookLoginStatus.Cancel:
        print("FB Login Cancel!");
        break;
    }
  }

  signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleLogin.signIn();
    print("SIGNED-IN");
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    await signInToFirebase(credential);
  }

  signInToFirebase(AuthCredential credential) async {
    final AuthResult authResult =
        await _authService.signInWithCredentials(credential);
    final FirebaseUser user = authResult.user;

    //verify login success
    final hasToken = await user.getIdToken() != null;
    final isValidUser = !user.isAnonymous;
    final currentUser = await _authService.getCurrentUser();

    if (hasToken && isValidUser && user.uid == currentUser.uid) {
      //user is logged in successfully
      print("Firebase login success!");
    } else {
      print(
          "Firebase login failed hasToken: $hasToken, isValidUser: $isValidUser");
    }
  }

  signInWithTwitter(BuildContext context) async {
    final tokenCredentialsResponse = await twitterAuthBloc.signIn(context);

    if (tokenCredentialsResponse != null &&
        tokenCredentialsResponse.credentials != null) {
      final credential = TwitterAuthProvider.getCredential(
        authToken: tokenCredentialsResponse.credentials.token,
        authTokenSecret: tokenCredentialsResponse.credentials.tokenSecret,
      );

      await signInToFirebase(credential);
      Navigator.pop(context);
    }
  }

  signInToInstagram(BuildContext context) async {
    final authorizationCode = await instagramAuthBloc.signIn(context);

    final InstagramAuthResult instaResult =
        await instagramLogin.signIn(authorizationCode);
    print("SIGNED-IN");
    final AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: instaResult.accessToken);

    print("FIREBASE BITCH ${instaResult.accessToken}");
  }

  signOutGoogle() async {
    await googleLogin.signOut();
  }

  signOutFacebook() async {
    await fbLogin.logOut();
  }

  signOut() async {
    final currentUser = await _authService.getCurrentUser();
    switch (currentUser.providerId) {
      case "facebook.com":
        signOutFacebook();
        break;
      case "google.com":
        signOutGoogle();
        break;
    }
  }
}
