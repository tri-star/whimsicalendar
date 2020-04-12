import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/url_sharing/url_sharing_handler_inteface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/infrastructure/auth/stub_authenticator.dart';
import 'package:whimsicalendar/infrastructure/repositories/calendar_event/stub_calendar_repository.dart';
import 'package:whimsicalendar/infrastructure/url_sharing/stub_url_sharing_handler.dart';
import 'package:whimsicalendar/pages/top_page.dart';
import 'package:whimsicalendar/routes.dart';

StubAuthenticator stubAuthenticator;
StubCalendarEventRepository stubCalendarEventRepository;
StubUrlSharingHandler stubUrlSharingHandler;
TestNavigatorObserver testNavigatorObserver;

class TestNavigatorObserver extends NavigatorObserver {
  Route<dynamic> pushedRoute;
  Route<dynamic> poppedRoute;
  Route<dynamic> replacedRoute;

  void init() {
    pushedRoute = null;
    poppedRoute = null;
    replacedRoute = null;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    pushedRoute = route;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    pushedRoute = route;
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    replacedRoute = newRoute;
  }
}

Widget _createPage() {
  return MaterialApp(
    title: 'Whisimicalendar',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: MultiProvider(providers: [
      Provider<AuthenticatorInterface>.value(value: stubAuthenticator),
      Provider<CalendarEventRepositoryInterface>.value(
          value: stubCalendarEventRepository),
      Provider<UrlSharingHandlerInterface>.value(value: stubUrlSharingHandler)
    ], child: TopPage()),
    routes: RouteRegistrar().getDefinitions(),
    navigatorObservers: [testNavigatorObserver],
  );
}

void main() {
  setUp(() {
    stubAuthenticator = StubAuthenticator();
    stubCalendarEventRepository = StubCalendarEventRepository();
    stubUrlSharingHandler = StubUrlSharingHandler();
    testNavigatorObserver = new TestNavigatorObserver();
    testNavigatorObserver.init();
  });

  group('トップページ', () {
    testWidgets('ログインしていない場合はログイン画面に遷移する', (WidgetTester tester) async {
      await tester.pumpWidget(_createPage());
      tester.binding.scheduleWarmUpFrame();
      await tester.pump(Duration(milliseconds: 100));

      expect(testNavigatorObserver.replacedRoute.settings.name, '/sign-in');
    });

    testWidgets('ログイン済の場合はトップページを表示する', (WidgetTester tester) async {
      stubAuthenticator.setUserForTest(User());
      await tester.pumpWidget(_createPage());
      tester.binding.scheduleWarmUpFrame();
      await tester.pump(Duration(milliseconds: 100));

      expect(testNavigatorObserver.pushedRoute.settings.name, '/');
    });

    testWidgets('URLのインテントを受けて起動した場合はトップページを表示する', (WidgetTester tester) async {
      stubAuthenticator.setUserForTest(User());
      stubUrlSharingHandler.setUrlForTest('http://example.com/');

      await tester.pumpWidget(_createPage());
      tester.binding.scheduleWarmUpFrame();
      await tester.pump(Duration(milliseconds: 100));

      expect(testNavigatorObserver.pushedRoute.settings.name, '/event/add');
    });
  });
}
