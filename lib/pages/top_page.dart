import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/url_sharing/url_sharing_handler_inteface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/pages/event/edit_form.dart';
import 'package:whimsicalendar/widgets/calendar/calendar.dart';

import 'calendar/calendar_view_model.dart';
import 'event/register_form.dart';

/// トップページ
class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<CalendarViewModel>(
              create: (BuildContext context) => CalendarViewModel(
                  authenticator: Provider.of<AuthenticatorInterface>(context,
                      listen: false),
                  calendarEventRepository:
                      Provider.of<CalendarEventRepositoryInterface>(context,
                          listen: false))),
        ],
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(title: Text('Whisimicalendar')),
              body: Column(children: [CalendarSection()]),
              drawer: _buildDrawer(context),
              floatingActionButton: Builder(builder: (BuildContext context) {
                return FloatingActionButton(
                    onPressed: () => _onFloatingActionButtonPressed(context),
                    child: Icon(Icons.add));
              }));
        }));
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: [
      Container(
        decoration: BoxDecoration(color: Colors.blue),
        height: 80,
        alignment: Alignment.centerLeft,
        child: ListTile(
            title: Text('Menu', style: TextStyle(color: Colors.white))),
      ),
      ListTile(
          title: Text('このアプリについて'),
          onTap: () async {
            await Navigator.of(context).pushNamed('/about');
            Navigator.of(context).pop();
          }),
      ListTile(
          title: Text('ライセンス情報'),
          onTap: () async {
            showLicensePage(
              context: context,
            );
          }),
    ]));
  }

  /// FABを押下した時の動作
  void _onFloatingActionButtonPressed(BuildContext context) async {
    //FirebaseCrashlytics.instance.log('test message.');
    //FirebaseCrashlytics.instance.crash();
    //throw StateError('test error3');
    final registered = await Navigator.of(context).pushNamed('/event/add',
        arguments: EventRegisterPageArguments(
            currentDate: Provider.of<CalendarViewModel>(context, listen: false)
                .currentDate));

    if (registered == true) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('登録しました。')));
      CalendarViewModel viewModel =
          Provider.of<CalendarViewModel>(context, listen: false);
      viewModel.loadEventList();
    }
  }
}

class CalendarSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarSectionState();
}

class CalendarSectionState extends State<CalendarSection> {
  User _user;

  @override
  void initState() {
    super.initState();

    _user = null;
    WidgetsBinding.instance.addPostFrameCallback((Duration d) async {
      var authenticator =
          Provider.of<AuthenticatorInterface>(context, listen: false);
      if (!await authenticator.isAuthenticated()) {
        Navigator.of(context).pushReplacementNamed('/sign-in');
        return;
      }

      _user = await authenticator.getUser();

      //アプリケーションの起動中にURLのインテントを受け取った場合
      Provider.of<UrlSharingHandlerInterface>(context, listen: false)
          .subscribe((String sharedUrl) async {
        await Navigator.of(context).pushNamed('/event/add',
            arguments: EventRegisterPageArguments(url: sharedUrl));
      });

      //URLのインテントを受け取って起動した場合
      String sharedUrl =
          await Provider.of<UrlSharingHandlerInterface>(context, listen: false)
              .getInitialUrlIntent();
      if (sharedUrl != null) {
        print(sharedUrl);
        await Navigator.of(context).pushNamed('/event/add',
            arguments: EventRegisterPageArguments(url: sharedUrl));
      }

      CalendarViewModel viewModel =
          Provider.of<CalendarViewModel>(context, listen: false);
      viewModel
        ..init(onDateLongTapped: onDateLongTapped)
        ..loadEventList();
    });
  }

  void onDateLongTapped(DateTime dateTime, List<CalendarEvent> events) async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('予定一覧'),
            children: [
              for (var event in events)
                GestureDetector(
                    onTap: () async {
                      await onTapEvent(context, event);
                      Navigator.pop(context, true);
                    },
                    child:
                        Column(children: [ListTile(title: Text(event.name))]))
            ],
          );
        });
  }

  void onTapEvent(BuildContext context, CalendarEvent event) async {
    var arguments = EventEditPageArguments(event: event);
    await Navigator.pushNamed(context, '/event/edit', arguments: arguments);
  }

  @override
  void didUpdateWidget(CalendarSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    CalendarViewModel viewModel = Provider.of<CalendarViewModel>(context);
    if (viewModel.shouldUpdateEventList()) {
      viewModel.loadEventList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CalendarView(
            controller: Provider.of<CalendarViewModel>(context, listen: false)
                .calendarController));
  }

  @override
  dispose() {
    super.dispose();
  }
}
