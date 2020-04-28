import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

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

  @override
  Future<EventCollection<CalendarEvent>> getCalendarEventByMonth(
      String userId, int year, int month) async {
    DateTime fromDate = DateTime(year, month, 1);
    DateTime toDate = DateTime(year, month + 1, 1, 0, 0, 0);
    QuerySnapshot snapshot = await Firestore.instance
        .collection('calendar_events/$userId/events')
        .where('startDateTime', isGreaterThanOrEqualTo: fromDate)
        .where('startDateTime', isLessThan: toDate)
        .orderBy('startDateTime')
        .getDocuments();

    List<CalendarEvent> result = List<CalendarEvent>();
    snapshot.documents.forEach((DocumentSnapshot item) {
      result.add(CalendarEvent(
          id: item.documentID,
          name: item['name'],
          startDateTime: _parseTimeStamp(item['startDateTime']),
          endDateTime: _parseTimeStamp(item['endDateTime']),
          url: item['url'],
          isAllDay: item['isAllDay']));
    });

    return EventCollection<CalendarEvent>.fromList(result);
  }

  DateTime _parseTimeStamp(Timestamp time) {
    if (time == null) {
      return null;
    }
    return time.toDate();
  }
}
