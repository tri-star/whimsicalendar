import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
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
  Widget build(BuildContext context) {
    return Expanded(
        child: CalendarCarousel(
      onDayPressed: (DateTime date, _) {},
      thisMonthDayBorderColor: Colors.grey,
      height: 420.0,
      selectedDateTime: null,
      daysHaveCircularBorder: false,

      /// null for not rendering any border, true for circular border, false for rectangular border
      markedDatesMap: null,
//          weekendStyle: TextStyle(
//            color: Colors.red,
//          ),
//          weekDays: null, /// for pass null when you do not want to render weekDays
      headerText: 'test?',
    )

//                ListView(children: [
//                Text('ユーザーID: ${snapshot.data.id}'),
//                Row(children: [
//                  Text('Photo: '),
//                  Image.network(snapshot.data.photoUrl)
//                ])
//              ]);
        );
  }
}
