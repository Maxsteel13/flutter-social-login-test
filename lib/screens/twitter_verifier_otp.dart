import 'package:flutter/material.dart';

class TwitterOtpVerifier extends StatelessWidget {
  String oauthVerifierOtp;
  TwitterOtpVerifier({@required this.onOtpSubmit});

  final Function onOtpSubmit;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text(
                "Add Task",
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              cursorColor: Colors.lightBlueAccent,
              onChanged: (value) {
                oauthVerifierOtp = value;
              },
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              color: Colors.lightBlueAccent,
              child: Text(
                "Add",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (onOtpSubmit != null) {
                  onOtpSubmit(oauthVerifierOtp);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
