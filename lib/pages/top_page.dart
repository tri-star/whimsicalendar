import 'package:flutter/material.dart';

class TopPage extends StatelessWidget {
  @override
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: [Text('ここにカレンダー表示')],
    ));
  }
}
