import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'application.dart';
import 'config.dart';

void main() {
  Config config = Config(flavor: 'develop');

  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runZoned<Future<void>>(() async {
    runApp(MultiProvider(
        providers: [Provider<Config>.value(value: config)],
        child: Application()));
  }, onError: Crashlytics.instance.recordError);
}
