import 'package:flutter_test/flutter_test.dart';
import 'package:whimsicalendar/domain/calendar/calendar_event.dart';
import 'package:whimsicalendar/domain/user/user.dart';
import 'package:whimsicalendar/infrastructure/repositories/calendar_event/stub_calendar_event_repository.dart';
import 'package:whimsicalendar/widgets/calendar/event_collection.dart';

void main() {
  group('StubCalendarEventRepository', () {
    test('保存したイベントを取り出せること', () async {
      StubCalendarEventRepository repository = StubCalendarEventRepository();
      User user = User(id: '1');
      CalendarEvent event =
          CalendarEvent(id: 'a', startDateTime: DateTime(2020, 1, 1));

      repository.save(user, event);

      EventCollection<CalendarEvent> collection =
          await repository.getCalendarEventByMonth(user.id, 2020, 1);

      List<CalendarEvent> registeredEvents = collection.getEventsOn(2020, 1, 1);
      expect(registeredEvents[0].id, event.id);
    });

    test('指定した月のイベントのみ取得できていること', () async {
      StubCalendarEventRepository repository = StubCalendarEventRepository();
      User user = User(id: '1');
      List<CalendarEvent> events = [
        CalendarEvent(id: 'a', startDateTime: DateTime(2020, 1, 1)),
        CalendarEvent(id: 'b', startDateTime: DateTime(2020, 2, 1)),
        CalendarEvent(id: 'c', startDateTime: DateTime(2020, 3, 1))
      ];
      for (CalendarEvent event in events) {
        repository.save(user, event);
      }

      EventCollection<CalendarEvent> collection =
          await repository.getCalendarEventByMonth(user.id, 2020, 2);

      List<CalendarEvent> registeredEvents = collection.getEventsOn(2020, 2, 1);
      expect(registeredEvents[0].id, events[1].id);
    });

    test('指定した月のイベントを複数取得できること', () async {
      StubCalendarEventRepository repository = StubCalendarEventRepository();
      User user = User(id: '1');
      List<CalendarEvent> events = [
        CalendarEvent(id: 'a', startDateTime: DateTime(2020, 1, 1)),
        CalendarEvent(id: 'b', startDateTime: DateTime(2020, 2, 1)),
        CalendarEvent(id: 'c', startDateTime: DateTime(2020, 1, 2))
      ];
      for (CalendarEvent event in events) {
        repository.save(user, event);
      }

      EventCollection<CalendarEvent> collection =
          await repository.getCalendarEventByMonth(user.id, 2020, 1);

      expect(collection.length, 2);

      List<CalendarEvent> registeredEvents = collection.getEventsOn(2020, 1, 1);
      expect(registeredEvents[0].id, events[0].id);
    });

    test('対象が存在しない場合は空のコレクションが返ること', () async {
      StubCalendarEventRepository repository = StubCalendarEventRepository();

      EventCollection<CalendarEvent> collection =
          await repository.getCalendarEventByMonth('1', 2020, 1);

      expect(collection.length, 0);
    });
  });
}
