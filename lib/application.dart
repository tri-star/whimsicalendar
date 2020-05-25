import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/infrastructure/auth/google_authenticator.dart';
import 'package:whimsicalendar/routes.dart';
import 'domain/calendar/calendar_event_repository_interface.dart';
import 'domain/url_sharing/url_sharing_handler_inteface.dart';
import 'infrastructure/repositories/calendar_event/calendar_repository.dart';
import 'infrastructure/url_sharing/url_sharing_handler.dart';
import 'pages/top_page.dart';


class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisimicalendar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        Provider<AuthenticatorInterface>(create: (_) => GoogleAuthenticator()),
        Provider<CalendarEventRepositoryInterface>(
            create: (BuildContext context) => CalendarEventRepository()),
        Provider<UrlSharingHandlerInterface>(
            create: (BuildContext context) => UrlSharingHandler())
      ], child: TopPage()),
      routes: RouteRegistrar().getDefinitions(),
    );
  }
}
