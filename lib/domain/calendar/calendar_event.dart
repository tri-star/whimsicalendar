import 'package:whimsicalendar/widgets/calendar/calendar_event.dart'
    as calendar_widget;

/// カレンダー上のイベント
class CalendarEvent extends calendar_widget.CalendarEvent {
  String id;

  CalendarEvent(
      {this.id,
      String name,
      DateTime startDateTime,
      DateTime endDateTime = null,
      bool isAllDay = false,
      String url = '',
      String description = ''})
      : super(
            name: name,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            isAllDay: isAllDay,
            url: url,
            description: description);
}
