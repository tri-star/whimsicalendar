import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/infrastructure/auth/google_authenticator.dart';
import 'package:whimsicalendar/routes.dart';

import 'pages/top_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisimicalendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        Provider<AuthenticatorInterface>(create: (_) => GoogleAuthenticator())
      ], child: TopPage()),
      routes: RouteRegistrar().getDefinitions(),
    );
  }
}
