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
    return Column(children: [
      RaisedButton(
          onPressed: () async {
            if (!await Provider.of<AuthenticatorInterface>(context,
                    listen: false)
                .signIn()) {
              print('ログイン失敗');
            }
            Navigator.of(context).pushReplacementNamed('/');
          },
          child: Text('Googleでサインイン'))
    ]);
  }
}
