import 'package:flutter/material.dart';
import 'package:whimsicalendar/pages/event/register_form.dart';
import 'package:whimsicalendar/pages/sign_in_page.dart';

import 'pages/about.dart';
import 'pages/event/edit_form.dart';

class RouteRegistrar {
  Map<String, Widget Function(BuildContext)> getDefinitions() {
    return {
      '/sign-in': (_) => SignInPage(),
      '/event/add': (_) => EventRegisterPage(),
      '/event/edit': (_) => EventEditFormPage(),
      '/about': (_) => AboutPage(),
    };
  }
}
