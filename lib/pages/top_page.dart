import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/calendar.dart';

import 'calendar/calendar_view_model.dart';
import 'event/register_form.dart';

/// トップページ
class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<CalendarViewModel>(create: (_) => CalendarViewModel())
        ],
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
              appBar: AppBar(title: Text('Whisimicalendar')),
              body: Column(children: [CalendarSection()]),
              floatingActionButton: Builder(builder: (BuildContext context) {
                return FloatingActionButton(
                    onPressed: () => _onFloatingActionButtonPressed(context),
                    child: Icon(Icons.add));
              }));
        }));
  }

  /// FABを押下した時の動作
  void _onFloatingActionButtonPressed(BuildContext context) async {
    final registered = await Navigator.of(context).pushNamed('/event/add',
        arguments: EventRegisterPageArguments(
            currentDate: Provider.of<CalendarViewModel>(context, listen: false)
                .currentDate));

    if (registered == true) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text('登録しました。')));
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

      authenticator.getUser().then((user) {
        setState(() {
          _user = user;
        });
      });
    });
  }

  @override
  void didUpdateWidget(CalendarSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    CalendarViewModel viewModel = Provider.of<CalendarViewModel>(context);
    if (viewModel.shouldUpdateEventList()) {
      viewModel.loadEventList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CalendarView(
            controller: Provider.of<CalendarViewModel>(context, listen: false)
                .calendarController));
  }
}
