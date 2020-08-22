import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_login_test/bloc/social_auth_bloc.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  StreamSubscription<FirebaseUser> loggedInUserStream;
  final _socialAuthBloc = SocialAuthBloc();

  void getCurrentUser() {
    loggedInUserStream = _socialAuthBloc.currentUser.listen((event) {
      if (event == null) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    loggedInUserStream.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: StreamBuilder<FirebaseUser>(
          stream: _socialAuthBloc.currentUser,
          builder: (context, snapshot) {
            final hasData = snapshot.hasData;
            final data = snapshot.data;
            final displayName = hasData ? data.displayName : "";
            final photoUrl = hasData ? data.photoUrl : "";
            return Column(
              children: [
                Text(
                  displayName,
                  style: TextStyle(fontSize: 35),
                ),
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(photoUrl),
                  radius: 60,
                ),
                FlatButton(
                  onPressed: () async {
                    await _socialAuthBloc.signOut();
                    Navigator.pop(context);
                  },
                  child: Text("Sign-out"),
                )
              ],
            );
          },
        )),
      ),
    );
  }
}
