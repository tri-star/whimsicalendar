import 'package:flutter/material.dart';
import 'package:whimsicalendar/pages/sign_in_page.dart';

class RouteRegistrar {
  Map<String, Widget Function(BuildContext)> getDefinitions() {
    return {
      '/sign-in': (_) => SignInPage(),
    };
  }
}
