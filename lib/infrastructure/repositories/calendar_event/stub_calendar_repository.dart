import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event_repository_interface.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

/// イベントのリポジトリ
class StubCalendarEventRepository implements CalendarEventRepositoryInterface {
  @override
  void save(User user, CalendarEvent event) {}

  @override
  Future<EventCollection<CalendarEvent>> getCalendarEventByMonth(
      String userId, int year, int month) async {
    return EventCollection<CalendarEvent>.fromList([]);
  }
}
