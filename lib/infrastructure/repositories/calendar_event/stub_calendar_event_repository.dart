import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// イベントのリポジトリ
class StubCalendarEventRepository implements CalendarEventRepositoryInterface {
  Map<String, EventCollection<CalendarEvent>> _store = {};

  @override
  void save(User user, CalendarEvent event) {
    String key =
        _getKey(user.id, event.startDateTime.year, event.startDateTime.month);

    if (!_store.containsKey(key)) {
      _store[key] = EventCollection<CalendarEvent>();
    }

    _store[key].add(event);
  }

  @override
  Future<EventCollection<CalendarEvent>> getCalendarEventByMonth(
      String userId, int year, int month) async {
    String key = _getKey(userId, year, month);
    return _store[key] ?? EventCollection<CalendarEvent>();
  }

  String _getKey(String userId, int year, int month) {
    return "${userId}__${year}__$month";
  }
}
