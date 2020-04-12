import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/infrastructure/auth/google_authenticator.dart';
import 'package:whimsicalendar/infrastructure/firebase/firebase_app.dart';
import 'package:whimsicalendar/routes.dart';

import 'domain/url_sharing/url_sharing_handler_inteface.dart';
import 'infrastructure/url_sharing/url_sharing_handler.dart';
import 'pages/top_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAppInitializer firebaseAppInitializer = FirebaseAppInitializer();
  FirebaseApp firebaseApp = await firebaseAppInitializer.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisimicalendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        Provider<AuthenticatorInterface>(create: (_) => GoogleAuthenticator()),
        Provider<UrlSharingHandlerInterface>(
            create: (BuildContext context) => UrlSharingHandler())
      ], child: TopPage()),
      routes: RouteRegistrar().getDefinitions(),
    );
  }
}
