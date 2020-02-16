import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';

/// イベントのリポジトリ
class CalendarEventRepository implements CalendarEventRepositoryInterface {
  @override
  void save(User user, CalendarEvent event) {
    if (event.id == null) {
      Firestore.instance.collection('calendar_events/${user.id}/events').add({
        'name': event.name,
        'startDateTime': event.startDateTime,
        'endDateTime': event.endDateTime,
        'isAllDay': event.isAllDay,
        'url': event.url,
        'description': event.description
      });
    }
  }
}
