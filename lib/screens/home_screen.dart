import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:social_login_test/bloc/social_auth_bloc.dart';
import 'package:social_login_test/screens/landing_screen.dart';

class HomeScreen extends StatelessWidget {
  final socialLoginBloc = SocialAuthBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SignInButton(Buttons.Google, onPressed: () {
                  socialLoginBloc.signInWithGoogle().whenComplete(() => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingScreen(),
                          ),
                        ),
                      });
                }),
                SignInButton(Buttons.Facebook, onPressed: () {
                  socialLoginBloc.signInWithFb().whenComplete(() => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LandingScreen(),
                          ),
                        ),
                      });
                }),
                FlatButton(
                    child: Text("Sign in with Instagram"),
                    onPressed: () async {
                      await socialLoginBloc.signInToInstagram(context);
                    }),
                SignInButton(
                  Buttons.Twitter,
                  onPressed: () async {
                    await socialLoginBloc.signInWithTwitter(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
