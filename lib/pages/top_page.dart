import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whimsicalendar/auth/authenticator_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Whisimicalendar')),
      body: Column(children: [CalendarSection()]),
      floatingActionButton:
          FloatingActionButton(onPressed: () => {}, child: Icon(Icons.add)),
    );
  }
}

class CalendarSection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarSectionState();
}

class CalendarSectionState extends State<CalendarSection> {
  User _user = null;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((Duration d) async {
      print('called.');
      var authenticator =
          Provider.of<AuthenticatorInterface>(context, listen: false);
      if (!await authenticator.isAuthenticated()) {
        Navigator.of(context).pushReplacementNamed('/sign-in');
        return;
      }

      _user = await authenticator.getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [Text('ここにカレンダー表示')],
    ));
  }
}
