import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// イベントのリポジトリ
class CalendarEventRepository implements CalendarEventRepositoryInterface {
  @override
  Future<void> save(User user, CalendarEvent event) async {
    if (event.id == null) {
      await FirebaseFirestore.instance
          .collection('calendar_events/${user.id}/events')
          .add({
        'name': event.name,
        'startDateTime': event.startDateTime,
        'endDateTime': event.endDateTime,
        'isAllDay': event.isAllDay,
        'url': event.url,
        'description': event.description
      });
    } else {
      var docRef = FirebaseFirestore.instance
          .collection('calendar_events/${user.id}/events')
          .doc(event.id);

      await docRef.update({
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
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('calendar_events/$userId/events')
        .where('startDateTime', isGreaterThanOrEqualTo: fromDate)
        .where('startDateTime', isLessThan: toDate)
        .orderBy('startDateTime')
        .get();

    List<CalendarEvent> result = List<CalendarEvent>();
    snapshot.docs.forEach((QueryDocumentSnapshot item) {
      result.add(CalendarEvent(
          id: item.id,
          name: item.data()['name'],
          startDateTime: _parseTimeStamp(item.data()['startDateTime']),
          endDateTime: _parseTimeStamp(item.data()['endDateTime']),
          url: item.data()['url'],
          isAllDay: item.data()['isAllDay']));
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
