import 'package:flutter/material.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';

class EventEditPageArguments {
  CalendarEvent event;

  EventEditPageArguments({this.event});
}

class EventEditFormPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    EventEditPageArguments arguments =
        ModalRoute.of(context).settings.arguments;

    return Scaffold(
        appBar: AppBar(title: Text('イベントの編集')), body: EventEditForm(arguments));
  }
}

class EventEditForm extends StatefulWidget {
  final CalendarEvent targetEvent;

  EventEditForm(EventEditPageArguments arguments)
      : targetEvent = arguments.event;

  @override
  State<StatefulWidget> createState() => EventEditFormState();
}

class EventEditFormState extends State<EventEditForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Container(child: Text(widget.targetEvent.name)));
  }
}
