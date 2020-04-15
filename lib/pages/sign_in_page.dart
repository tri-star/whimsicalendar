import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/infrastructure/auth/google_authenticator.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('サインイン'),
        ),
        body: MultiProvider(providers: [
          Provider<AuthenticatorInterface>(create: (_) => GoogleAuthenticator())
        ], child: SignInPageBody()));
  }
}

class SignInPageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
              0.0,
              0.5,
              1.0
            ],
                colors: [
              const Color(0xffe8f6fc),
              const Color(0xffbfe8f9),
              const Color(0xff98fde5),
            ])),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Whisimicalendar',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    decoration: TextDecoration.underline)),
            SizedBox(height: 20),
            RaisedButton(
                color: Colors.white,
                shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
                onPressed: () async {
                  if (!await Provider.of<AuthenticatorInterface>(context,
                          listen: false)
                      .signIn()) {
                    print('ログイン失敗');
                  }
                  Navigator.of(context).pushReplacementNamed('/');
                },
                child: Text('Googleでサインイン')),
            SizedBox(height: 100), //余白の調整用
          ])
        ]));
  }
}
